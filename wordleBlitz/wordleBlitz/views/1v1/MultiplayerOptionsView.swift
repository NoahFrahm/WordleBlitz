//
//  MultiplayerOptionsView.swift
//  wordleBlitz
//
//  Created by Noah Frahm on 4/7/22.
//

import SwiftUI

struct MultiplayerOptionsView: View {
     
    @State var create: Bool = false
    
    var body: some View {
        NavigationView{
            VStack(alignment: .center, spacing: 20){
                NavigationLink(destination: CreateView()
                                .navigationBarTitle("")
                                .navigationBarHidden(true)
                                .navigationBarBackButtonHidden(true)
                    , isActive: $create) {
                    EmptyView()
                }
                Spacer()
                Image(systemName: "gamecontroller.fill")
                    .font(.system(size: 200))
                    .padding([.bottom], 50)
                OptionButtonView(text: "CREATE GAME",create: $create)
                OptionButtonView(text: "JOIN GAME",create: $create)
//                    .padding([.bottom], 100)
//                OptionButtonView(text: "HOW TO PLAY",create: $create)
                Spacer()
            }
        }
    }
}

struct OptionButtonView: View {
    
    var text: String
    
    @Binding var create: Bool
    
    var body: some View {
        Button(action: {
            create.toggle()
        }) {
            Text(text)
                .frame(width: 200, height: 20, alignment: .center)
                .font(.system(size: 18))
                .padding()
                .foregroundColor(.black)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.black, lineWidth: 2)
                )
        }
    }
}

struct MultiplayerOptionsView_Previews: PreviewProvider {
    static var previews: some View {
        MultiplayerOptionsView()
    }
}
