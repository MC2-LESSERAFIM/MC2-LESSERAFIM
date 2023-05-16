//
//  ChallengeCheckScreen.swift
//  MC2-LESSERAFIM
//
//  Created by 손서연 on 2023/05/16.
//

import SwiftUI

enum SelectedButtonType {
    case didChallenge
    case notYetChallenge
    case none
}

struct ChallengeCheckScreen: View {
    @AppStorage("userName") var userName: String = ""
    @AppStorage("todayChallenges") var todayChallenges: [Int] = []
    @State private var isLinkActive = false
    @State var selectButton: SelectedButtonType = .none
    @State private var navigationIsActive: Bool = false
    let currentChallenge: Challenge
    private var challengeStatement: String {
        currentChallenge.question ?? ""
    }
    
    var body: some View {
        ZStack{
            BackgroundView()
            VStack(alignment: .leading, spacing: 0){
                PageTitle(titlePage: "챌린지를 시도해봤나요?")
                
                Text("\(userName)의 챌린지는\n[챌린지 이름]이에요.") // [챌린지 이름]에 준이 데이터 받아와주세요.
                    .font(.system(size: 17))
                    .lineSpacing(4)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.gray)
                    .padding(.top, 12)
                
                HStack(spacing: 18) {
                    SelectableButton(
                        title: "네, 물론이죠!🤩", isSelected: selectButton == .didChallenge) {
                            withAnimation(.easeIn(duration: 0.2)) {
                                selectButton = .didChallenge
                            }
                        }
                    
                    SelectableButton(
                        title: "아직 못 했어요😥", isSelected: selectButton == .notYetChallenge) {
                            withAnimation(.easeIn(duration: 0.2)) {
                                selectButton = .notYetChallenge
                            }
                        }
                }
                .padding(.vertical, 36)
                
                Spacer()
                
                NavigationLink {
                    if selectButton == .didChallenge {
                        RecordSelectionView(challenge: currentChallenge)
                    } else if selectButton == .notYetChallenge {
                        NotYetChallengeScreen()
                    }
                } label: {
                    Text("다음")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(NextButtonStyle(isAbled: selectButton != .none))
                .disabled(selectButton == .none)
            }
            .padding(.horizontal, 24)
            .padding(.top, 100)
            .padding(.bottom, 100)
            .ignoresSafeArea()
        }
        .navigationTitle("")
    }
}

struct ChallengeCheckScreen_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeCheckScreen(currentChallenge: Challenge())
    }
}
