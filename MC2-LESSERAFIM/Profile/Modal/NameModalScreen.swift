//
//  NameModalScreen.swift
//  MC2-LESSERAFIM
//
//  Created by 손서연 on 2023/05/12.
//

import SwiftUI

struct NameModalScreen: View {
    @Environment(\.presentationMode) var presentation
    @EnvironmentObject var userData: UserData
    @State private var username = ""
    @State private var isLinkActive = false
    @Binding var userName: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            Text("우리가 당신을 어떻게 부르면 좋을까요?")
                .font(.system(size: 26, weight: .bold))
                .multilineTextAlignment(.leading)
            
            UserNameTextField(username: $username, placeholder: "호칭을 적어주세요")
                .padding(.top, 24)
                .onSubmit {
                    if !username.isEmpty {
                        self.isLinkActive = true
                    }
                }
            
            Spacer()
            
            Button(action: {
                userName = username
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
        }
        .padding(24)
        .padding(.top, 48)
    }
}

//struct NameModalScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        NameModalScreen()
//    }
//}
