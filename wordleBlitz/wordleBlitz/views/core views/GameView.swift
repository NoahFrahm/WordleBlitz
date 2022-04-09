//
//  GameView.swift
//  wordleBlitz
//
//  Created by Noah Frahm on 3/29/22.
//

import SwiftUI

struct GameView: View {
    
    @ObservedObject var gm: gameModel
//    = gameModel(solution: "clock")
    @State var roundOver: Bool = false
    @State var badSpell: Bool = false
    
    init(gml: gameModel) {
        self.gm = gml
    }
    
    var spacing: CGFloat = 5

    
    var body: some View {
        ZStack{
            VStack{
                letterGridView(gm: gm)
                KeyRowView(model: gm, spacing: spacing).topRow
                    .padding([.top], 20)
                KeyRowView(model: gm, spacing: spacing).middleRow
                KeyRowView(model: gm, spacing: spacing).bottomRow
            }.disabled(gm.gameOver)

            if gm.gameOver {
                VStack{
                    ZStack{
                        if gm.foundSol {
                            Rectangle()
                                .foregroundColor(.black)
                                .frame(width: 120, height: 50, alignment: .center)
                            Text("CONGRATS!")
                                .foregroundColor(.white)
                        }
                        else {
                            Rectangle()
                                .foregroundColor(.black)
                                .frame(width: 100, height: 50, alignment: .center)
                            Text(gm.solution.uppercased())
                                .foregroundColor(.white)
                        }
                    }.padding([.top], 30)
                    Spacer()
                    if roundOver {
                        Button(action: {
                            gm.reset()
                            roundOver.toggle()
                        }) {
                            NextButtonView(buttonName: "Next Word")
                        }
                    }
                    Spacer()
                }.onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        roundOver = true
                    }
                }
            }
            
            if badSpell {
                VStack{
                    ZStack{
                        Rectangle()
                            .foregroundColor(.black)
                            .frame(width: 130, height: 50, alignment: .center)
                        Text("INVALID WORD")
                            .foregroundColor(.white)
                    }.padding([.top], 30)
                    
                    Spacer()
                }
            }
        }.onChange(of: gm.misSpellNotifier) { _ in
            badSpell = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                badSpell = false
            }
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(gml: gameModel(solution: "clock"))
    }
}


//MARK: - KeyBoard
struct KeyBoardKeyView: View {
    
    @ObservedObject var model: gameModel
    var letter: String
    var backgroundColor: Color
    var letterColor: Color
    
    var body: some View {
        Button(action: {
            model.typeLetter(letter: letter)
        }) {
            ZStack{
                RoundedRectangle(cornerRadius: 5)
                    .foregroundColor(backgroundColor)
                Text(letter.uppercased())
                    .foregroundColor(letterColor)
                    .font(.body)
                    .bold()
            }.frame(width: 32, height: 60)
        }
    }
}

struct KeyRowView {

    @ObservedObject var model: gameModel
    var spacing: CGFloat
    
    let topKeys = ["q","w","e","r","t","y","u","i","o","p"]
    let middleKeys = ["a","s","d","f","g","h","j","k","l"]
    let bottomKeys = ["z","x","c","v","b","n","m"]
    
    
    var topRow: some View {
        HStack(spacing: spacing){
            Spacer()
            ForEach(topKeys, id: \.self) { keyy in
                KeyBoardKeyView(model: model,letter: keyy, backgroundColor: model.keys[keyy]!.color, letterColor: model.keys[keyy]!.textColor)
            }
            Spacer()
        }
    }

    var middleRow: some View {
        HStack(spacing: spacing){
            Spacer()
            ForEach(middleKeys, id: \.self) { keyy in
                KeyBoardKeyView(model: model,letter: keyy, backgroundColor: model.keys[keyy]!.color, letterColor: model.keys[keyy]!.textColor)
            }
            Spacer()
        }
    }
    
