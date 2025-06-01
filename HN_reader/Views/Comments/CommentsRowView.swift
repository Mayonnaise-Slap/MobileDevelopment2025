//
//  CommentsRowView.swift
//  HN_reader
//

import SwiftUI

struct CommentsRowView: View {
    var item: Comments

    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            ForEach(0..<item.depth, id: \.self) { _ in
                Rectangle()
                    .fill(Color("Main"))
                    .frame(width: 3)
                    .frame(maxHeight: .infinity)
                    .padding(.trailing, 2)
            }
            VStack(alignment: .leading, spacing: 5) {
                Text("\(item.author)  |  \(item.date)")
                    .font(.caption2)
                    .foregroundColor(Color("Main"))
                Text(item.text)
                    .font(.caption2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, CGFloat(item.depth * 15))
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).stroke(Color("Divider")))
    }
}
