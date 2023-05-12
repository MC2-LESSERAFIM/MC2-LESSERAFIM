//
//  NameModalScreen.swift
//  MC2-LESSERAFIM
//
//  Created by 손서연 on 2023/05/12.
//

import SwiftUI

struct NameModalScreen: View {
    @EnvironmentObject var userData: UserData
    @State private var username = ""
    @State private var isLinkActive = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            Text("우리가 당신을 어떻게 부르면 좋을까요?")
                .font(.system(size: 32, weight: .bold))
                .multilineTextAlignment(.leading)
            
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
            Spacer()
        }
        .padding(24)
        .padding(.top, 48)
    }
}

struct NameModalScreen_Previews: PreviewProvider {
    static var previews: some View {
        NameModalScreen()
    }
}
