//
//  animatedLetter.swift
//  wordleBlitz
//
//  Created by Noah Frahm on 4/3/22.
//

import SwiftUI

struct animatedLetter: View {
    //                        withAnimation(.spring()){
    //                        withAnimation(.easeIn){
    //                            typed.append("t")
    //                        }
    
    @State var letter  = ""
//    @State var typed: [String] = [String]()
    @State var typed: String = ""

    @State var showUi: Bool = false
    
    func typeLetter() {
        withAnimation{
            typed = "t"
            showUi.toggle()
        }
    }
    
    var body: some View {
        VStack{
            HStack{
                Button(action: {
                    typeLetter()
                }) {
                    Text("type")
                }
                Button(action: {
                    typeLetter()
//                    typed = ""
//                    showUi.toggle()
                }) {
                    Text("delete")
                }
            }
            if showUi {
                SingleLetter(buchstabe: typed).typed
                    .transition(.scale(scale: 1.2, anchor: .center))
            }
            else {
                SingleLetter().empty
                    .transition(.scale(scale: 1.2, anchor: .center))

            }
//            HStack{
//                ForEach(0..<5) { index in
//                    if index > (typed.count - 1) {
//                        SingleLetter().empty
//                    }
//                    if index == (typed.count - 1) {
//                        SingleLetter(buchstabe: typed[index]).typed
//                            .transition(.scale(scale: 5, anchor: .center))
//                    }
//                    else{
//                        SingleLetter(buchstabe: typed[index]).typed
//                    }
//                }
//            }
            
//            HStack{
//                Button(action: {
//                    withAnimation{
//                        if typed.count < 5 {
//                            typed.append("t")
////                                .transition
//                        }
//                    }
//                }) {
//                    Text("type")
//                }
//                Button(action: {
//                    if typed.count > 0 {
//                        _ = typed.popLast()
//                    }
//                }) {
//                    Text("delete")
//                }
//            }
//            HStack{
//                ForEach(0..<5) { index in
//                    if index > (typed.count - 1) {
//                        SingleLetter().empty
//                    }
//                    else{
//                        SingleLetter(buchstabe: typed[index]).typed
//                    }
//                }
//            }
        }
    }
}

struct animatedLetter_Previews: PreviewProvider {
    static var previews: some View {
        animatedLetter()
    }
}
