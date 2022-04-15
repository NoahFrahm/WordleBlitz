//
//  JoinView.swift
//  wordleBlitz
//
//  Created by Noah Frahm on 4/9/22.
//

import SwiftUI

struct JoinView: View {
    @State var play: Bool = false
    @State var confirmQuit: Bool = false
    @State var askJoinGame: Bool = false
    @State var selectedGame: gameObj? = nil
    @State var joinedGame: Bool = false
    @ObservedObject var fire: FirebaseService = FirebaseService.shared
    @StateObject var gm: GameModel = GameModel()

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var gameCode: String = "BSAW"
    
    var body: some View {
        NavigationView{
            VStack{
                NavigationLink(destination: lobbyView(gm: gm, stew: $fire.gameStarted)
                                .navigationBarTitle("")
                                .navigationBarBackButtonHidden(true)
                                .navigationBarHidden(true), isActive:
                                $play){
                    EmptyView()
                }
                NavigationLink(destination: EmptyView()) {
                    EmptyView()
                }
                                
                Text("Active Games")
                    .font(.title)

                List{
                    if !fire.fetchComplete {
                        Section("Looking for open games") {
                            ProgressView()
                        }.font(.title3)
                    }
                    else {
                        let playerCount = FirebaseService.shared.openGames.count
                        
                        Section("\(playerCount) Open Games") {
                        ForEach(FirebaseService.shared.openGames, id: \.id) { game in
                            Button(action: {
                                askJoinGame = true
                                selectedGame = game
                            }) {
                                Text("\(game.name)'s Game")
                                    .font(.title2)
                            }
                        }
                    }.font(.title3)
                    }

                    Button(action: {
                        fire.fetchComplete = false
                        gm.getOpenGames()
                    }) {
                        Text("Refresh")
                            .foregroundColor(.blue)
                            .font(.title2)
                    }
                }
                .listStyle(InsetGroupedListStyle())
                
                Button("BACK") {
                    presentationMode.wrappedValue.dismiss()
                }
                Spacer()
                
            }
            .alert(isPresented: $askJoinGame) {
                Alert(title: Text("Join This Game?"),
                primaryButton: .destructive(Text("Yes")) {
                    //we need to wait for join game
//                    print("1")
                    gm.joinGame(host: selectedGame?.id ?? "no host")
                    play = true
//                    print("2")
                },
                secondaryButton: .cancel(Text("No")){
                    askJoinGame = false
                }
                )
            }
            .navigationBarTitle("")
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
        }
        .onAppear{
            gm.getOpenGames()
            print("appeared")
        }
    }
}


struct JoinView_Previews: PreviewProvider {
    static var previews: some View {
        JoinView(gm: GameModel())
    }
}
