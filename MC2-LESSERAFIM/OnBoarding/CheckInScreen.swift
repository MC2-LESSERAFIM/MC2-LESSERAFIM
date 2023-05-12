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
    @EnvironmentObject var userData: UserData
    @State private var username = ""
    @State private var isLinkActive = false
    
    var body: some View {
//        NavigationView{
            VStack(alignment: .leading, spacing: 0){
                Text("우리가 당신을 어떻게 부르면 좋을까요?")
                    .font(.system(size: 32, weight: .bold))
                    .multilineTextAlignment(.leading)
                
                Text("당신의 호칭을 알려주세요.\n프로필에서 언제든 수정할 수 있습니다.")
                    .font(.system(size: 15))
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.gray)
                    .padding(.top, 12)
                
                TextField("당신의 호칭을 알려주세요", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.top, 24)
                    .font(.system(size: 15, weight: .regular, design: .default))
                    .accentColor(.blue)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .onSubmit {
                        if !username.isEmpty {
                            self.isLinkActive = true
                        }
                    }
                
                NavigationLink(destination: SelectedUserCharacterScreen(username: username), isActive: $isLinkActive) {
                    EmptyView()
                }
                
                Spacer()
            }
            .padding(24)
            .padding(.top, 100)
            .ignoresSafeArea()
    }
}
