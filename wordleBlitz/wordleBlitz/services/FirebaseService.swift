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
    @Published var gameStarted: Bool = false
    @Published var GameError: Bool = false


    
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
//        print("open games \(self.openGames)")
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
    
    func startGame(with userId: String, nickname: String) {
        self.createNewGame(with: userId, gameName: nickname)
    }
    
    func joinGame(with gameId: String, userId: String, userName: String) async {
        print("game ID: \(gameId)")
        print("searching")

        //modify to include game idea search criteria
        let dosty = FirebaseReference(.Game).whereField("play", isEqualTo: false).whereField("id", isEqualTo: gameId)

        do {
            let querySnapShot = try await dosty.getDocuments()
            print("my snapshot \(String(describing: querySnapShot))")
            print("my document \(String(describing: querySnapShot.documents))")

            //we join the first game that matches our criteria
            if let gameData = querySnapShot.documents.first {
                print("game found")
                DispatchQueue.main.async {
                    self.game = try? gameData.data(as: gameObj.self)
//                    self.game.players["joyner"] = userName
                    self.game.players[userId] = userName
                    self.game.guessCount[userId] = 0
                    self.game.playersDone[userId] = false


                    self.updateGame(self.game)
                    self.listenForGameChanges()
                    self.inGame = true
                }
                    print("game joined")
            }
        } catch {
            print("error joining game", error.localizedDescription)
            return
        }
    }
    
    
    func listenForGameChanges() {
        FirebaseReference(.Game).document(self.game.id).addSnapshotListener { documentSnapshot, error in
            print("changes recieved from firebase")

            if error != nil {
                print("Error listening to changes", error?.localizedDescription ?? "wacky")
                return
            }

            if let snapshot = documentSnapshot {
                self.game = try? snapshot.data(as: gameObj.self)
                
                if self.game == nil {
                    self.GameError = true
                    return
                    
                }
                
                self.gameStarted = self.game.play
                print("game start? \(self.game.play)")
                print("game changes recieved")
            }
        }
    }
    
    func updateGame(_ game: gameObj) {
        do {
            try FirebaseReference(.Game).document(game.id).setData(from: game)
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
        
        self.game = gameObj(id: UUID().uuidString,name: gameName, host: userId, players: [userId: gameName], guessCount: [userId: 0], solutionSet: [words[indices[0]], words[indices[1]], words[indices[2]]])
        self.createOnlineGame()
        self.listenForGameChanges()
    }
    
    func quitTheGame() {
        guard game != nil else { return }
        game = nil
        openGames = []
        fetchComplete = false
        inGame = false
        gameStarted = false
        GameError = false
        FirebaseReference(.Game).document(self.game.id).delete()
    }
    
    func leaveTheGame() {
        guard game != nil else { return }
        game = nil
        openGames = []
        fetchComplete = false
        inGame = false
        gameStarted = false
        GameError = false
        FirebaseReference(.Game).document(self.game.id).delete()
    }
    
    func beginGame() {
        self.game.play = true
        self.updateGame(self.game)
    }
}

