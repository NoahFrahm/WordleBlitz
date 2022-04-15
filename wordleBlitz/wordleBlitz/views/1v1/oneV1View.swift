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
    @StateObject var gm: GameModel
    
//    @State var ActiveGame: GameView
    @State var quit: Bool = false
    var userName: String {
        return gm.currentUser.name
    }
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        VStack{
            NavigationLink(destination: GameModeView()
                            .navigationBarTitle("")
                            .navigationBarBackButtonHidden(true)
                            .navigationBarHidden(true), isActive:
                            $quit){
                EmptyView()
            }
            ZStack{
                ScrollView{
                    
//                    TopBarMultiplayer(showStat: $showStats , quit: $quit, userName: userName)
                    
                    HStack{
                        Spacer()
                        Button(action: {
                            quit.toggle()
//                            presentationMode.wrappedValue.dismiss()

                            gm.leave()
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

                    
                    Divider()
                    GameView(gml: gm)
                }.padding([.bottom], 10)
                
                if showStats {
                    UserStatsView(endVals: (gm.freqs), show: $showStats)
                        .padding([.bottom], 50)
                    }
                }
        }
    }
}

struct TopBarMultiplayer: View {
    
    @Binding var showStat: Bool
    @Binding var quit: Bool
    
    var userName: String
    
    var body: some View {
        HStack{
            Spacer()
            Button(action: {
                quit = true
                
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
        oneV1View(gm: GameModel(solution: "clock", solutionSet:  ["clock", "jazzy", "train"]))
    }
}
