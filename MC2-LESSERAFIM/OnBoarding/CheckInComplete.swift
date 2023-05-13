//
//  CheckInComplete.swift
//  MC2-LESSERAFIM
//
//  Created by 손서연 on 2023/05/11.
//

import SwiftUI

struct CheckInComplete: View {
    @EnvironmentObject var userData: UserData
    @State var tappedImageName: String
    @State var isStartButtonEnabled: Bool = false
    @Binding var username: String
    
    var body: some View {
        VStack(spacing: 0){
                PageTitle(titlePage: "이제부터 당신의 짝꿍은")
                HStack {
                    Text(username)
                        .foregroundColor(.mainPink)
                        .font(.system(size: 32, weight: .bold))
                    PageTitle(titlePage: "입니다.")
                    Spacer()
                }

            Spacer()
            
            Image(tappedImageName)
                .resizable()
                .scaledToFit()
                .frame(height: 500)
                .padding(.top, 48)
            
            Spacer()
            
            NavigationLink(
                destination: ChallengeScreen(tappedImageName: $tappedImageName, username: $username)
                    .environmentObject(userData),
                isActive: $isStartButtonEnabled,
                label: {
                    Button("시작하기", action: finishOnboarding)
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 345,height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .foregroundColor(.mainPink)
                        )
                }
            )
            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.top, 100)
        .ignoresSafeArea()
    }
}
struct CheckInComplete_Previews: PreviewProvider {
    static var previews: some View {
        CheckInScreen()
            .environmentObject(UserData())
    }
}

fileprivate extension CheckInComplete {
    func finishOnboarding() {
        isStartButtonEnabled = true
        userData.isOnBoarding = false
        userData.userName = username
        userData.selectedImageName = tappedImageName
    }
}
