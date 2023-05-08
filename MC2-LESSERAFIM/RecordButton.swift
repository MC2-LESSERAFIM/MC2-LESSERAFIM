//
//  RecordButton.swift
//  MC2-LESSERAFIM
//
//  Created by OhSuhyun on 2023/05/08.
//

import SwiftUI

struct RecordButton<Destination: View>: View {
    var radiusButton: Double = 12   // 버튼 곡률 값
    let colorDefaultButton = Color(red: 153/255, green: 153/255, blue: 153/255) // 버튼 색상
    
    var viewDestination: Destination    // 동작 시 전환할 화면
    var labelTitle: String = "" // 버튼 라벨
    var labelImage: String = "" // 버튼 아이콘 이미지
    
    init(viewDestination: Destination, labelTitle: String = "", labelImage: String = "") {  // 생성자
        self.viewDestination = viewDestination
        self.labelTitle = labelTitle
        self.labelImage = labelImage
    }
    
    var body: some View {
        Button(action: {
            NavigationLink(destination: viewDestination) {
                    EmptyView()
                }
        }, label: {
            VStack {
                // 버튼 아이콘
                Image(labelImage)
                    .resizable()    // 이미지 크기 수정 가능
                    .aspectRatio(contentMode: .fit) // 이미지 비율 고정
                    .frame(height: 24)  // 높이 기준 이미지 크기 수정
                
                // 버튼 라벨
                Text(labelTitle)
                    .foregroundColor(Color.white)   // 글씨 색상
                    .font(.system(size: 17))    // 글씨 크기
                    .fontWeight(.semibold)  // 글씨 두께
            }
            // 버튼 스타일
            .frame(width: 107, height: 96)  // 버튼 크기
            .background(colorDefaultButton) // 버튼 색상
            .cornerRadius(radiusButton) // 버튼 곡률
        })
    }
}

struct RecordButton_Previews: PreviewProvider {
    static var previews: some View {
        RecordButton(viewDestination: Text("Hello, World!"), labelTitle: "Button", labelImage: "myImage")
    }
}
