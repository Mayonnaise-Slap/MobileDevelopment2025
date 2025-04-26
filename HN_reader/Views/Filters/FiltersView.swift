//
//  FiltersView.swift
//  HN_reader
//
//  Created by MpAsSgHA on 24.04.2025.
//

import SwiftUI

struct FiltersView: View {
    var body: some View {
        HStack {
            Button(action: {}) {
                Label("Фильтры", systemImage: "line.3.horizontal.decrease.circle")
            }
            .padding(8)
            .background(Color(uiColor: #colorLiteral(red: 0.9777966142, green: 0.3477782011, blue: 0.05399081856, alpha: 1)))
            .foregroundColor(.white)
            .cornerRadius(8)

            Button(action: {}) {
                Label("Сортировка", systemImage: "arrow.up.arrow.down")
            }
            .padding(8)
            .background(Color(uiColor: #colorLiteral(red: 0.9777966142, green: 0.3477782011, blue: 0.05399081856, alpha: 1)))
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding(.bottom)
    }
}
