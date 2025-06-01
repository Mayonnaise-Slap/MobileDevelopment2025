//
//  AppState.swift
//  HN_reader
//
//  Created by Vsevolod Lazebnyi on 01.06.2025.
//
import SwiftUI

class AppState: ObservableObject {
    @Published var isAuthenticated: Bool
    
    init(isAuthenticated: Bool) {
        self.isAuthenticated = isAuthenticated
    }
}
