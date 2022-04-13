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
    @Published var fetchComplete: Bool = false
    @Published var inGame: Bool = false

    
    init() { }
    
    
    func createOnlineGame() {
//        will save the game online
        do {
            try FirebaseReference(.Game).document(self.game.id).setData(from: self.game)
        } catch {
            print("error creating game", error.localizedDescription)
        }
    }
    
    
    func completeFetch() {
        self.fetchComplete = true
        print("open games \(self.openGames)")
    }

    
    func getWhatIneed() {
//        self.openGames = []
        self.fetchAllOpenGames(completeFetch)
    }
    
    
    func fetchAllOpenGames(_ completion: @escaping () -> ()) {
//        check if there is a game to join, if not we create a new game
//        if yes we join and start listening to changes for the game

//        find game with no second player where user isnt first player
        
        FirebaseReference(.Game).whereField("play", isEqualTo: false).getDocuments {
            querySnapshot, error in

            if error != nil {
                print("Error starting game", error?.localizedDescription ?? "wonky")
                return
            }
            self.openGames = []
            for doc in querySnapshot!.documents {
                let myGame = try? doc.data(as: gameObj.self)
                if myGame != nil {
                    self.openGames.append(myGame!)
                }
            }
            completion()
        }
    }


    //get all games on firebase
//    func fetchAllOpenGames() async {
////        find games that are joinable
//        var openGamesCurrent: [gameObj] = []
//        let docus = FirebaseReference(.Game).whereField("play", isEqualTo: false).getDocuments async
////        {
////            querySnapshot, error in
////
////            if error != nil {
////                print("Error starting game", error?.localizedDescription ?? "wonky")
////                return
////            }
////
////            for doc in querySnapshot!.documents {
//////                print("\(doc.data().keys)")
////                let myGame = try? doc.data(as: gameObj.self)
////                if myGame != nil {
//////                    self.openGames.append(myGame!)
////                    openGamesCurrent.append(myGame!)
////
////                }
////
////            }
//////            print("\(self.openGames)")
////            print("first print \(openGamesCurrent)")
////
////        }
//        print("second print \(openGamesCurrent)")
//
//    }
    
    func startGame(with userId: String, nickname: String) {
//      check if there is a game to join, if not we create a new game
//      if yes we join and start listening to changes for the game
        
//      find game with no second player where user isnt first player
        FirebaseReference(.Game).whereField("player2Id", isEqualTo: "").whereField("player1Id", isNotEqualTo: userId).getDocuments {
            querySnapshot, error in
            
            if error != nil {
                print("Error starting game", error?.localizedDescription ?? "wonky")
//                create new game since there are no games
                self.createNewGame(with: userId, gameName: nickname)
                return
            }
//            we found a game so we join and add listener
            if let gameData = querySnapshot?.documents.first {
                self.game = try? gameData.data(as: gameObj.self)
                self.game.players[userId] = nickname
//                self.game.blockMoveForPlayerId = userId
                
                self.updateGame(self.game)
                self.listenForGameChanges()
                
            } else {
//                no games to join so we make one
                self.createNewGame(with: userId, gameName: nickname)
            }
            
        }
    }
    
    func joinGame(with gameId: String, userId: String, userName: String) async {
        print("game ID: \(gameId)")
//      if yes we join and start listening to changes for the game
        
//      find game where user isnt the host
        print("searching")

        let dosty = FirebaseReference(.Game).whereField("play", isEqualTo: false)
//            .whereField("id", isEqualTo: gameId).whereField("host", isNotEqualTo: userId)

        
        do {
            let querySnapShot = try await dosty.getDocuments()
//            print("my data \(String(describing: querySnapShot.documents.))")
            print("my snapshot \(String(describing: querySnapShot))")
            print("my document \(String(describing: querySnapShot.documents))")
            
//            var joinGame = try? querySnapShot.documents.first?.data(as: gameObj.self)
//            self.game.players.append(userId)
//            self.updateGame(self.game)
//            self.listenForGameChanges()
            
//            print("the host is \(joinGame?.host as? String)")

            if let gameData = querySnapShot.documents.first {
                print("game found")
                self.game = try? gameData.data(as: gameObj.self)
                self.game.players[userId] = userName
                self.updateGame(self.game)
                self.listenForGameChanges()
            }
            
        } catch {
            print("error updating game", error.localizedDescription)
            return
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
            print("updated game")
        } catch {
            print("error updating game", error.localizedDescription)
        }
    }
    
    func createNewGame(with userId: String, gameName: String) {
//        creates a new game object
        
//        make 3 random word indices here
        var set = Set<Int>()
        while set.count < 3 {
            set.insert(Int.random(in: 0...words.count))
        }
        let indices = Array(set)
        
        self.game = gameObj(id: UUID().uuidString,name: gameName, host: userId, players: [userId: gameName], guessCount: [String: Int](), solutionSet: [words[indices[0]], words[indices[1]], words[indices[2]]])
        self.createOnlineGame()
        self.listenForGameChanges()
    }
    
    func quitTheGame() {
        guard game != nil else { return }
        FirebaseReference(.Game).document(self.game.id).delete()
    }
}

