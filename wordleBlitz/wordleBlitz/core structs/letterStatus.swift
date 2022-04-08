//
//  letterStatus.swift
//  wordleBlitz
//
//  Created by Noah Frahm on 4/3/22.
//

import Foundation
import SwiftUI

enum letterStatus {
    case correct
    case partial
    case wrong
    case blank
}

struct colorScheme {
    let defaultKeyColor: Color = Color("lightgray")
    let wrongKeyColor: Color = .gray
    let correctKeyColor: Color = .green
    let partialKeyColor: Color = .yellow

    let defaultTextColor: Color = .black
    let changedTextColor: Color = .white
}
