import Foundation

struct APIStory: Codable {
    let id: Int
    let by: String?
    let time: Date
    let title: String?
    let score: Int?
    let url: String?
    
    enum CodingKeys: String, CodingKey {
        case id, by, time, title, score, url
    }
    
    init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            id = try container.decode(Int.self, forKey: .id)
            by = try container.decodeIfPresent(String.self, forKey: .by)
            title = try container.decodeIfPresent(String.self, forKey: .title)
            score = try container.decodeIfPresent(Int.self, forKey: .score)
            url = try container.decodeIfPresent(String.self, forKey: .url)
            
            // Обработка строковой даты
            let timeString = try container.decode(String.self, forKey: .time)
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            
            if let date = formatter.date(from: timeString) {
                time = date
            } else {
                let customFormatter = DateFormatter()
                customFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                customFormatter.locale = Locale(identifier: "en_US_POSIX")
                customFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                
                guard let date = customFormatter.date(from: timeString) else {
                    throw DecodingError.dataCorruptedError(
                        forKey: .time,
                        in: container,
                        debugDescription: "Unsupported date format: \(timeString)"
                    )
                }
                time = date
            }
    }
}

struct CommentNode: Codable {
    let id: Int
    let by: String?
    let time: Date
    let text: String?
    let kids: [CommentNode]?
    enum CodingKeys: String, CodingKey {
        case id, by, time, text, kids
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        by = try container.decodeIfPresent(String.self, forKey: .by)
        text = try container.decodeIfPresent(String.self, forKey: .text)
        if let kidsArray = try? container.decodeIfPresent([CommentNode].self, forKey: .kids) {
            kids = kidsArray
        } else {
            kids = nil
        }
        let timeString = try container.decode(String.self, forKey: .time)
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        if let date = formatter.date(from: timeString) {
            time = date
        } else {
            let customFormatter = DateFormatter()
            customFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            customFormatter.locale = Locale(identifier: "en_US_POSIX")
            customFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            time = customFormatter.date(from: timeString) ?? Date()
        }
    }
}

struct ItemResponse: Codable {
    let kids: [CommentNode]?
}
class APIService {
    private let baseURL = "http://192.168.31.156:8000/api/v1"
    func fetchTopStories(completion: @escaping ([News]?, Error?) -> Void) {
        guard let url = URL(string: baseURL + "/topstories") else {
            completion(nil, NSError(domain: "Invalid URL", code: 400))
            return
        }
        let decoder = JSONDecoder()
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil, error)
                return
            }
            if let dataString = String(data: data, encoding: .utf8) {
                print("Received data: \(dataString)")
            }
            do {
                let stories = try decoder.decode([APIStory].self, from: data)
                let newsItems = stories.map { story in
                    News(
                        id: story.id,
                        title: story.title ?? "No title",
                        author: story.by ?? "Unknown",
                        date: self.formatDate(story.time),
                        rating: story.score ?? 0,
                        isFavorite: false,
                        url: story.url ?? "http://192.168.31.156:8000/api/v1/topstories",
                    )
                }
                completion(newsItems, nil)
            } catch {
                print("Decoding error: \(error)")
                completion(nil, error)
            }
        }.resume()
    }
    func fetchNewStories(completion: @escaping ([News]?, Error?) -> Void) {
        guard let url = URL(string: baseURL + "/newstories") else {
            completion(nil, NSError(domain: "Invalid URL", code: 400))
            return
        }
        let decoder = JSONDecoder()
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil, error)
                return
            }
            do {
                let stories = try decoder.decode([APIStory].self, from: data)
                let newsItems = stories.map { story in
                    News(
                        id: story.id,
                        title: story.title ?? "No title",
                        author: story.by ?? "Unknown",
                        date: self.formatDate(story.time),
                        rating: story.score ?? 0,
                        isFavorite: false,
                        url: story.url ?? "http://192.168.31.156:8000/api/v1/topstories",
                    )
                }
                completion(newsItems, nil)
            } catch {
                print("Decoding error: \(error)")
                completion(nil, error)
            }
        }.resume()
    }
    func fetchComments(forStoryId id: Int, completion: @escaping ([Comments]?, Error?) -> Void) {
        guard let url = URL(string: baseURL + "/items/\(id)") else {
            completion(nil, NSError(domain: "Invalid URL", code: 400))
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil, error)
                return
            }
            do {
                let response = try JSONDecoder().decode(ItemResponse.self, from: data)
                var comments: [Comments] = []
                if let kids = response.kids {
                    for kid in kids {
                        self.extractComments(from: kid, depth: 0, into: &comments)
                    }
                }
                completion(comments, nil)
            } catch {
                print("Ошибка загрузки комментариев: \(error)")
                completion(nil, error)
            }
        }.resume()
    }
    private func extractComments(from node: CommentNode, depth: Int, into comments: inout [Comments]) {
        guard let text = node.text, !text.isEmpty else { return }
        let comment = Comments(
            id: node.id,
            author: node.by ?? "Unknown",
            date: self.formatDate(node.time),
            text: self.cleanHTMLText(text) ?? "No text",
            depth: depth
        )
        comments.append(comment)
        if let kids = node.kids {
            for kid in kids {
                extractComments(from: kid, depth: depth + 1, into: &comments)
            }
        }
    }
    
    private func cleanHTMLText(_ text: String) -> String? {
        guard let data = text.data(using: .utf8) else { return nil }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        return try? NSAttributedString(
            data: data,
            options: options,
            documentAttributes: nil
        ).string
    }
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: date)
    }
}
