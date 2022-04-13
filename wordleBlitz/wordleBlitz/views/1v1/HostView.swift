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
    @State var gm: gameModel
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var gameCode: String = "BSAW"
    
    var body: some View {
        NavigationView{
            VStack{
                NavigationLink(destination: oneV1View(ActiveGame: GameView(gml: gm))
                                .navigationBarTitle("")
                                .navigationBarBackButtonHidden(true)
                                .navigationBarHidden(true), isActive:
                                $play){
                    EmptyView()
                }

                List{
                    let playerCount = gm.game?.players.count ?? 0
                    Section(playerCount == 0 ? "Waiting on Players" : "\(playerCount) Players"){
                    if gm.game == nil {
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
                            if gm.game != nil {
                                // move into the game model
//                                gm.solution = gm.game!.solutionSet[0]
//                                gm.solutionSet = gm.game!.solutionSet
                                play = true
                                gm.game?.play = true
                            }
                            
                        }) {
                            Text("Start Game")
                                .font(.title2)
                        }
                    }
                    
                    Button(action: {confirmQuit = true}) {
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
                    self.presentationMode.wrappedValue.dismiss()
                    print("Deleting...")
                },
                secondaryButton: .cancel(Text("No"))
                )
            }
            .navigationBarTitle("")
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
        }.onAppear{
            gm.getTheGame()
        }
    }
}

struct CreateView_Previews: PreviewProvider {
    static var previews: some View {
        HostView(gm: gameModel())
    }
}
