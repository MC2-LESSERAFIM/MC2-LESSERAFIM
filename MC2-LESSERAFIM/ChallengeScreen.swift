//
//  ChallengeScreen.swift
//  MC2-LESSERAFIM
//
//  Created by 손서연 on 2023/05/07.
//

import SwiftUI

struct ChallengeScreen: View {
    
    // tables swipe action
    @State private var action = ""
    
    // user picked challenge
    @State private var isPickedChallenge: Bool = false
    
    // challenge
    let challenges = [
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
    var todayRandomChallenges: String {
        return challenges[Int.random(in: 0 ..< challenges.count)]
    }
    @State private var retryChallenges: String = ""

    var body: some View {
        VStack {
            VStack {
                Text("Day1")
                    .font(.system(size: 32, weight: .bold))
            }
            .frame(width: UIScreen.main.bounds.width - 48, alignment: .leading)
            .padding(.top, 47)
            
            VStack {
                VStack {
                    Rectangle()
                        .foregroundColor(.mint)
                    
                    Text("베리")
                        .font(.system(size: 20, weight: .semibold))
                        .padding(.bottom, 15)
                }
                .frame(width: UIScreen.main.bounds.width - 48, height: 346)
                .frame(alignment: .bottom)
                .background(.cyan)
            }
            
            .padding(.top, 24)
            .padding(.bottom, 48)
            
            Spacer()
            
            if isPickedChallenge {
                VStack {
                    HStack(alignment: .bottom) {
                        Text("오늘의 챌린지")
                            .font(.system(size: 24, weight: .bold))
                        
                        Spacer()
                        
                        Text("다시 뽑기 3회")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal, 24)
                    
                    List {
                        ForEach(1..<4) { i in
                            Text("\(todayRandomChallenges)")
                                .swipeActions(edge: .trailing) {
                                    Button {
                                        retryChallenges = challenges.randomElement() ?? ""
                                        print("retry")
                                    } label: {
                                        Label("다시 뽑기", systemImage: "arrow.counterclockwise")
                                    }
                                    .tint(.purple)
                                }
                                .swipeActions(edge: .leading) {
                                    Button {
                                        action = "record"
                                        print("record")
                                    } label: {
                                        Label("기록하기", systemImage: "square.and.pencil")
                                    }
                                    .tint(.blue)
                                }
                        }
                    }
                    .listStyle(.inset)
                }
                //            .padding(.top, 24)
            } else {
                // 뽑기 버튼
                Button {
                    self.isPickedChallenge = !self.isPickedChallenge // true 대신에 !self.isPickedChallenge로 사용 가능함.
                    print("뽑기")
                } label: {
                    Text("오늘의 챌린지 뽑기")
                        .foregroundColor(.white)
                }
                .frame(width: UIScreen.main.bounds.width - 48, height: 50)
                .background(.blue)
                .cornerRadius(12)
            }
            
            Spacer()
            
            Text("tab bar")
                .ignoresSafeArea()
                .frame(width: 393, height: 41)
                .background(.red)
        }
    }
}

struct ChallengeScreen_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeScreen()
    }
}
