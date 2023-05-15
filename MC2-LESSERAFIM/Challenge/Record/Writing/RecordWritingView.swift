//
//  RecordWritingView.swift
//  MC2-LESSERAFIM
//
//  Created by OhSuhyun on 2023/05/08.
//

import SwiftUI

struct RecordWritingView: View {
    @State var titleRecord: String = ""   // 챌린지 타이틀
    @State var contentRecord: String = ""   // 챌린지 내용
    
    @State private var showingAlert = false // 경고 출력 여부
    @Environment(\.dismiss) private var dismiss // 화면 이탈
    
    @State var onStory = false   // 챌린지 내용 입력 중 여부
    
    var body: some View {
        GeometryReader() { geo in   // 화면 크기 이용을 위해 사용
            VStack() {
                // 챌린지 제목
                TitleTextField(titleRecord: $titleRecord, placeholder: "이번 챌린지에 제목을 붙여볼까요?")
                    .submitLabel(.return)
                
                // 챌린지 내용
                OnlyWritingContentTextField(contentRecord: $contentRecord, onStory: false, placeholder: "어떤 이야기가 담겨있나요?")
                    .submitLabel(.return)
                    .frame(height: onStory ? geo.size.height - 100 : 620)   // 챌린지 내용 입력 중이면 키보드에 가리지 않게 크기 유동적으로 수정
                    .onTapGesture {
                        onStory = true
                        print(geo.size.height)
                    }
                
                // 위로 밀기
                Spacer()
                
            }   // VStack
            .font(.subheadline)
            .padding(.horizontal, 24)   // 양 옆 가드 영역
            // 내용 입력 누락 시 경고
            .alert("내용을 모두 작성해주세요", isPresented: $showingAlert) {
                Button("OK", role: .cancel) {
                    self.showingAlert = false
                }
            }
            // 제출 버튼
            .toolbar{
                Image(systemName: "checkmark.circle")
                    .foregroundColor(.mainPink) // 기본색이 검정이어서 변경
                    .onTapGesture {
                        if titleRecord == "" {   // 제목 입력 누락
                            print("no title")
                            self.showingAlert = true
                        } else if contentRecord == "" {    // 내용 입력 누락
                            print("no story")
                            self.showingAlert = true
                        } else {    // 내용 입력 누락이 없을 경우 제출 가능
                            dismiss()
                        }
                    }
            }
        }
    }   // body
}

struct RecordWritingView_Previews: PreviewProvider {
    static var previews: some View {
        RecordWritingView()
    }
}
