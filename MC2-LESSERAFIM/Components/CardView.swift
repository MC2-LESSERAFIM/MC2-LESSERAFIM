//
//  CardView.swift
//  MC2-LESSERAFIM
//
//  Created by Jun on 2023/05/17.
//

import SwiftUI

struct CardView: View {
    let post: Post
    @State var degrees = 0.0
    @State var isFront = true
    
    var body: some View {
        ZStack{
            
            BackgroundView()
                .mask{
                    RoundedRectangle(cornerRadius: 24)
                        .foregroundColor(.white)
                        .frame(width: 343, height: 463)
                }
                .shadow(color: .white.opacity(0.5), radius: 17, x: 0, y: 4)
            if isFront{
                VStack{
                    (Image.fromData(post.imageData ?? Data()) ?? Image("niko"))
                        .resizable()
                        .frame(width:343, height: 232)
                        .scaledToFit()
                }
            }
            else {
                VStack{
                    Text("Title : \(post.title!)")
                    Text("Content : \(post.content!)")
                    if post.imageData != nil {
                        Text("Image here")
                        Image.fromData(post.imageData!)!
                            .resizable()
                            .frame(width:343, height: 232)
                            .scaledToFit()
                    }
                    Text("Day : \(post.day.description)")
                    Text("isFirst? : \(post.isFirstPost.description)")
                }
                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
            }
        }
        .onTapGesture {
            withAnimation(.linear(duration: 0.2)) {
                print(degrees)
                if(degrees<180){
                    degrees = 180
                }
                else{
                    degrees = 0
                }
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) {
                isFront.toggle()
            }
        }
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 30, trailing: 0))
        .rotation3DEffect(.degrees(degrees), axis: (x: 0, y: 1, z: 0), perspective: 0.2)
        .foregroundColor(.black)
    }
}
