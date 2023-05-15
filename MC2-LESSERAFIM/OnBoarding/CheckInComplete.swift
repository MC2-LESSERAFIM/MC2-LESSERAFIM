//
//  CheckInComplete.swift
//  MC2-LESSERAFIM
//
//  Created by 손서연 on 2023/05/11.
//

import SwiftUI

struct CheckInComplete: View {
    @State var tappedImageName: String
    @AppStorage("isOnBoarding") var isOnBoarding: Bool!
    @AppStorage("userName") var userName: String!
    
    var body: some View {
        ZStack{
            BackgroundView()
            VStack(spacing: 0){
                PageTitle(titlePage: "이제부터 당신의 짝꿍은")
                HStack {
                    Text(userName)
                        .foregroundColor(.mainPink)
                        .font(.system(size: 32, weight: .bold))
                    PageTitle(titlePage: "입니다.")
                    Spacer()
                }
                
                Image(tappedImageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 470)
                    .padding(.top, 48)
                
                Spacer()
                
                Button("시작하기", action: {
                    isOnBoarding = false
                })
                .font(.system(size: 17, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 345, height: 50)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(.mainPink)
                )
                .padding(.vertical, 28)
//                            .padding(.)
            }
            .padding(.horizontal, 24)
//            .padding(.top, 100)
//            .padding(.bottom, 66)
//            .ignoresSafeArea()
        }
    }
}
struct CheckInComplete_Previews: PreviewProvider {
    static var previews: some View {
        CheckInScreen()
    }
}
