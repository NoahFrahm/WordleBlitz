//
//  oneV1View.swift
//  wordleBlitz
//
//  Created by Noah Frahm on 4/7/22.
//

import SwiftUI

struct oneV1View: View {
    
    @State var score: Int = 0
    @State var showStats: Bool = false
    @State var ActiveGame: GameView
    var userName: String {
        return ActiveGame.gm.currentUser.name
    }
    
//    init() {
////        self.init(Mygml: gameModel())
//        self.ActiveGame = GameView(gml: gameModel())
//    }
//
//    init(Mygml: gameModel) {
//        self.ActiveGame = GameView(gml: Mygml)
//        self.userName = Mygml.currentUser.name
//    }
//
//    init(solutionSet: [String]) {
//        self.init(Mygml: gameModel(solution: solutionSet[0], solutionSet: solutionSet))
//    }
    
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack{
            ZStack{
                ScrollView{
                    TopBarMultiplayer(showStat: $showStats , userName: userName, presentationMode: _presentationMode)
                    Divider()
                    ActiveGame
                }.padding([.bottom], 10)
                
                if showStats {
                    UserStatsView(endVals: (ActiveGame.gm.freqs), show: $showStats)
                        .padding([.bottom], 50)
                    }
                }
        }
    }
}

struct TopBarMultiplayer: View {
    
    @Binding var showStat: Bool
    
    var userName: String
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    
    var body: some View {
        HStack{
            Spacer()
            Button(action: {                     self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("QUIT")
                    .foregroundColor(.black)
                    .font(.title2)
            }
            
            Spacer()
            
            Text(userName)
                .foregroundColor(.black)
                .font(.title2)
            
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "gear")
                    .foregroundColor(.black)
                    .font(.title)
            }
            
            Spacer()
        }
    }
}


struct oneV1View_Previews: PreviewProvider {
    static var previews: some View {
        oneV1View(ActiveGame: GameView(gml: gameModel(solution: "clock", solutionSet:  ["clock", "jazzy", "train"])))

//        oneV1View(solutionSet: ["clock", "jazzy", "train"])
    }
}
