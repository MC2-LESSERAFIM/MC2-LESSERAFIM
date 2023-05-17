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
            TextField("", text: $username)
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

struct TitleTextField: View {
    @Binding var titleRecord: String   // 챌린지 타이틀
    
    var placeholder: String
    
    var body: some View {
        ZStack {
            TextField("", text: $titleRecord,  axis: .vertical)
                .placeholder(when: titleRecord.isEmpty, placeholder: {
                    Text("\(placeholder)")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(.mainGray)
                })
                .frame(height: 48)
                .lineLimit(1...)
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

struct OnlyWritingContentTextField: View {
    @Binding var contentRecord: String   // 챌린지 내용
    @State var onStory: Bool
    
    var placeholder: String
    
    var body: some View {
        GeometryReader() { geo in
            ZStack {
                TextField("", text: $contentRecord,  axis: .vertical)
                    .placeholder(when: contentRecord.isEmpty, placeholder: {
                        Text("\(placeholder)")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(.mainGray)
                    })
                    .frame(height: onStory ? geo.size.height - 100 : 580, alignment: .top)   // 챌린지 내용 입력 중이면 키보드에 가리지 않게 크기 유동적으로 수정
                    .lineLimit(1...)
                    .padding(.horizontal, 12)
                    .padding(.top, 15)
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
}

struct OtherContentTextField: View {
    @Binding var contentRecord: String   // 챌린지 내용
    
    var placeholder: String
    
    var body: some View {
        ZStack {
            TextField("", text: $contentRecord,  axis: .vertical)
                .placeholder(when: contentRecord.isEmpty, placeholder: {
                    Text("\(placeholder)")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(.mainGray)
                })
                .frame(height: 120)
                .lineLimit(1...)
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


struct cardContentTextField: View {
    let contentRecord: String   // 챌린지 내용
    
    var body: some View {
        ScrollView {
            Text(contentRecord)
                .frame(maxWidth: .infinity, alignment: .leading)
                .lineLimit(1...)
                .padding(.horizontal, 12)
                .padding(.vertical, 16)
                .foregroundColor(.mainBlack)
                .font(.system(size: 15, weight: .regular))
                .accentColor(.mainPink)
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
