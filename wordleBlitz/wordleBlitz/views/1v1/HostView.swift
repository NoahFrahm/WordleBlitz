//
//  CreateView.swift
//  wordleBlitz
//
//  Created by Noah Frahm on 4/8/22.
//

import SwiftUI

struct HostView: View {
    
    @State var play: Bool = false
    @State var players: [String] = ["Ronald", "Bob", "Harry"]
    @State var confirmQuit: Bool = false
    @State var Quit: Bool = false

    @StateObject var gm: GameModel = GameModel()
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var gameCode: String = "BSAW"
    
    var body: some View {
        NavigationView{
            VStack{
                NavigationLink(destination: oneV1View(gm: gm)
                                .navigationBarTitle("")
                                .navigationBarBackButtonHidden(true)
                                .navigationBarHidden(true), isActive:
                                $play){
                    EmptyView()
                }
//                NavigationLink(destination: EmptyView()) {
//                    EmptyView()
//                }
                NavigationLink(destination: GameModeView()
                                .navigationBarTitle("")
                                .navigationBarBackButtonHidden(true)
                                .navigationBarHidden(true), isActive:
                                $Quit){
                    EmptyView()
                }
                NavigationLink(destination: EmptyView()) {
                    EmptyView()
                }


                List{
                    let playerCount = gm.game?.players.count ?? 0
                    Section(playerCount == 0 ? "Waiting on Players" : "\(playerCount - 1) Players"){
                    if gm.game == nil || playerCount == 1 {
                        ProgressView()
                    }
                    else {
                        ForEach(gm.game?.players.sorted(by: >) ?? [("NA","NA")], id: \.key) { id, name  in
                            if id != gm.currentUser.id {
                                HStack{
                                    Text(name)
                                }
                            }
                        }
                    }
                }.font(.title3)
                
                    Section{
                        Button(action: {
                            play = true
                            FirebaseService.shared.beginGame()
                        }) {
                            Text("Start Game")
                                .font(.title2)
                        }
                    }
                    
                    Button(action: {confirmQuit.toggle()}) {
                        Text("Quit")
                            .foregroundColor(.red)
                            .font(.title2)
                }
                }
                    .listStyle(InsetGroupedListStyle())
                
            }.alert(isPresented: $confirmQuit) {
                Alert(title: Text("Quit Game?"),
                primaryButton: .destructive(Text("Yes")) {
    //                add code to remove from game
//                    if FirebaseService.shared.game.players.count <= 1 {
//                        FirebaseService.shared.quitTheGame()
//                    }
//                    self.presentationMode.wrappedValue.dismiss()
                    Quit.toggle()
                    gm.leave()
                    confirmQuit.toggle()
                    print("Deleting...")
                },
                secondaryButton: .cancel(Text("No"))
                {confirmQuit.toggle()})
            }
            .navigationBarTitle("")
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
        }.onAppear{
            gm.getTheGame()
            gm.updateSolSet()
        }
    }
}

struct CreateView_Previews: PreviewProvider {
    static var previews: some View {
        HostView(gm: GameModel())
    }
}
