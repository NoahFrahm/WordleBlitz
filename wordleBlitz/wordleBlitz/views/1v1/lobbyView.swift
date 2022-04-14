//
//  lobbyView.swift
//  wordleBlitz
//
//  Created by Noah Frahm on 4/12/22.
//

import SwiftUI

struct lobbyView: View {
    
    @ObservedObject var fire: FirebaseService = FirebaseService.shared
    @StateObject var gm: GameModel
    @State var confirmQuit: Bool = false
    @State var back: Bool = false
    @Binding var stew: Bool
    
//    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack {
            //TODO: - fix the navigation error here
            NavigationLink(destination: JoinView()
                            .navigationBarTitle("")
                            .navigationBarBackButtonHidden(true)
                            .navigationBarHidden(true), isActive:
                            $back){
                EmptyView()
//                Text("here")
            }
            if fire.inGame {
                if stew {
                    oneV1View(ActiveGame: GameView(gml: gm))
                }
                else {
                    Text("wait for host to start game")
                    List{
                        let playerCount = fire.game.players.count
                        Section(playerCount == 0 ? "Waiting on Players" : "\(playerCount) Players"){
                        if fire.game == nil || playerCount == 1 {
                            ProgressView()
                        }
                        else {
                            ForEach(fire.game.players.sorted(by: >) , id: \.key) { id, name  in
                                    HStack{
                                        Text(name)
                                    }
                            }
                        }
                    }.font(.title3)
                        Button(action: {confirmQuit = true}) {
                            Text("Quit")
                                .foregroundColor(.red)
                                .font(.title2)
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                    }
            }
            else {
//                Text("Lobby")
                Text("loading game")
                ProgressView()
                    .padding([.bottom], 40)
//                Text()
                Button("Back") {
                    back = true
                }
            }
        }
        .onChange(of: fire.inGame) { _ in
            gm.updateSolSet()
        }
        .alert(isPresented: $confirmQuit) {
            Alert(title: Text("Quit Game?"),
            primaryButton: .destructive(Text("Yes")) {
//                add code to remove from game
                if FirebaseService.shared.game.players.count <= 1 {
                    FirebaseService.shared.quitTheGame()
                }
                FirebaseService.shared.gameStarted = false
                back = true
                print("Deleting...")
            },
            secondaryButton: .cancel(Text("No"))
            )
        }
    }
}

struct lobbyView_Previews: PreviewProvider {
    static var previews: some View {
//        lobbyView()
        lobbyView(gm: GameModel(), stew: .constant(false))

    }
}
