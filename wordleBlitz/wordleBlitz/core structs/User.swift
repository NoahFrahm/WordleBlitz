//
//  User.swift
//  wordleBlitz
//
//  Created by Noah Frahm on 4/4/22.
//

import Foundation

struct User: Codable {
    var id = UUID().uuidString
    var name: String = ""
    
//    frequncey of guesses for solo only
    var stats: [Int] = [0, 0, 0, 0, 0, 0]
//    var freq1 = 0
//    var freq2 = 0
//    var freq3 = 0
//    var freq4 = 0
//    var freq5 = 0
//    var freq6 = 0
    
}
