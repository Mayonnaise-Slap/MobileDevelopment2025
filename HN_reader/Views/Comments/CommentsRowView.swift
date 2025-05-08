//
//  CommentsRowView.swift
//  HN_reader
//
//  Created by MpAsSgHA on 06.05.2025.
//

import SwiftUI

struct CommentsRowView: View {
    @Binding var item: Comments

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text("\(item.author)  |  \(item.date)")
                    .font(.caption2)
                    .foregroundColor(Color("Main"))
                Spacer()
                Text((item.text))
                    .font(.caption2)
                }
            .frame(maxWidth: .infinity, alignment: .leading)
            }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).stroke(Color("Divider")))
    }
}
