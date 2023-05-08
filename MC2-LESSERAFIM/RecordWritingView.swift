//
//  RecordWritingView.swift
//  MC2-LESSERAFIM
//
//  Created by OhSuhyun on 2023/05/08.
//

import SwiftUI

struct RecordWritingView: View {
    @State private var title: String = ""
    
    var body: some View {
        ZStack {
            VStack {
                // 챌린지 타이틀
                VStack {
                    TextEditor(text: $title)
                        .frame(width: 345, height: 39)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .onAppear {
                            UITextView.appearance().backgroundColor = .clear
                        }
                        .multilineTextAlignment(.center)
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                }
                .overlay(
                    Text(title.isEmpty ? "이번 챌린지에 제목을 붙여볼까요?" : "")
                        .font(.headline)
                        .frame(width: 345, alignment: .topLeading)
                        .foregroundColor(Color(.systemGray4))
                        .offset(x: 0, y: title.isEmpty ? -10 : 10)
                        .animation(.easeInOut(duration: 0.2))
                    , alignment: .top
                )
                
                // 챌린지 내용
                VStack {
                    TextEditor(text: $title)
                        .frame(width: 345, height: 561)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .onAppear {
                            UITextView.appearance().backgroundColor = .clear
                        }
                        .multilineTextAlignment(.center)
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                }
                .overlay(
                    Text(title.isEmpty ? "어떤 이야기가 담겨있나요?" : "")
                        .font(.headline)
                        .frame(width: 345, alignment: .topLeading)
                        .foregroundColor(Color(.systemGray4))
                        .offset(x: 0, y: title.isEmpty ? -10 : 10)
                        .animation(.easeInOut(duration: 0.2))
                    , alignment: .top
                )
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
