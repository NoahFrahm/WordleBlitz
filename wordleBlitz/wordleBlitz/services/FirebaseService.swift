//
//  FirebaseService.swift
//  wordleBlitz
//
//  Created by Noah Frahm on 4/8/22.
//

import Foundation
import FirebaseFirestoreSwift
import Firebase
import Combine
import SwiftUI


final class FirebaseService: ObservableObject {
    
    static let shared = FirebaseService()
    
    @Published var game: gameObj!
    @Published var openGames: [gameObj] = []

    
    init() { }
    
    
    func createOnlineGame() {
//        will save the game online
        do {
            try FirebaseReference(.Game).document(self.game.id).setData(from: self.game)
        } catch {
            print("error creating game", error.localizedDescription)
        }
    }
    
    func printGames() {
        print("open games \(self.openGames)")
    }
    
    func getWhatIneed() {
        self.fetchAllOpenGames(printGames)
    }

    //get all games on firebase
    func fetchAllOpenGames(_ completion: @escaping () -> ()) {
//        check if there is a game to join, if not we create a new game
//        if yes we join and start listening to changes for the game

//        find game with no second player where user isnt first player
        FirebaseReference(.Game).whereField("play", isEqualTo: false).getDocuments {
            querySnapshot, error in
//            print("we have a game")

            if error != nil {
                print("Error starting game", error?.localizedDescription ?? "wonky")
                return
            }
            for doc in querySnapshot!.documents {
//                print("\(doc.data().keys)")
//                print("here we are today")
                let myGame = try? doc.data(as: gameObj.self)
                if myGame != nil {
                    self.openGames.append(myGame!)
                }
            }
            completion()
            
//            print("games here inner \(self.openGames)")

        }
//        print("games here outer \(self.openGames)")

    }
    
    func startGame(with userId: String) {
//      check if there is a game to join, if not we create a new game
//      if yes we join and start listening to changes for the game
        
//      find game with no second player where user isnt first player
        FirebaseReference(.Game).whereField("player2Id", isEqualTo: "").whereField("player1Id", isNotEqualTo: userId).getDocuments {
            querySnapshot, error in
            
            if error != nil {
                print("Error starting game", error?.localizedDescription ?? "wonky")
//                create new game since there are no games
                self.createNewGame(with: userId)
                return
            }
//            we found a game so we join and add listener
            if let gameData = querySnapshot?.documents.first {
                self.game = try? gameData.data(as: gameObj.self)
                self.game.players.append(userId)
//                self.game.blockMoveForPlayerId = userId
                
                self.updateGame(self.game)
                self.listenForGameChanges()
                
            } else {
//                no games to join so we make one
                self.createNewGame(with: userId)
            }
            
        }
    }
    
    func listenForGameChanges() {
//        listen to database for changes
        
//        do {
//            try FirebaseReference(.Game).document(game.id).setData(from: self.game)
//        } catch {
//            print("error creating game", error.localizedDescription)
//        }
    }
    
    func updateGame(_ game: gameObj) {
        do {
            try FirebaseReference(.Game).document(game.id).setData(from: game)
        } catch {
            print("error updating game", error.localizedDescription)
        }
    }
    
    func createNewGame(with userId: String) {
//        creates a new game object
        
//        make 3 random word indices here
        var set = Set<Int>()
        while set.count < 3 {
            set.insert(Int.random(in: 0...words.count))
        }
        let indices = Array(set)
        
        self.game = gameObj(id: UUID().uuidString, host: "place holder 1", players: ["place holder 1"], guessCount: [String: Int](), solutionSet: [words[indices[0]], words[indices[1]], words[indices[2]]])
        self.createOnlineGame()
        self.listenForGameChanges()
    }
    
    func quitTheGame() {
        guard game != nil else { return }
        FirebaseReference(.Game).document(self.game.id).delete()
    }
}

