//
//  backgroundView.swift
//  MC2-LESSERAFIM
//
//  Created by Jun on 2023/05/11.
//

import SwiftUI

let circleColors = [Color(red:248/255, green: 149/255, blue: 203/255),
                    Color(red:253/255, green: 181/255, blue: 131/255),
                    Color(red:115/255, green: 183/255, blue: 236/255),
                    Color(red:178/255, green: 132/255, blue: 246/255),
                    Color(red:255/255, green: 215/255, blue: 110/255),
                    Color(red:124/255, green: 224/255, blue: 202/255),
]


struct backgroundView: View {
    
    struct offset {
        var x: CGFloat
        var y: CGFloat
    }

    @State var offsets = [offset(x:(80 - 393)/4, y:(-67 - 852)/4),
                          offset(x:(139.63 - 393)/4, y:(-67 - 852)/4),
                          offset(x:(-33.33 - 393)/4, y:(307.24)/4),
                          offset(x:(199.83 - 393)/4, y:(238.78)/4),
                          offset(x:(-80 - 393)/4, y:(578.94)/4),
                          offset(x:(139.63 - 393)/4, y:(524.26 - 852)/4)
    ]
    /* (0..<6).map { _ in
        offset(x: CGFloat.random(in: -135...135) , y: CGFloat.random(in: -173...173))
    }*/
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 5.0)
                .frame(width: UIScreen.main.bounds.width - 48, height: 346)
                .shadow(radius: 5.0)
                .foregroundColor(Color.white)
            ForEach(0..<6) { i in
                Ellipse()
                    .fill(circleColors[i])
                    .offset(x:offsets[i].x, y:offsets[i].y)
                    .frame(width: 270, height: 346)
                    .blur(radius: 50.0)
                    .opacity(1.0)
                    .mask{
                        RoundedRectangle(cornerRadius: 5.0)
                            .frame(width: UIScreen.main.bounds.width - 48, height: 346)
                            .shadow(radius: 5.0)
                            .foregroundColor(Color.white)
                    }
            }
        }
    }
}

struct backgroundView_Previews: PreviewProvider {
    static var previews: some View {
        backgroundView()
    }
}

struct background2View: View {
    @EnvironmentObject var userData: UserData
    
    var width: CGFloat
    var height: CGFloat
    
    struct Offset {
        var x: CGFloat
        var y: CGFloat
    }
    // 59.96 // 255.9
    @State var offsets: [Offset] = []
    
    var body: some View {
        ZStack{
            if !offsets.isEmpty{
                ForEach(0..<6) { i in
                    Ellipse()
                        .fill(circleColors[i])
                        .offset(x:offsets[i].x, y:offsets[i].y)
                        .opacity(userData.opacities[i])
                        .frame(width: 300, height: 346)
                        .blur(radius: 50.0)
                        .opacity(1.0)
                }
            }
        }.onAppear{
            offsets = [
                Offset(x:(-58.04 - 59.96) * (width / 393), y:(10 - 255.9) * (height / 852)),
                Offset(x:(139.63 - 59.96) * (width / 393), y:(-67 - 255.9) * (height / 852)),
                Offset(x:(-33.33 - 59.96) * (width / 393), y:(307.24 - 255.9) * (height / 852)),
                Offset(x:(199.83 - 59.96) * (width / 393), y:(238.78 - 255.9) * (height / 852)),
                Offset(x:(-80 - 59.96) * (width / 393), y:(578.94 - 255.9) * (height / 852)),
                Offset(x:(139.63 - 59.96) * (width / 393), y:(524.26 - 255.9) * (height / 852))]
        }
    }
}
