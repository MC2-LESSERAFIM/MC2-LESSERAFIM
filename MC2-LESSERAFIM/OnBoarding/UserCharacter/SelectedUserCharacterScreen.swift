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
    @AppStorage("selectedImageName") var selectedImageName: String = ""
    
    var body: some View {
        ZStack{
            BackgroundView()
            VStack(alignment: .leading, spacing: 0){
                Text("당신의 캐릭터를 골라볼까요?")
                    .font(.system(size: 26, weight: .bold))
                    .multilineTextAlignment(.leading)
                
                Text("스와이프하여 마음에 드는 캐릭터의 배를 콕 찌른 뒤 다음 버튼을 눌러주세요.")
                    .font(.system(size: 17))
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.subText)
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
                                .frame(width: 345, height: 50)
                                .background(Color.mainPink)
                                .cornerRadius(12)
                                .foregroundColor(.white)
                        }
                    )
                } else {
                    Text("다음")
                        .font(.system(size: 17, weight: .bold))
                        .frame(width: 345, height: 50)
                        .background(Color.disabledButtonGray)
                        .cornerRadius(12)
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 100)
            .padding(.bottom, 66)
            .ignoresSafeArea()
            .navigationTitle("")
            .onDisappear {
                selectedImageName = tappedImageName
            }
        }
    }
}
