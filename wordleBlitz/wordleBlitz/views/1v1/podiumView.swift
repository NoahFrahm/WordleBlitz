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
            
            Text("the podium")
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
