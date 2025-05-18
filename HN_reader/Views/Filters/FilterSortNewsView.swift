//
//  FiltersView.swift
//  HN_reader
//
//  Created by MpAsSgHA on 24.04.2025.
//

import SwiftUI


struct FilterSortNewsView: View {
    @Binding var sortOption: SortOptions
    @Binding var filterOption: FilterOptions
    
    
    var body: some View {
        HStack {
            Menu {
                ForEach(FilterOptions.allCases, id: \.self) { option in
                    Button(action: {
                        filterOption = option
                    }) {
                        Label(option.rawValue,  systemImage: filterIconName(for: option))
                    }
                }
            } label: {
                Label("Фильтры", systemImage: "line.3.horizontal.decrease.circle")
                    .padding(5)
                    .background(Color("Main"))
                    .foregroundColor(.white)
                    .cornerRadius(5)
            }

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
