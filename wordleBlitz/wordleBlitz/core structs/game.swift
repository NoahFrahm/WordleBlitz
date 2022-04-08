//
//  game.swift
//  wordleBlitz
//
//  Created by Noah Frahm on 4/4/22.
//

import Foundation

struct gameObj: Codable {
    let id: String
    
    //only the host can trigger start game function
    var host: String
    
    //includes host
    var players: [String]
    
    //key playerid, value is guess/guess count. to decide winner we look at least total guesses.
    //if player isnt done yet theyh will not be in dict this is how to check if game is finished
    var guessCount: [String: Int] = [String: Int]()

    //the words both players are competing to guess in least amount of guesses total
    
//    private var start = Int.random(in: 0..<words.count)
//    private var solutions = [start, (start + 1) % words.count]
    var solutionSet: [String] = ["CLOCK", "TIMED", "TRAIN"]
//    [String](repeating: 0, count: 5)
    

    //track guess count to calculate this
    var winningPlayerId: String
    
    //player IDs for rematch
    var rematchPlayerId: [String]
    
//    guess tracking for spectator view (experimental to be added later)
//    var guess: [String: String] = [String: String]()
}
