//
//  ScholarHelpApp.swift
//  ScholarHelp
//
//  Created by Ivanovich Chiu on 16/04/25.
//

import SwiftUI

@main
struct ScholarHelpApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                WelcomeView()
            }
            .environmentObject(UserManager.shared)
        }
    }
}
