import Foundation

// Модели для декодирования данных
struct APIStory: Codable {
    let id: Int
    let by: String?
    let time: Date
    let title: String?
    let score: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, by, time, title, score
    }
    
    init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            id = try container.decode(Int.self, forKey: .id)
            by = try container.decodeIfPresent(String.self, forKey: .by)
            title = try container.decodeIfPresent(String.self, forKey: .title)
            score = try container.decodeIfPresent(Int.self, forKey: .score)
            
            // Обработка строковой даты
            let timeString = try container.decode(String.self, forKey: .time)
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            
            if let date = formatter.date(from: timeString) {
                time = date
            } else {
                // Фолбэк для разных форматов
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
    let time: Date  // Изменили на Date
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
        kids = try container.decodeIfPresent([CommentNode].self, forKey: .kids)
        
        // Аналогичная обработка даты
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

class APIService {
    private let baseURL = "http://192.168.31.218:8000/api/v1"

    // Функция для получения топовых историй
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
            
            // Для отладки - вывести полученные данные
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
                        isFavorite: false
                    )
                }
                completion(newsItems, nil)
            } catch {
                print("Decoding error: \(error)")
                completion(nil, error)
            }
        }.resume()
    }

    // Функция для получения новых историй
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
                        isFavorite: false
                    )
                }
                completion(newsItems, nil)
            } catch {
                print("Decoding error: \(error)")
                completion(nil, error)
            }
        }.resume()
    }

    // Функция для получения комментариев
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
            
            // Для отладки - вывести полученные данные
            if let dataString = String(data: data, encoding: .utf8) {
                print("Received comments data: \(dataString)")
            }
            
            do {
                // Декодируем ответ как словарь
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let kids = json["kids"] as? [[String: Any]] {
                    
                    var comments: [Comments] = []
                    for kid in kids {
                        // Конвертируем каждый kid в данные
                        let kidData = try JSONSerialization.data(withJSONObject: kid)
                        let node = try JSONDecoder().decode(CommentNode.self, from: kidData)
                        
                        // Рекурсивно извлекаем комментарии
                        self.extractComments(from: node, depth: 0, into: &comments)
                    }
                    completion(comments, nil)
                } else {
                    completion([], nil)  // Нет комментариев
                }
            } catch {
                print("Decoding error: \(error)")
                completion(nil, error)
            }
        }.resume()
    }
    
    // Рекурсивная функция извлечения комментариев
    private func extractComments(from node: CommentNode, depth: Int, into comments: inout [Comments]) {
        let comment = Comments(
            id: node.id,
            author: node.by ?? "Unknown",
            date: self.formatDate(node.time),  // Уже Date!
            text: node.text ?? "No text",
            depth: depth
        )
        comments.append(comment)
        
        // Обрабатываем дочерние комментарии
        if let kids = node.kids {
            for kid in kids {
                extractComments(from: kid, depth: depth + 1, into: &comments)
            }
        }
    }
    
    // Вспомогательная функция для форматирования даты
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: date)
    }
}
