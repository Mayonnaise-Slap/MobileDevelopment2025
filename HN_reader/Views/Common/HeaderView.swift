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
            Image("HN_logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 125)
                .padding(.leading, 30)
            Spacer()
            NavigationLink(destination: AccountView()) {
                Image(systemName: "person.crop.circle")
                .font(.title2)
                .foregroundColor(Color("Icon"))
                .padding(.trailing, 30)
            }
        }
        .padding(.vertical, 15)
        Divider()
            .frame(height: 3)
            .background(Color("Main"))
    }
}
