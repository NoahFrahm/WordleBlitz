//
//  gameModel.swift
//  wordleBlitz
//
//  Created by Noah Frahm on 3/29/22.
//

import Foundation
import SwiftUI
import Combine


class gameModel: ObservableObject {
    
    @AppStorage("user") private var userData: Data?
    
    @Published var currentUser: User!
    
    //we need to override it with a new instance later or place code into init to make host and players currenUser.id
    @Published var game: gameObj?

//    @Published var game = gameObj(id: UUID().uuidString, host: "place holder 1", players: ["place holder 1"], guessCount: [String: Int](), solutionSet: [], winningPlayerId: "", rematchPlayerId: [])
    
    
    @Published var keys: [String: key] = [String: key]()
    @Published var guesses: [[String]] = []
    @Published var typedOut: [String] = []
    @Published var gameOver: Bool = false
    
    //the view doesnt need to know about these
    @Published var solutionSet = words
    @Published var solution: String = words[Int.random(in: 0..<words.count)]
    //this one though
    @Published var freqs: [Int] = [0, 0, 0, 0, 0, 0]
    @Published var misSpellNotifier = false
    
    private var cancellables: Set<AnyCancellable> = []

//    let defaultKeyColor: Color = Color("lightgray")
//    let wrongKeyColor: Color = .gray
//    let defaultTextColor: Color = .black
//    let changedTextColor: Color = .white
    
    var maxGuesses = 6
    var rounds = 0
    private var solutionIndex = 0
    var tries: Int {
        return guesses.count
    }
    private var stringGuess: String {
        var stringy: String = ""
        for letr in self.guesses.last! {
            stringy += letr.uppercased()
        }
        return stringy
    }
    private var solutionArrayFormat: [String] {
        var myArr: [String] = []
        for char in self.solution {
            myArr.append(String(char).uppercased())
        }
        return myArr
    }
    var foundSol: Bool {
        return stringGuess.uppercased() == solution.uppercased()
    }
    

    convenience init() {
        self.init(solution: words[Int.random(in: 0..<words.count)])
    }
    
    
    init(solution: String) {
        
        //this pulls user from user defaults
        retrieveUser()
        
        //if we dont have a user current user will be nil and we make a new one with saveUser
        if currentUser == nil {
            saveUser()
        }
        
        print("we have a user with id", currentUser.id)
        
        freqs = self.currentUser.stats
        
        let topRow = ["q","w","e","r","t","y","u","i","o","p"]
        let middleRow = ["a","s","d","f","g","h","j","k","l"]
        let bottomRow = ["z","x","c","v","b","n","m"]
        
        for letter in topRow {
            self.keys[letter] = key(name: letter)
        }
        for letter in middleRow {
            self.keys[letter] = key(name: letter)
        }
        for letter in bottomRow {
            self.keys[letter] = key(name: letter)
        }
        self.solution = solution
    }
    
    
    //MARK: - userObject
    func saveUser() {
        //we make a new user object
        currentUser = User(name: "Jim Bob")
        
        do {
            print("encoding user object")
            //attempt to json encode to data
            let data = try JSONEncoder().encode(currentUser)
            userData = data
        } catch {
            print("couldn't save user object")
        }
        
    }
    
    
    func updateFreq(freqs: [Int]) {
        currentUser.stats = freqs
        self.updateUser()
    }
    
    
    func changeUserName(name: String) {
        //change the user objects name
        currentUser.name = name
        updateUser()

    }
    
    
    func updateUser() {
        do {
            print("updating user")
            //we attempt to encode and store in user defaults
            let newData = try JSONEncoder().encode(currentUser)
            UserDefaults.standard.set(newData, forKey: "user")
            print("updated user")
        } catch {
            print("could not update user")
        }
    }
    
    
    func retrieveUser() {
        
        guard let userData = userData else { return }
        
        do {
            print("decoding user")
            //we try to decode data in user object and store it in current user
            currentUser = try JSONDecoder().decode(User.self, from: userData)
        } catch {
            print("no user saved")
        }
        
    }
    
    
    //MARK: - Firebase
    func getTheGame() {
        FirebaseService.shared.startGame(with: currentUser.id)
        
//        fetch game from firebase and store it in gameviewmodel to display
        FirebaseService.shared.$game
            .assign(to: \.game, on: self)
            .store(in: &cancellables)
    }
    
    //returns arr of games
    func getOpenGames() {
        FirebaseService.shared.getWhatIneed()
//        Task {
//            FirebaseService.shared.fetchAllOpenGames()
//            print("second call \(FirebaseService.shared.openGames)")

//        }
        print("second call \(FirebaseService.shared.openGames)")

//        print("second call \(FirebaseService.shared.openGames)")
    }
    
    
    
