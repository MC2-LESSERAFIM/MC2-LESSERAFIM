//
//  InfoView.swift
//  DMPractice
//
//  Created by Niko Yejin Kim on 2023/05/07.
//

import SwiftUI
//
//extension View {
//  func hideKeyboard() {
//    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//  }
//}
//
//enum Field {
//  case username
//}

struct CheckInScreen: View {
    @AppStorage("userName") var userName: String = ""
    @State private var isLinkActive = false
    
    var body: some View {
//        NavigationView{
        ZStack{
            BackgroundView()
            VStack(alignment: .leading, spacing: 0){
                PageTitle(titlePage: "우리가 당신을 어떻게 부르면 좋을까요?")
                
                Text("당신의 호칭을 알려주세요.\n프로필에서 언제든 수정할 수 있습니다.")
                    .font(.system(size: 17))
                    .lineSpacing(4)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.subText)
                    .padding(.top, 12)
                
                UserNameTextField(username: $userName, placeholder: "호칭을 적어주세요")
                    .padding(.top, 24)
                    .onSubmit {
                        if !userName.isEmpty {
                            self.isLinkActive = true
                        }
                    }
                    .submitLabel(.done)
                
                NavigationLink(destination: SelectedUserCharacterScreen(), isActive: $isLinkActive) {
                    EmptyView()
                }
                
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.top, 100)
            .ignoresSafeArea()
            .navigationTitle("")
        }
    }
}


struct CheckInScreen_Previews: PreviewProvider {
    static var previews: some View {
        CheckInScreen()
    }
}
