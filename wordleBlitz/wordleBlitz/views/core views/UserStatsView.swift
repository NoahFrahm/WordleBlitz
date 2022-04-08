//
//  UserStatsView.swift
//  wordleBlitz
//
//  Created by Noah Frahm on 4/3/22.
//

import SwiftUI

struct UserStatsView: View {
    
//    fetch this frequncy data from db
    @State var frequency: [Int] = [0,0,0,0,0,0]
    var endVals: [Int] = [1, 2, 3, 2, 1, 0]
    @Binding var show: Bool
        
    var barLength: Double = 100
    var sumGuesses: Double {
        var total = 0.0
        for num in frequency {
            total += Double(num)
        }
        return total
    }
    var ratios: [Double] {
        var ratis: [Double] = []
        for freq in frequency{
            ratis.append(Double(freq) / (sumGuesses == 0 ? 1 : sumGuesses))
        }
        return ratis
    }
    
    var fillin: Color = .white
    var buttonFill: Color = .white
    
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Spacer()
                Button(action: {show.toggle()}) {
                    Image(systemName: "xmark")
                        .foregroundColor(.gray)
                }
            }
            HStack{
                Spacer()
                Text("**Guess Distribution**")
                    .font(.title2)
                Spacer()
            }
            
            VStack(alignment: .leading){
                ForEach(0...(frequency.count - 1), id: \.self) { index in
                    HStack(alignment: .center){
                        Text("\(index + 1)")
                        Rectangle()
                            .foregroundColor(.blue)
                            .frame(width: 1 + barLength * ratios[index] , height: 50, alignment: .leading)
                            .onAppear {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                      withAnimation(
                                        .easeInOut(duration: 0.5)){
                                          frequency[index] = endVals[index]
                                        }
                                      }
                                    }
                        Text("\(frequency[index])")
                    }
                }.padding([.leading, .trailing])
            }
            .frame(width: 300 , height: 350, alignment: .leading)
            .padding([.top, .bottom])

            HStack{
                Spacer()
                Button(action: {show.toggle()}) {
                    ZStack{
                        RoundedRectangle(cornerRadius: 25)
                            .fill(buttonFill)
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(.black, lineWidth: 2))
                            .frame(width: 150, height: 50, alignment: .center)

                        Text("Close")
                            .foregroundColor(.black)
                            .font(.title)
                    }
                }
//                Button(action: {show.toggle()}) {
//                    ZStack{
//                        RoundedRectangle(cornerRadius: 25)
//                            .fill(buttonFill)
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 25)
//                                    .stroke(.black, lineWidth: 2))
//                            .frame(width: 150, height: 50, alignment: .center)
//
//                        Text("Quit")
//                            .foregroundColor(.black)
//                            .font(.title)
//                    }
//                }
                Spacer()
            }
        }
        .padding()
        .frame(width: 365, height: 520)

        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(fillin)
            )
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(.black, lineWidth: 2)
            )
        .padding()
        .frame(width: 400, height: 200)
    }
}


struct UserStatsView_Previews: PreviewProvider {
    static var previews: some View {
        UserStatsView(show: .constant(true))
    }
}
