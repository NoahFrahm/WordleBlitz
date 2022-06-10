//
//  Solo.swift
//  wordleBlitz
//
//  Created by Noah Frahm on 4/3/22.
//

import SwiftUI

struct SoloView: View {
    
    @State var score: Int = 0
    @State var showStats: Bool = false
    @StateObject var gm: GameModel = GameModel()
//    solution: "clock"
//    @State var ActiveGame: GameView = GameView(gml: GameModel(solution: "clock"))
    
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack{
            ZStack{
                ScrollView{
                    TopBarView(showStat: $showStats, presentationMode: _presentationMode)
                    Divider()
//                    ActiveGame
                    GameView(gml: gm)
                }.padding([.bottom], 10)
                
                if showStats {
                    UserStatsView(endVals: gm.freqs, show: $showStats)
                        .padding([.bottom], 50)
                    }
                }
            }
        }
}

struct TopBarView: View {
    
    @Binding var showStat: Bool
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
            Button(action: {
//                withAnimation {
                    showStat.toggle()
//                }
            }) {
                Image(systemName: "chart.bar.xaxis")
                    .foregroundColor(.black)
                    .font(.title)
            }
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

struct SoloView_Previews: PreviewProvider {
    static var previews: some View {
        SoloView()
    }
}