    var bottomRow: some View {
        HStack(spacing: spacing){
            Spacer()

            Button(action: {
                model.enter()
                }
            ){
                ZStack{
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundColor(model.keys.first?.value.defaultKeyColor)
                        .frame(width: 57, height: 60)
                    Text("ENTER")
                        .foregroundColor(model.keys.first?.value.defaultTextColor)
                        .font(.body)
                        .bold()
                }
            }

            ForEach(bottomKeys, id: \.self) { keyy in
                KeyBoardKeyView(model: model,letter: keyy, backgroundColor: model.keys[keyy]!.color, letterColor: model.keys[keyy]!.textColor)
            }

            Button(action: {
                model.delete()
                }
            ) {
                ZStack{
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundColor(model.keys.first?.value.defaultKeyColor)
                        .frame(width: 50, height: 60)
                    Image(systemName: "delete.left")
                        .foregroundColor(model.keys.first?.value.defaultTextColor)
                        .font(.title)
                }
            }
            Spacer()
        }

    }
}


//MARK: - Letter View
//displays what is being typed out
struct TypedOutLettersView: View {
    var letters: [String] = []

    var body: some View {
        HStack{
            ForEach(0...4, id: \.self) { index in
                if index >= letters.count {
                    SingleLetter().empty
                }
                else {
                    SingleLetter(buchstabe: letters[index]).typed
                        .transition(.scale(scale: 1.2, anchor: .center))
                }
            }
        }
    }
}

//displays a row of letters
struct LetterRowView: View {

    @ObservedObject var gm: gameModel
    var word: [String] = ["", "", "", "", ""]

    
    var body: some View {
        let key = gm.checkGuess(guess: word)

        HStack{
            ForEach(0...4, id: \.self) { index in
                switch key[index] {
                case .correct:
                    SingleLetter(buchstabe: word[index]).correct
                case .partial:
                    SingleLetter(buchstabe: word[index]).partial
                case .wrong:
                    SingleLetter(buchstabe: word[index]).wrong
                default:
                    SingleLetter(buchstabe: word[index]).empty
                }
            }
        }
    }
}

//one letter with different styling options
struct SingleLetter {

    var width: Double = 60
    var height: Double = 60
    var buchstabe: String = ""

    private var letter: String {
        return buchstabe.uppercased()
    }

    var correct: some View {
        SingleLetterView(width: width, height: height, color: key().correctKeyColor, unformattedletter: letter)
    }
    var partial: some View {
        SingleLetterView(width: width, height: height, color: key().partialKeyColor, unformattedletter: letter)
    }
    var wrong: some View {
        SingleLetterView(width: width, height: height, color: key().wrongKeyColor, unformattedletter: letter)
    }
    var typed: some View {
        SingleLetterView(width: width, height: height, color: .white,unformattedletter: buchstabe, textColor: .black, borderColorWhenWhite: .black)
    }
    var empty: some View {
        SingleLetterView(width: width, height: height, color: .white)
    }
}

//displays one letter
struct SingleLetterView: View {

    var width: Double
    var height: Double
    var radius: Double = 0
    var color: Color = .white
    var unformattedletter: String = ""
    var textColor: Color = .white
    var borderColorWhenWhite: Color = .white

    private var letter: String {
        return unformattedletter.uppercased()
    }

    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: radius)
                .foregroundColor(color)
                .frame(width: width, height: height)
                .overlay(
                    RoundedRectangle(cornerRadius: 0)
                        .stroke(color == .white ? letter == "" ? .gray : borderColorWhenWhite : color, lineWidth: 2))

                Text(letter)
                    .foregroundColor(textColor)
                    .bold()
                    .font(.largeTitle)
        }
    }
}

//grid of letters ie past guesses and typed out letters
struct letterGridView: View {

    @ObservedObject var gm: gameModel
    

    var lengthenTypedOut: [String] {
        var shortened = gm.typedOut
        while shortened.count < 5 {
            shortened.append("")
        }
        return shortened
    }

    var body: some View {
        ForEach(0..<gm.maxGuesses , id: \.self) { index in
            if index < gm.tries {
                LetterRowView(gm: gm, word: gm.guesses[index])
            }
            else if index == gm.tries && gm.tries < gm.maxGuesses{
                    TypedOutLettersView(letters: gm.typedOut)
            }
            else {
                TypedOutLettersView()
            }
        }
    }
}


//MARK: - next word
//button to get next word
struct NextButtonView: View {
    
    var buttonName: String
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 25)
                .frame(width: 200, height: 50)
                .foregroundColor(.black)
            Text(buttonName)
                .bold()
                .font(.title2)
                .foregroundColor(.white)
        }
    }
}
