//
//  RecordSelectionView.swift
//  MC2-LESSERAFIM
//
//  Created by OhSuhyun on 2023/05/08.
//

import SwiftUI

struct RecordSelectionView: View {
    
    @State private var showActionSheet = false  // 사진+글 버튼 선택 여부 == 액션시트 표출 여부
    let colorDefaultButton = Color(red: 153/255, green: 153/255, blue: 153/255) // 버튼 색상
    let colorSelectedButton = Color.blue
    
    var width: CGFloat
    var height: CGFloat
    @Binding var opacities: [CGFloat]
    
    var body: some View {
        GeometryReader{ geo in
            NavigationView{
                VStack {    // 내비게이션 백버튼 - 타이틀 - 기록선택버튼
                    // 내비게이션 백버튼
                    
                    // 화면 타이틀(PageTitle)
                    PageTitle(titlePage: "챌린지를 기록해보아요")
                    
                    // 기록선택버튼(RecordButton)
                    HStack {
                        // 기록/사진 화면 이동 버튼 및 액션시트
                        Button(action: {
                            self.showActionSheet = true // 버튼 선택 시 액션시트 표출
                        }) {
                            RecordButton(
                                labelTitle: "사진 + 글",
                                labelImage: "camera.fill@5x",
                                colorButton: self.showActionSheet ? colorSelectedButton : colorDefaultButton    // 액션 시트 표출 여부에 따른 버튼 배경색 변경
                            )
                        }
                        // 기록/사진 화면의 액션시트
                        .actionSheet(isPresented: $showActionSheet) {
                            ActionSheet(
                                title: Text("기록할 사진은 어떻게 가져오시겠어요?"),
                                // 액션시트 리스트
                                buttons: [
                                    .default(Text("사진 첨부"), action: {
                                        // 항목 1 선택 시 처리
                                    }),
                                    .default(Text("사진 촬영"), action: {
                                        // 항목 2 선택 시 처리
                                    }),
                                    .cancel(Text("취소"))
                                ]
                            )
                        }
                        
                        // 기록/글 화면 이동 버튼
                        NavigationLink(destination: RecordWritingView()) {
                            RecordButton(
                                labelTitle: "글",
                                labelImage: "square.and.pencil@5x",
                                colorButton: colorDefaultButton
                            )
                            .padding(.horizontal, 12)   // 버튼 간의 갭
                        }
                        
                        // 기록/그림 화면 이동 버튼
                        NavigationLink(destination: CanvusView()) {
                            RecordButton(
                                labelTitle: "그림",
                                labelImage: "paintpalette.fill@5x",
                                colorButton: colorDefaultButton
                            )
                        }
                    }
                    .padding(.top, 48)  // 타이틀과의 갭 영역
                    .padding(.horizontal, 24)   // 양 옆 가드 영역
                    
                    // 위로 밀기
                    Spacer()
                }
                .navigationTitle("")
            }
        }
    }
}
