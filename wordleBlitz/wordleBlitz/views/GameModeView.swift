//
//  GameModeView.swift
//  wordleBlitz
//
//  Created by Noah Frahm on 4/4/22.
//

import SwiftUI

struct GameModeView: View {
    
//    0 = solo, 1 = hangman, 2 = 1v1
    @State var gameMode: [Bool] = [false, false, false]
    @State var editUserName: Bool = false
    
    var body: some View {
        NavigationView{
            VStack{
                NavigationLink(destination: SoloView().navigationBarBackButtonHidden(true).navigationBarHidden(true), isActive: $gameMode[0]) {
                    EmptyView()
                }
                NavigationLink(destination: MultiplayerOptionsView().navigationBarBackButtonHidden(true).navigationBarHidden(true), isActive: $gameMode[1]) {
                    EmptyView()
                }
                HStack{
                    Spacer()
                    Button(action: {editUserName.toggle()}) {
                        Image(systemName: "gear")
                            .foregroundColor(.black)
                            .font(.title)
                    }
                }
                .padding([.trailing, .top])
                
                Spacer()
                
                Image(systemName: "w.square")
                    .foregroundColor(.brown)
                    .font(.system(size: 200))
               
                GameModeButtonView(navBool: $gameMode[0], title: "Solo")
                                
                GameModeButtonView(navBool: $gameMode[1], title: "1V1")
                
                Spacer()
            }
            .navigationBarBackButtonHidden(true).navigationBarHidden(true)
            }
            .sheet(isPresented: $editUserName) {
                ChangeUsernameView(show: $editUserName)
            }
    }
}

struct GameModeView_Previews: PreviewProvider {
    static var previews: some View {
        GameModeView()
    }
}


struct GameModeButtonView: View {
    
    @Binding var navBool: Bool
    var title: String
    
    var body: some View {
        Button(action: {navBool.toggle()}) {
            ZStack{
                RoundedRectangle(cornerRadius: 2)
                    .frame(width: 300, height: 80, alignment: .center)
                    .foregroundColor(.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(.black, lineWidth: 2))
                Text(title)
                    .foregroundColor(.black)
                    .font(.title)
            }
        }
    }
}
