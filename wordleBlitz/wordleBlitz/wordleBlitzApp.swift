//
//  wordleBlitzApp.swift
//  wordleBlitz
//
//  Created by Noah Frahm on 3/29/22.
//

import SwiftUI
import Firebase

@main
struct wordleBlitzApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
