//
//  ErrorView.swift
//  wordleBlitz
//
//  Created by Noah Frahm on 4/14/22.
//

import SwiftUI

struct ErrorView: View {
    
    @State var home: Bool = false
    
//    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    
    var body: some View {
        if home {
            GameModeView()
        }
        else {
            VStack(alignment: .leading){
    //            NavigationLink(destination: GameModeView()
    //                            .navigationBarTitle("")
    //                            .navigationBarBackButtonHidden(true)
    //                            .navigationBarHidden(true), isActive:
    //                            $home){
    //                EmptyView()
    //            }
    //            NavigationLink(destination: EmptyView()) {
    //                EmptyView()
    //            }

                Text("An Error occured :(")
                Button("Back to Main Menu") {
                    FirebaseService.shared.reset()
                    home.toggle()
                }
            }
        }
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView()
    }
}
