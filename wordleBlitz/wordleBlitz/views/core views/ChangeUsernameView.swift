//
//  ChangeUsernameView.swift
//  wordleBlitz
//
//  Created by Noah Frahm on 4/7/22.
//

import SwiftUI

struct ChangeUsernameView: View {
    
    @State var gm: GameModel = GameModel()
    @State var typedName: String = ""
    @Binding var show: Bool
    
    var body: some View {
        VStack{
            HStack{
                Spacer()
                Button(action: {show.toggle()}){
                    Image(systemName: "cross")
                        .font(.largeTitle)
                        .foregroundColor(.black)
                }
            }.padding()
            
            Spacer()
            
            Text("Current Username: \(gm.currentUser.name)")
            
            Text("New Username must be 8 characters or less")

            TextField("userName", text: $typedName)
                .keyboardType(.default)
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 25).stroke())
                .padding()
                .onSubmit {
                    if typedName.count < 8 {
                        gm.changeUserName(name: typedName)
                        show = false
                    }
                }
            Spacer()
//            Text(typedName)
        }
    }
}

struct ChangeUsernameView_Previews: PreviewProvider {
    static var previews: some View {
        ChangeUsernameView(show: .constant(true))
    }
}
