//
//  PageTitle.swift
//  MC2-LESSERAFIM
//
//  Created by OhSuhyun on 2023/05/08.
//

import SwiftUI

struct PageTitle: View {
    var titlePage: String = ""   // 입력받은 Title
    var body: some View {
        Text(titlePage)
            .font(.system(size: 32))    // 글씨 크기
            .fontWeight(.bold)  // 글씨 두께
            .frame(width: 345, height: 40, alignment: .leading) // 버튼 크기 + 정렬(좌측)
            .padding(.top, 2)   // 내비게이션 백버튼과의 갭 영역
            .padding(.horizontal, 24)   // 양 옆 가드 영역
    }
}

struct PageTitle_Previews: PreviewProvider {
    static var previews: some View {
        PageTitle()
    }
}
