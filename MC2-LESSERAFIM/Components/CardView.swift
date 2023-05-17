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
                        .frame(width: 343, height: 610) // 기존 크기 343, 463, 현재 비율 약 16:9
                }
                .shadow(color: .white.opacity(0.5), radius: 17, x: 0, y: 4)
            if isFront{
                (Image.fromData(post.imageData ?? Data()) ?? Image("boy1"))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width:343, height: 610)
                    .mask{
                        RoundedRectangle(cornerRadius: 24)
                            .foregroundColor(.white)
                            .frame(width: 343, height: 610)
                    }
                    .opacity(isFront ? 1 : 0)
            }
            else {
                VStack{
                    Text("Title : \(post.title!)")
                    Text("Content : \(post.content!)")
                    if post.imageData != nil {
                        Text("Image here")
                        
                    }
                    Text("Day : \(post.day.description)")
                    Text("isFirst? : \(post.isFirstPost.description)")
                }
                .opacity(isFront ? 0 : 1)
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
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                isFront.toggle()
            }
        }
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 30, trailing: 0))
        .rotation3DEffect(.degrees(degrees), axis: (x: 0, y: 1, z: 0), perspective: 0.2)
        .foregroundColor(.black)
    }
}
