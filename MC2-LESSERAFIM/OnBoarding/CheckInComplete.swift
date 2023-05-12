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
        Spacer()
        VStack {
            VStack(alignment: .leading, spacing: 0){
                Text("이제부터 당신의 짝꿍은")
                    .font(.system(size: 32, weight: .bold))
                Text(username)
                    .foregroundColor(.blue)
                    .font(.system(size: 32, weight: .bold))
                + Text("입니다.")
                    .font(.system(size: 32, weight: .bold))
            }
            
            Image(tappedImageName)
                .resizable()
                .scaledToFit()
                .frame(height: 400)
                .padding(.top, 48)
            //                    .padding(.bottom, 164)
            
            NavigationLink(
                destination: ChallengeScreen(tappedImageName: tappedImageName, username: $username)
                    .environmentObject(userData),
                isActive: $isStartButtonEnabled,
                label: {
                    Button("시작하기", action: finishOnboarding)
                        .font(.custom("ButtonStyle", size: 18))
                        .foregroundColor(.white)
                        .frame(width: 345,height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .foregroundColor(.blue)
                        )
                }
            )
        }
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