    //MARK: - game functions
    //fetches a new word from solution set, specifically base on solutionindex, and makes it the new solution
    func newWord() {
        self.solution = self.solutionSet[self.solutionIndex]
        self.solutionIndex += 1
    }
    
    
    //resets the game with a new solution
    func reset() {
        self.guesses = []
        self.typedOut = []
        self.resetKeys()
        self.newWord()
        self.gameOver = false
    }
    
    
    //makes all keys their default color
    private func resetKeys() {
        let topRow = ["q","w","e","r","t","y","u","i","o","p"]
        let middleRow = ["a","s","d","f","g","h","j","k","l"]
        let bottomRow = ["z","x","c","v","b","n","m"]
        
        for letter in topRow {
            self.keys[letter]?.color = self.keys[letter]?.defaultKeyColor ?? .gray
            self.keys[letter]?.textColor = self.keys[letter]?.defaultTextColor ?? .white
        }
        for letter in middleRow {
            self.keys[letter]?.color = self.keys[letter]?.defaultKeyColor ?? .gray
            self.keys[letter]?.textColor = self.keys[letter]?.defaultTextColor ?? .white
        }
        for letter in bottomRow {
            self.keys[letter]?.color = self.keys[letter]?.defaultKeyColor ?? .gray
            self.keys[letter]?.textColor = self.keys[letter]?.defaultTextColor ?? .white
        }
    }
    
    
    //type a letter
    func typeLetter(letter: String) {
        withAnimation{
            if typedOut.count < 5 {
                typedOut.append(letter.uppercased())
            }
        }
    }
    
    
    //delete a letter
    func delete() {
        if typedOut.count > 0 {
            _ = typedOut.popLast()
        }
    }
    
    //checks word spelling
    func isMispelled() -> Bool {
        var word = ""
        
        for letr in self.typedOut {
            word += letr.lowercased()
        }
        
        if word.count < 5 {return false}
        
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(
            in: word,
            range: range,
            startingAt: 0,
            wrap: false,
            language: "en"
        )
        return misspelledRange.location != NSNotFound
    }

    
    // checks guess and recolors keys appropriately
    func enter() {
        let mispelled = isMispelled()
        print(mispelled)
        
        if mispelled {
            misSpellNotifier.toggle()
        }
        
        if self.typedOut.count != 5 || self.guesses.count == self.maxGuesses || mispelled { return }
        
        let colorKey = self.checkGuess(guess: self.typedOut)
//        print(colorKey)
        
        //this for loop decodes color key and assigns new key/text colors accordingly
        for index in 0..<self.typedOut.count {
            let myKey = self.keys[self.typedOut[index].lowercased()]
//            var yu = self.keys[self.typedOut[index]]
//            print(myKey, yu)
            
            self.keys[self.typedOut[index].lowercased()]?.textColor = myKey?.changedTextColor ?? .gray
            
            switch colorKey[index]{
                case .wrong:
                    print("wrong")
                    self.keys[self.typedOut[index].lowercased()]?.color = myKey?.wrongKeyColor ?? .red
//                    print(self.keys[self.typedOut[index].lowercased()]?.color)

                case .correct:
                    print("correct")
                    self.keys[self.typedOut[index].lowercased()]?.color = myKey?.correctKeyColor ?? .blue
//                    print(self.keys[self.typedOut[index].lowercased()]?.color)

                case .partial:
                    print("partial")
                    if self.keys[self.typedOut[index].lowercased()]?.color != key().correctKeyColor {
                        self.keys[self.typedOut[index].lowercased()]?.color = myKey?.partialKeyColor ?? .purple
                    }
//                    print(self.keys[self.typedOut[index].lowercased()]?.color)
                default:
                    print("error finding key to change")
            }
        }
        
        self.guesses.append(self.typedOut)
        self.typedOut = []
        self.checkGameOver()
    }
    
    
    //checks if game is over by max guesses or correct solution an sets gameover bool to true or false accordingly
    private func checkGameOver() {
        print(self.stringGuess, self.solution)
        if self.guesses.count == self.maxGuesses || self.stringGuess.uppercased() == self.solution.uppercased() {
            self.freqs[guesses.count-1] += 1
            self.updateFreq(freqs: self.freqs)
            self.gameOver = true
            self.rounds += 1
        }
    }
    
    
    //makes a dictionary with letter frequencies in a given word (helper)
    private func wordBreakDown(buchstabe: [String]) -> [String: Int] {
            var counter = [String: Int]()
            for char in buchstabe {
                if counter[String(char)] == nil {
                    counter[String(char)] = 1
                }
                else{
                    counter[String(char)]? += 1
                }
            }
            return counter
    }

    
    //returns an array with a color key base on guess and actual solution
    //wrong is if letter is not in word, partial if letter is in wrong position, and correct if letter is correctly placed
    func checkGuess(guess: [String]) -> [letterStatus] {
        
        let answer = self.solutionArrayFormat
        let wordLength = self.solution.count - 1
        var letterCounts = wordBreakDown(buchstabe: answer)
        var key: [letterStatus] = []


        for _ in 0...wordLength {
            key.append(.blank)
        }
    
        for rotation in 0...2{
            switch rotation {
                case 0:
                    for j in 0...wordLength {
//                        print(guess[j], answer[j])
                        if guess[j] == answer[j]{
                            key[j] = .correct
                            letterCounts[guess[j]]! -= 1
                        }
                    }
                case 1:
                    for j in 0...wordLength {
                        if answer.contains(guess[j]) && key[j] != .correct && letterCounts[guess[j]]! > 0 {
                            key[j] = .partial
                            letterCounts[guess[j]]! -= 1
                        }
                    }
                case 2:
                    for j in 0...wordLength {
                        if key[j] == .blank {
                            key[j] = .wrong
                        }
                    }
                default:
                key[0] = .correct
                }
        }
        return key
    }

}

struct key {
    var name: String? = ""
    var color: Color = Color("lightgray")
    var textColor: Color = .black
    
//    let defaultKeyColor: Color = Color("lightgray")
    let defaultKeyColor: Color = Color("lightgray")
    let wrongKeyColor: Color = .gray
    let correctKeyColor: Color = .green
    let partialKeyColor: Color = .yellow

    let defaultTextColor: Color = .black
    let changedTextColor: Color = .white
    
}
