//
//  CommentsView.swift
//  HN_reader
//
//  Created by MpAsSgHA on 06.05.2025.
//

import SwiftUI

struct CommentsView: View {

    @State private var dummyComments: [Comments] = (0..<6).map { index in
        Comments(
            author: "Автор \(index + 1)",
            date: "00.00.000\(index)",
            text: "тут будет текст отзыва",
        )
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                ForEach($dummyComments) { $item in
                    CommentsRowView(item: $item)
                }
            }
        }
    }
}
