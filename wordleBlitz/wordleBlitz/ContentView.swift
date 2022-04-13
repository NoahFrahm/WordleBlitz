//
//  ContentView.swift
//  wordleBlitz
//
//  Created by Noah Frahm on 3/29/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
//        GameView(gml: gameModel(solution: "clock"))
//        test commit/push
        GameModeView()
//        oneV1View(ActiveGame: GameView(gml: gameModel(solution: "clock", solutionSet:  ["clock", "jazzy", "train"])))
//        oneV1View(Mygml: gameModel(solution: "clock", solutionSet:  ["clock", "jazzy", "train"]))

//        SoloView()
//        animatedLetter()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
