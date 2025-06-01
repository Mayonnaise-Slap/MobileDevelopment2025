//
//  HeaderView.swift
//  HN_reader
//
//  Created by MpAsSgHA on 24.04.2025.
//

import SwiftUI

struct HeaderView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @Environment(\.colorScheme) private var colorScheme
    var body: some View {
        HStack {
            Image("HN_logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 125)
                .padding(.leading, 30)
            
            Spacer()
            
            Button(action: {
                withAnimation(.easeInOut(duration: 0.1)) {
                    isDarkMode.toggle()
                }
            }) {
                ZStack {
                    Circle()
                        .frame(width: 34, height: 34)
                        .opacity(0.0001)
                    Group {
                        if isDarkMode {
                            Image(systemName: "lightswitch.on.square.fill")
                                .transition(.scale.combined(with: .opacity))
                        } else {
                            Image(systemName: "lightswitch.off.square")
                                .transition(.scale.combined(with: .opacity))
                        }
                    }
                    .font(.system(size: 20))
                    .foregroundColor(Color("Icon"))
                }
                .contentShape(Circle())
            }
            .padding(.trailing, 30)
        }
        .padding(.vertical, 15)
        Divider()
            .frame(height: 3)
            .background(Color("Main"))
    }
}
