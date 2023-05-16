//
//  RecordSelectionView.swift
//  MC2-LESSERAFIM
//
//  Created by OhSuhyun on 2023/05/08.
//

import SwiftUI

struct RecordSelectionView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    var challenge: Challenge
    
    @State private var showActionSheet = false  // 사진+글 버튼 선택 여부 == 액션시트 표출 여부
    let colorDefaultButton = Color.opacityWhiteChallenge // 버튼 색상
    let colorSelectedButton = Color.mainPink
//    @State var isWritingView: Bool = false
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack {    // 내비게이션 백버튼 - 타이틀 - 기록선택버튼
                // 내비게이션 백버튼
                
                // 화면 타이틀(PageTitle)
                PageTitle(titlePage: "챌린지를 기록해보아요")
                
                // 기록선택버튼(RecordButton)
                HStack {
                    // 기록/글 화면 이동 버튼
                    NavigationLink(destination:
                                    WritingView(challenge: challenge).environment(\.managedObjectContext, viewContext)
                    ) {
                        RecordButton(
                            labelTitle: "사진 + 글",
                            labelImage: "camera.fill",
                            colorButton: colorDefaultButton
                        )
                    }
                    
                    Spacer()
                    
                    // 기록/글 화면 이동 버튼
                    NavigationLink(destination:
                                    RecordWritingView(challenge: challenge).environment(\.managedObjectContext, viewContext)
                    ) {
                        RecordButton(
                            labelTitle: "글",
                            labelImage: "square.and.pencil",
                            colorButton: colorDefaultButton
                        )
//                        .padding(.horizontal, 12)   // 버튼 간의 갭
                    }
                    
                    Spacer()
                    
                    // 기록/그림 화면 이동 버튼
                    NavigationLink(destination: CanvusView(challenge: challenge).environment(\.managedObjectContext, viewContext)) {
                        RecordButton(
                            labelTitle: "그림",
                            labelImage: "paintpalette.fill",
                            colorButton: colorDefaultButton
                        )
                    }
                }
                .padding(.top, 36)  // 타이틀과의 갭 영역
                
                // 위로 밀기
                Spacer()
            }
            .padding(.horizontal, 24)   // 양 옆 가드 영역
            .navigationTitle("")
        }
    }
}
