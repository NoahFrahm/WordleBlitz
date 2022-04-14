//
//  JoinView.swift
//  wordleBlitz
//
//  Created by Noah Frahm on 4/9/22.
//

import SwiftUI

struct JoinView: View {
    @State var players: [String] = ["Ronald", "Bob", "Harry"]
    
    @State var play: Bool = false
    @State var confirmQuit: Bool = false
    @State var askJoinGame: Bool = false
    @State var selectedGame: gameObj? = nil
    @State var joinedGame: Bool = false
//    @ObservedObject var FireBase = FirebaseService
//    @State var refreshed = FirebaseService.shared.fetchComplete
    @ObservedObject var fire: FirebaseService = FirebaseService.shared
//    make this passed arg so that it doesn't reload when we modify state here
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
                    print("1")
                    gm.joinGame(host: selectedGame?.id ?? "no host")
                    play = true
                    print("2")
                },
                secondaryButton: .cancel(Text("No"))
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

//                    if gm.game != nil {
                            // move into the game model
//                            print("2")
//                            gm.solution = gm.game!.solutionSet[0]
//                            gm.solutionSet = gm.game!.solutionSet
//                            play = true
//                            gm.game?.play = true
//                        }


//            .alert(isPresented: $confirmQuit) {
//                Alert(title: Text("Quit Game?"),
//                primaryButton: .destructive(Text("Yes")) {
//                    self.presentationMode.wrappedValue.dismiss()
//                    print("Deleting...")
//                },
//                secondaryButton: .cancel(Text("No"))
//                )
//            }

struct JoinView_Previews: PreviewProvider {
    static var previews: some View {
        JoinView(gm: GameModel())
    }
}
