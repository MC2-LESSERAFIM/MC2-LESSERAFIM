//
//  CustomTextField.swift
//  MC2-LESSERAFIM
//
//  Created by 손서연 on 2023/05/13.
//

import SwiftUI

struct UserNameTextField: View {
    @Binding var username: String
    var placeholder: String
    
    var body: some View {
        ZStack {
            TextField("", text: $username,  axis: .vertical)
                .placeholder(when: username.isEmpty, placeholder: {
                    Text("\(placeholder)")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(.mainGray)
                })
                .frame(height: 48)
                .padding(.horizontal, 12)
                .foregroundColor(.mainBlack)
                .font(.system(size: 15, weight: .regular))
                .accentColor(.mainPink)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
        }
        .padding(.horizontal, 6)
        .background(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.white, lineWidth: 1)
                .background(Color.opacityWhite)
        )
        .cornerRadius(5)
    }
}
