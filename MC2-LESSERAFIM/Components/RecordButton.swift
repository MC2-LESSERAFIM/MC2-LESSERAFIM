//
//  RecordButton.swift
//  MC2-LESSERAFIM
//
//  Created by OhSuhyun on 2023/05/08.
//

import SwiftUI

struct RecordButton: View {
    var radiusButton: Double = 12   // 버튼 곡률 값
    
    var labelTitle: String = "" // 버튼 라벨
    var labelImage: String = "" // 버튼 아이콘 이미지
    var colorButton = Color.opacityWhite    // 버튼 색상
    var colorButtonIcon = Color.mainBlack   // 버튼 텍스트 및 아이콘 색상
    
    var body: some View {
        VStack {
            // 버튼 아이콘
            Image(systemName: labelImage)
                .resizable()    // 이미지 크기 수정 가능
                .aspectRatio(contentMode: .fit) // 이미지 비율 고정
                .foregroundColor(colorButtonIcon)   // 글씨 색상
                .frame(height: 24)  // 높이 기준 이미지 크기 수정
            
            // 버튼 라벨
            Text(labelTitle)
                .foregroundColor(colorButtonIcon)   // 글씨 색상
                .font(.system(size: 17))    // 글씨 크기
                .fontWeight(.semibold)  // 글씨 두께
        }
        // 버튼 스타일
        .frame(width: 107, height: 96)  // 버튼 크기
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.mainPinkOpacity, lineWidth: 2)
        )
        .background(colorButton) // 버튼 색상
        .cornerRadius(12)   // 배경 버튼 곡률
    }
}

struct RecordButton_Previews: PreviewProvider {
    static var previews: some View {
        RecordButton(labelTitle: "Button", labelImage: "myImage")
    }
}
