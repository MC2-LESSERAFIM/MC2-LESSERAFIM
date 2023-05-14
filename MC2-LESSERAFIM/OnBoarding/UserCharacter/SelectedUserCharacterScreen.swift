//
//  SelectedUserCharacterScreen.swift
//  MC2-LESSERAFIM
//
//  Created by 손서연 on 2023/05/11.
//

import SwiftUI

struct SelectedUserCharacterScreen: View {
    @AppStorage("userName") var userName: String = ""
    @State private var isLinkActive = false
    @State var tappedImageName: String = ""
    @State var selectedOption: String = ""
    @State var isNextButtonEnabled: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            Text("당신의 캐릭터를 골라볼까요?")
                .font(.system(size: 27, weight: .bold))
                .multilineTextAlignment(.leading)
            
            Text("마음에 드는 캐릭터의 배를 간지럽혀주세요.")
                .font(.system(size: 17))
                .multilineTextAlignment(.leading)
                .foregroundColor(.gray)
                .padding(.top, 12)
            
            Spacer()
            
            SmallOnBoarding(tappedImageName: $tappedImageName)
                .onChange(of: selectedOption) { _ in
                    isNextButtonEnabled = true
                }
                .frame(height: 500)
            
            Spacer()
            
            if tappedImageName.isEmpty != true {
                NavigationLink(
                    destination:
                        CheckInComplete(tappedImageName: tappedImageName),
                    isActive: $isNextButtonEnabled,
                    label: {
                        Text("다음")
                            .font(.system(size: 17))
                            .bold()
                            .padding(16)
                            .frame(maxWidth: .infinity)
                            .background(Color.mainPink)
                            .cornerRadius(12)
                            .foregroundColor(.white)
                    }
                )
            } else {
                Text("다음")
                    .font(.system(size: 17, weight: .bold))
                    .padding(16)
                    .frame(maxWidth: .infinity)
                    .background(Color.disabledButtonGray)
                    .cornerRadius(12)
                    .foregroundColor(.white)
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 100)
        .padding(.bottom, 24)
        .ignoresSafeArea()
        .navigationTitle("")
        
//        Spacer()
//
//            .padding(.top, 48)
    }
}

//struct SelectedUserCharacterScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        SelectedUserCharacterScreen()
//    }
//}
