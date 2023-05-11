//
//  SelectedUserCharacterScreen.swift
//  MC2-LESSERAFIM
//
//  Created by 손서연 on 2023/05/11.
//

import SwiftUI

struct SelectedUserCharacterScreen: View {
    @EnvironmentObject var userData: UserData
    @State private var isLinkActive = false
    @State var username = ""
    @State var tappedImageName: String = ""
    @State var selectedOption: String = ""
    @State var isNextButtonEnabled: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            Text("당신의 캐릭터를 골라볼까요?")
                .font(.system(size: 32, weight: .bold))
                .multilineTextAlignment(.leading)
            
            SmallOnBoarding(tappedImageName: $tappedImageName)
                .onChange(of: selectedOption) { _ in
                    isNextButtonEnabled = true
                }
            
            Spacer()
            
            if tappedImageName.isEmpty != true {
                NavigationLink(
                    destination:
                        CheckInComplete(tappedImageName: tappedImageName, username: $username)
                        .environmentObject(userData),
                    isActive: $isNextButtonEnabled,
                    label: {
                        Text("다음")
                            .bold()
                            .padding(16)
                            .frame(maxWidth: .infinity)
                            .background(Color.pink)
                            .cornerRadius(12)
                            .foregroundColor(.white)
                    }
                )
            } else {
                Text("다음")
                    .bold()
                    .padding(16)
                    .frame(maxWidth: .infinity)
                    .background(Color.gray)
                    .cornerRadius(12)
                    .foregroundColor(.white)
            }
        }
        
        Spacer()
            .padding(24)
            .padding(.top, 48)
    }
}

//struct SelectedUserCharacterScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        SelectedUserCharacterScreen()
//    }
//}
