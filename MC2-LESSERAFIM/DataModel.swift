//
//  DataModel.swift
//  MC2-LESSERAFIM
//
//  Created by 손서연 on 2023/05/08.
//

import Foundation

class UserData: ObservableObject {
    @Published var challenges = [
    "랜덤 챌린지1",
    "랜덤 챌린지2",
    "랜덤 챌린지3",
    "랜덤 챌린지4",
    "랜덤 챌린지5",
    "랜덤 챌린지6",
    "랜덤 챌린지7",
    "랜덤 챌린지8",
    "랜덤 챌린지9",
    "랜덤 챌린지10"
    ]
    @Published var todayRemovedChallenges: [Int] = []
    @Published var todayChallenges: [String] = []
}

