//
//  podiumView.swift
//  wordleBlitz
//
//  Created by Noah Frahm on 4/14/22.
//

import SwiftUI

struct podiumView: View {
    
    @ObservedObject var fire: FirebaseService = FirebaseService.shared
    @State var goHome: Bool = false
    @State var frame: Int = 0
    @State var done: Bool = false
    @State var userId: String
    
    var frames = ["┬─┬ノ( º _ ºノ)", "┻━┻ ︵ ヽ(°□°ヽ)",]
    let timer = Timer.publish(every: 1, on: .current, in: .common).autoconnect()
    
    var body: some View {
//        NavigationView{
            VStack(alignment: .leading){
                NavigationLink(destination: GameModeView()
                                .navigationBarTitle("")
                                .navigationBarBackButtonHidden(true)
                                .navigationBarHidden(true), isActive:
                                $goHome){
                    EmptyView()
                }
                if fire.game != nil {
                    if !fire.gameFinished{
                        HStack{
                            Spacer()
                            Text("waiting for other players to finish")
                                .bold()
                            Spacer()
                        }
                        VStack(alignment: .leading){
                            ForEach(fire.game.players.sorted(by: >) , id: \.key) { id, name  in
//                                let guesses = fire.game.guessCount[id] ?? 0
//                                let ratio = Double(fire.game.guessCount[id] ?? 0) / Double(18)
                                HStack(alignment: .center){
                                    Rectangle()
                                        .frame(width: 50 + (Double(fire.game.guessCount[id] ?? 0) / Double(18)) * 200, height: 40)
                                        .overlay(Text("\(fire.game.guessCount[id] ?? 0)").foregroundColor(.white).padding([.trailing], 10), alignment: .trailing)
                                    .foregroundColor(.blue)
                                    Text("\(name)")
                                }
                            }
                        }
                    }
                    else {
                        let winner: String = fire.game.players[fire.getWinner()] ?? "error fetching winner"
                        Spacer()
                        HStack{
                            Spacer()
                            Text("\(winner) Wins!!!")
                            Spacer()
                        }.padding([.bottom], 30)
                        HStack{
                            Spacer()
                            Text(frames[frame])
                                .font(.largeTitle)
                                .padding([.bottom], 100)
                            Spacer()
                        }
                        HStack{
                            Spacer()
//                            if frame == 0 {
                            Button("flip table") {
                                self.frame = (self.frame + 1) % 2
                            }
                            Spacer()
                        }
                        HStack{
                            Spacer()
                            Button("return to menu") {
                                goHome = true
//                                gm.leave()
                                FirebaseService.shared.leaveTheGame(playerId: userId)
                            }
                            Spacer()
                        }
                        Spacer()

                    }
                }
                else{
//                    ErrorView()
                    Spacer()
                    HStack{
                        Spacer()
                        Text(frames[frame])
                            .font(.largeTitle)
                            .padding([.bottom], 100)
                        Spacer()
                    }
                    HStack{
                        Spacer()
                        Button("flip table") {
                            self.frame = (self.frame + 1) % 2
                        }
                        Spacer()
                    }
                    Spacer()
                }
            }
            .navigationBarTitle("")
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
//        }
    }
}

struct podiumView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            podiumView(userId: "my user id")
        }
    }
}
