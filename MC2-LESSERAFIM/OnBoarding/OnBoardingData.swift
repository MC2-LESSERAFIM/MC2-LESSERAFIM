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
        OnBoardingData(id: 0, objectImage: "onboarding1", primaryText: "스스로 나만의 짝꿍이 되어주세요", secondaryText: "하루 3개, 100일간 매일 새롭게 제공되는 챌린지를 통해 나 자신과 더욱 돈독한 관계를 만들어갈 수 있습니다."),
        OnBoardingData(id: 1, objectImage: "onboarding2", primaryText: "변화하는 내 모습을 기록하세요", secondaryText: "나와의 추억을 쌓으며 떠오른 다양한 생각과 감정을 자유롭게 기록하며 나에 대해 한층 더 깊이 알아갈 수 있습니다."),
        OnBoardingData(id: 2, objectImage: "onboarding3", primaryText: "뚜렷한 나만의 색깔을 찾아가세요", secondaryText: "챌린지를 통해 이전에는 몰랐던 다양한 나의 성향을 알아갈수록 다채로운 색을 더해가는 앱 화면을 감상할 수 있습니다.")
    ]
}
