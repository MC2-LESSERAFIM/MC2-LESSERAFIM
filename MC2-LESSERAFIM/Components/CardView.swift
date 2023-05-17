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
        
            RoundedRectangle(cornerRadius: 24)
                .inset(by: -1)
                .stroke(Color.opacityWhiteChallenge, lineWidth: 2)
                .frame(width: 343, height: 610)
            
            BackgroundView()
                .mask{
                    RoundedRectangle(cornerRadius: 24)
                        .foregroundColor(.white)
                        .frame(width: 343, height: 610) // 기존 크기 343, 463, 현재 비율 약 16:9
                }
                .frame(width: 343, height: 610)
                .shadow(color: .white.opacity(0.5), radius: 17, x: 0, y: 4)
                .overlay{
                        if isFront{
                            if post.imageData != nil {
                                Image.fromData(post.imageData!)!
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
                        }
                        else {
                            VStack(alignment: .leading) {
                                Text("Day \(post.day.description)")
                                    .fontWeight(.bold)
                                    .font(.system(size: 20))
                                    .foregroundColor(.mainPink)
                                    .padding([.leading, .bottom], 5)
                                
                                TitleTextField(titleRecord: .constant(post.title!), placeholder: post.title!)
                                    .disabled(true)
                                
                                cardContentTextField(contentRecord: post.content!)
                            }
                            .padding(20)
                            .frame(width:343, height: 610, alignment: .top)
                            .opacity(isFront ? 0 : 1)
                            .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                    }
                }
        }
        .onTapGesture {
            if post.imageData != nil {
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
        }
        .onAppear {
            if post.imageData == nil {
                isFront = false
                degrees += 180
            }
        }
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 30, trailing: 0))
        .rotation3DEffect(.degrees(degrees), axis: (x: 0, y: 1, z: 0), perspective: 0.2)
        .foregroundColor(.mainBlack)
    }
}
