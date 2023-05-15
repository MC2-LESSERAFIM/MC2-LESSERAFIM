//
//  ImageModalScreen.swift
//  MC2-LESSERAFIM
//
//  Created by 손서연 on 2023/05/12.
//

import SwiftUI

struct ImageModalScreen: View {
    @Environment(\.presentationMode) var presentation
    @State private var isLinkActive = false
    @State var tappedImageName: String = ""
    @State var selectedOption: String = ""
    @State var isNextButtonEnabled: Bool = false
    @AppStorage("selectedImageName") var selectedImageName: String = ""
    @AppStorage("userName") var userName: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            Text("당신의 캐릭터를 골라볼까요?")
                .font(.system(size: 26, weight: .bold))
                .multilineTextAlignment(.leading)
            
            Text("마음에 드는 캐릭터의 배를 간지럽혀주세요.")
                .font(.system(size: 17))
                .multilineTextAlignment(.leading)
                .foregroundColor(.mainGray)
                .padding(.top, 12)
            
            Spacer()
            
            SmallOnBoarding(tappedImageName: $tappedImageName)
                .onChange(of: selectedOption) { _ in
                    isNextButtonEnabled = true
                }
                .frame(height: UIScreen.main.bounds.height / 1.7)
            
            Spacer()
            
            if tappedImageName.isEmpty != true {
                Button(action: {
                    selectedImageName = tappedImageName
                    presentation.wrappedValue.dismiss()
                }, label: {
                    Text("확인")
                        .bold()
                        .padding(16)
                        .frame(maxWidth: .infinity)
                        .background(Color.mainPink)
                        .cornerRadius(12)
                        .foregroundColor(.white)
                })
            } else {
                Text("확인")
                    .bold()
                    .padding(16)
                    .frame(maxWidth: .infinity)
                    .background(Color.disabledButtonGray)
                    .cornerRadius(12)
                    .foregroundColor(.white)
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 24)
        .padding(.bottom, 24)
//        .ignoresSafeArea()
        
//        Spacer()
//
//            .padding(.top, 48)
    }
}

//struct ImageModalScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        ImageModalScreen(, selectedImageName: <#Binding<String>#>)
//    }
//}
