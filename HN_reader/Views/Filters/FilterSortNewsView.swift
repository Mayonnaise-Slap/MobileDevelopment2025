
//  FilterSortNewsView.swift
//  HN_reader
//
//  Created by MpAsSgHA on 30.05.2025.
//

import SwiftUI

struct FilterSortNewsView: View {
    @Binding var sortOption: SortOptions
    @Binding var filterOption: FilterOptions
    
    var body: some View {
        VStack {
            Text("Сортировка и фильтрация")
                .font(.title)
                .padding()
            
            VStack(alignment: .leading, spacing: 20) {
                Text("Сортировать по:")
                    .font(.headline)
                
                Picker("Сортировка", selection: $sortOption) {
                    ForEach(SortOptions.allCases, id: \.self) { option in
                        Text(option.rawValue)
                            .tag(option)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                
                Text("Фильтровать по:")
                    .font(.headline)
                
                Picker("Фильтр", selection: $filterOption) {
                    ForEach(FilterOptions.allCases, id: \.self) { option in
                        Text(option.rawValue)
                            .tag(option)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            .padding()
            
            Spacer()
        }
        .navigationTitle("Фильтры")
    }
}

struct FilterSortNewsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FilterSortNewsView(sortOption: .constant(.all), filterOption: .constant(.all))
        }
    }
}

