//
//  NotYetChallengeScreen.swift
//  MC2-LESSERAFIM
//
//  Created by 손서연 on 2023/05/16.
//

import SwiftUI

struct NotYetChallengeScreen: View {
    @AppStorage("userName") var userName: String = ""
    @AppStorage("postChallenge") var postChallenge: Bool = UserDefaults.standard.bool(forKey: "postChallenge")
    
    @State private var navigationIsActive: Bool = false
    
    var body: some View {
        ZStack{
            BackgroundView()
            VStack(alignment: .leading, spacing: 0){
                PageTitle(titlePage: "앗차! 챌린지를 시도한 뒤에\n다시 찾아와주세요")
                
                Text("성공하지 못해도 괜찮아요, \(userName).\n도전한 것만으로도 충분하니까요!")
                    .font(.system(size: 17))
                    .lineSpacing(4)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.subText)
                    .padding(.top, 12)
                
                Spacer()
                
                Button {
                    postChallenge = false
                } label: {
                    Text("다시 도전해볼게요!")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(NextButtonStyle(isAbled: true))
            }
            .padding(.horizontal, 24)
            .padding(.top, 100)
            .padding(.bottom, 100)
            .ignoresSafeArea()
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .ignoresSafeArea()
    }
}

struct NotYetChallengeScreen_Previews: PreviewProvider {
    static var previews: some View {
        NotYetChallengeScreen()
    }
}
