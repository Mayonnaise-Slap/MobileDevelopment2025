//
//  FilterFavoritesView.swift
//  HN_reader
//
//  Created by MpAsSgHA on 08.05.2025.
//

import SwiftUI


struct FilterFavoritesView: View {
    @Binding var sortOption: SortOptions
    
    var body: some View {
        HStack {
            Menu {
                ForEach(SortOptions.allCases, id: \.self) { option in
                    Button(action: {
                        sortOption = option
                    }) {
                        Label(option.rawValue,  systemImage: sortIconName(for: option))
                    }
                }
            } label: {
                Label("Сортировка", systemImage: "arrow.up.arrow.down")
                    .padding(5)
                    .background(Color("Main"))
                    .foregroundColor(.white)
                    .cornerRadius(5)
            }
        }
        .padding(.bottom, 30)
    }
}
