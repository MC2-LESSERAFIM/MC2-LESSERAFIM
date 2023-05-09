//
//  OnBoardingData.swift
//  MC2-LESSERAFIM
//
//  Created by Niko Yejin Kim on 2023/05/08.
//

import Foundation

struct OnBoardingData: Hashable, Identifiable {
    let id: Int
    let objectImage: String
    let primaryText: String
    let secondaryText: String

    static let list: [OnBoardingData] = [
        OnBoardingData(id: 0, objectImage: "Rectangle", primaryText: "나에게 아낌 없이 애정을 주는 나만의 연인이 되어보세요", secondaryText: "100일간 매일 새롭게 제공되는 챌린지를 통해 나와의 추억을 쌓고 사랑을 채워가는 특별한 경험들로 나를 더 잘 알아갈 수 있습니다."),
        OnBoardingData(id: 1, objectImage: "Rectangle", primaryText: "무채색으로 가려져 있던 나만의 색깔을 찾아보세요", secondaryText: "내가 원하는 것, 좋아하는 것, 사랑하는 것에 귀기울여보는 챌린지와 질문을 통해 나만의 취향과 성향을 찾아나갈 수 있습니다."),
        OnBoardingData(id: 2, objectImage: "Rectangle", primaryText: "바쁜 일상 속 나만을 위한 시간을 마련해보세요", secondaryText: "매일 반복되는 일상 속 온전히 나에게 집중하며 내 삶과 생각에 관심을 쏟는 작은 시간을 습관처럼 만들어갈 수 있습니다.")
    ]
}
