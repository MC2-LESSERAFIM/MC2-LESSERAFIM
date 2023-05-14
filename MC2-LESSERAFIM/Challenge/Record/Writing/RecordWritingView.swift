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
    
    @State private var onStory = false   // 챌린지 내용 입력 중 여부
    
    var body: some View {
        GeometryReader() { geo in   // 화면 크기 이용을 위해 사용
            VStack() {
                // 챌린지 내용
                TextField("이번 챌린지에 제목을 붙여볼까요?", text: $titleRecordWriting)
                    .textFieldStyle(.plain)
                    .frame(height: 39, alignment: .center)
                    .padding(.leading, 5)
                    .lineLimit(1)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray, lineWidth: 0.5)
                    )
                    .onTapGesture {
                        onStory = false
                    }
                
                // 챌린지 내용
                TextField("어떤 이야기가 담겨있나요?", text: $storyRecordWriting, axis: .vertical)
                    .textFieldStyle(.plain)
//                    .frame(height: geo.size.height - 100, alignment: .top)
                    .frame(height: onStory ? geo.size.height - 100 : 620.7, alignment: .top)   // 챌린지 내용 입력 중이면 키보드에 가리지 않게 크기 유동적으로 수정
                    .padding(.top, 11)
                    .padding(.leading, 5)
                    .lineLimit(onStory ? 16... : 28...)  // 키보드X: 31줄, 키보드O: 16줄
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray, lineWidth: 0.5)
                    )
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
                    .foregroundColor(.blue) // 기본색이 검정이어서 변경
                    .onTapGesture {
                        if titleRecordWriting == "" {   // 제목 입력 누락
                            print("no title")
                            self.showingAlert = true
                        } else if storyRecordWriting == "" {    // 내용 입력 누락
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
