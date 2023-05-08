//
//  RecordSelectionView.swift
//  MC2-LESSERAFIM
//
//  Created by OhSuhyun on 2023/05/08.
//

import SwiftUI

struct RecordSelectionView: View {
    
    var body: some View {
        ZStack{
            VStack {    // 내비게이션 백버튼 - 타이틀 - 기록선택버튼
                // 내비게이션 백버튼
                
                // 화면 타이틀(PageTitle)
                PageTitle(titlePage: "챌린지를 기록해보아요")
                
                // 기록선택버튼(RecordButton)
                HStack {
                    // 사진 버튼
                    RecordButton(
                        viewDestination: ContentView(),
                        labelTitle: "사진 + 글",
                        labelImage: "camera.fill@5x"
                    )
                    
                    // 글 버튼
                    RecordButton(
                        viewDestination: RecordWritingView(),
                        labelTitle: "글",
                        labelImage: "square.and.pencil@5x"
                    )
                    .padding(.horizontal, 12)   // 버튼 간의 갭
                    
                    // 그림 버튼
                    RecordButton(
                        viewDestination: ContentView(),
                        labelTitle: "그림",
                        labelImage: "paintpalette.fill@5x"
                    )
                }
                .padding(.top, 48)  // 타이틀과의 갭 영역
                .padding(.horizontal, 24)   // 양 옆 가드 영역
                
                // 위로 밀기
                Spacer()
            }
        }
    }
}

struct RecordSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        RecordSelectionView()
    }
}
