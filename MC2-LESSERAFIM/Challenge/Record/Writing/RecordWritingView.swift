//
//  RecordWritingView.swift
//  MC2-LESSERAFIM
//
//  Created by OhSuhyun on 2023/05/08.
//

import SwiftUI

struct RecordWritingView: View {
    @State private var title: String = ""   // 챌린지 타이틀
    @State private var story: String = ""   // 챌린지 내용
    
    var body: some View {
        ZStack {
            VStack {
                // 챌린지 타이틀
                ZStack {
                    
                    // 챌린지 타이틀 입력란
                    VStack {
                            /*
                             TextEditor(text: $title)
                             .frame(width: 345, height: 39)
                             .cornerRadius(5)
                             .multilineTextAlignment(.leading)
                             .font(.system(size: 13))
                             .offset(x: 0, y: 3) // 위치 조정
                             */
                    }
                    // 챌린지 타이틀 플레이스홀더
                    .overlay(
                        Text(title.isEmpty ? "이번 챌린지에 제목을 붙여볼까요?" : "")
                            .font(.system(size: 13))
                            .frame(width: 345, alignment: .topLeading)
                            .foregroundColor(Color(.systemGray4))
                            .offset(x: 5)    // 위치 조정
                            .animation(.easeInOut(duration: 0.05))
//                        , alignment: .top
                    )
                    
                    // 챌린지 타이틀 프레임
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray, lineWidth: 0.5)
                        .frame(width: 345, height: 39)
                }
                
                // 챌린지 내용
                ZStack {
                    
                    // 챌린지 타이틀 입력란
                    VStack {
                        TextEditor(text: $story)
                            .frame(width: 345, height: 561)
                            .cornerRadius(5)
                            .onAppear {
                                UITextView.appearance().backgroundColor = .clear
                            }
                            .multilineTextAlignment(.leading)
                            .font(.system(size: 13))
                            .offset(x: 0, y: 3)
                            .padding(.horizontal)
                    }
                    // 챌린지 타이틀 플레이스홀더
                    .overlay(
                        Text(story.isEmpty ? "어떤 이야기가 담겨있나요?" : "")
                            .font(.system(size: 13))
                            .frame(width: 345, alignment: .topLeading)
                            .foregroundColor(Color(.systemGray4))
                            .offset(x: 5, y: 11)
                            .animation(.easeInOut(duration: 0.05))
                        , alignment: .top
                    )
                    
                    // 챌린지 타이틀 프레임
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray, lineWidth: 0.5)
                        .frame(width: 345, height: 561)
                }
                .padding(.top, 11)
            }
            .padding(.horizontal, 24)   // 양 옆 가드 영역
            
            Spacer()    // 위로 밀기
        }
    }
}

struct RecordWritingView_Previews: PreviewProvider {
    static var previews: some View {
        RecordWritingView()
    }
}
