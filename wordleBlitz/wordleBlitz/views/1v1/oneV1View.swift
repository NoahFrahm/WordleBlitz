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
    @State var ActiveGame: GameView = GameView(gml: gameModel())
    
    
    init(){}
    
    init(solutionSet: [String]) {
        ActiveGame = GameView(gml: gameModel(solution: "clock"))
    }
    
    var userName: String {
        return ActiveGame.gm.currentUser.name
    }
    
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
                    UserStatsView(endVals: ActiveGame.gm.freqs, show: $showStats)
                        .padding([.bottom], 50)
                    }
                }
        }.onAppear{
            ActiveGame.gm.getTheGame()
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
                Text("BACK")
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
        oneV1View()
    }
}
