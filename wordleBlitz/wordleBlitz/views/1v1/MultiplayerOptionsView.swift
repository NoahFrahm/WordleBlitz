//
//  MultiplayerOptionsView.swift
//  wordleBlitz
//
//  Created by Noah Frahm on 4/7/22.
//

import SwiftUI

struct MultiplayerOptionsView: View {
     
    @State var create: [Bool] = [false, false]
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        NavigationView{
            VStack(alignment: .center, spacing: 20){
                NavigationLink(destination: HostView()
                                .navigationBarTitle("")
                                .navigationBarHidden(true)
                                .navigationBarBackButtonHidden(true)
                    , isActive: $create[0]) {
                    EmptyView()
                }
                NavigationLink(destination: JoinView()
                                .navigationBarTitle("")
                                .navigationBarHidden(true)
                                .navigationBarBackButtonHidden(true)
                    , isActive: $create[1]) {
                    EmptyView()
                }
//                NavigationLink(destination: EmptyView()) {
//                    EmptyView()
//                }

                Spacer()
                Image(systemName: "gamecontroller.fill")
                    .font(.system(size: 200))
                    .padding([.bottom], 50)
                OptionButtonView(text: "CREATE GAME",create: $create[0])
                OptionButtonView(text: "JOIN GAME",create: $create[1])
                
//                OptionButtonView(text: "BACK",create: $create[1])
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("BACK")
                        .frame(width: 200, height: 20, alignment: .center)
                        .font(.system(size: 18))
                        .padding()
                        .foregroundColor(.black)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.black, lineWidth: 2)
                        )
                }
                
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
