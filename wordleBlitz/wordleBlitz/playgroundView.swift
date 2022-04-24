//
//  playgroundView.swift
//  wordleBlitz
//
//  Created by Noah Frahm on 4/23/22.
//

import SwiftUI

struct playgroundView: View {
    
    @State var data = [6,7,12,14,7]
    let names = ["jack", "sim", "luda-chris", "j", "m"]
    let max = 18
    
    var body: some View {
//        VStack{
//            HStack{
//    //          names
//                VStack(alignment: .trailing){
//                    ForEach(0..<data.count, id: \.self) { index  in
//                        Text("\(names[index])")
//                    }
//                }
//
//    //      bars
//                VStack(alignment: .leading){
//                    ForEach(0..<data.count, id: \.self) { index  in
//                        let ratio = Double(data[index]) / Double(18)
//        //                HStack(alignment: .lastTextBaseline){
//                            Rectangle()
//                                .frame(width: ratio * 200, height: 40)
//                                .foregroundColor(.blue)
//                        }
//                    }
//            }
//            Text("waiting for other players to finish")
//        }
        VStack{
            HStack{
                Spacer()
                Text("waiting for other players to finish")
                    .bold()
                Spacer()
            }
        
        VStack(alignment: .leading){
            ForEach(0..<data.count, id: \.self) { index  in
                let ratio = Double(data[index]) / Double(18)
                HStack(alignment: .center){
                    Rectangle()
                        .frame(width: 250, height: 40)
                        .overlay(Text("\(data[index])").foregroundColor(.white).padding([.trailing], 10), alignment: .trailing)
                    .foregroundColor(.blue)
//                    Rectangle()
//                        .frame(width: ratio * 200, height: 40)
//                        .overlay(Text("\(data[index])").foregroundColor(.white).padding([.trailing], 10), alignment: .trailing)
//                    .foregroundColor(.blue)
                    Text("\(names[index])")
                }
            }
            }
        }
    }
}

struct playgroundView_Previews: PreviewProvider {
    static var previews: some View {
        playgroundView()
    }
}
