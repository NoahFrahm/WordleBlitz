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
    
    var body: some View {
        VStack{
            NavigationLink(destination: GameModeView()
                            .navigationBarTitle("")
                            .navigationBarBackButtonHidden(true)
                            .navigationBarHidden(true), isActive:
                            $goHome){
                EmptyView()
            }
//                            .isDetailLink(false)
//            NavigationLink(destination: EmptyView()) {
//                EmptyView()
//            }.isDetailLink(false)
            
            Text("the podium")
            if fire.game != nil {
                ForEach(fire.game.players.sorted(by: >) , id: \.key) { id, name  in
                        HStack{
                            Text(name)
                            Rectangle()
                                .frame(width: 100, height: 40)
                                .foregroundColor(.red)
                        }
                }
            }
            Button("return to menu") {
                goHome = true
            }
            
        }
    }
}

struct podiumView_Previews: PreviewProvider {
    static var previews: some View {
        podiumView()
    }
}
