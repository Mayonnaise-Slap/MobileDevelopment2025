//
//  HeaderView.swift
//  HN_reader
//
//  Created by MpAsSgHA on 24.04.2025.
//

import SwiftUI

struct HeaderView: View {
    var body: some View {
        HStack {
            Image("logo1")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100)
            Spacer()
            Image(systemName: "person.circle")
                .font(.title2)
        }
        Divider()
        .background(Color(uiColor: #colorLiteral(red: 0.9777966142, green: 0.3477782011, blue: 0.05399081856, alpha: 1)))
        .padding()
    }
}
