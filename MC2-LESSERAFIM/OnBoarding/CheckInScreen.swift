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
//    @State var fieldFocus = [false]
//    @FocusState private var focusField: Field?
    
    var body: some View {
        NavigationView{
            
            
            VStack(alignment: .leading, spacing: 0){
                
                Text("우리가 당신을 어떻게 부르면 좋을까요?")
                    .font(.system(size: 32, weight: .bold))
                    .multilineTextAlignment(.leading)
                
                
                Text("당신의 호칭을 알려주세요.\n설정 탭에서 언제든 수정할 수 있습니다.")
                    .font(.system(size: 15))
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.gray)
                    .padding(.top, 12)
                
                
                TextField("당신의 호칭을 알려주세요", text: $username)
//                    .focused($focusField, equals: .username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.top, 24)
                    .font(.system(size: 15, weight: .regular, design: .default))
                    .accentColor(.blue)
                    .onSubmit {
                        if !username.isEmpty {
                            self.isLinkActive = true
                        }
                    }
//                    .toolbar {
//                        ToolbarItem(placement: .keyboard) {
//                            Button("NEXT") {
//                                focusField = nil
//                            }
//                            .foregroundColor(.blue)
//                        }
//                    }
            
                NavigationLink(destination:
                                CheckInComplete(username: $username)
                                    .environmentObject(userData),
                               isActive: $isLinkActive) {
                                   EmptyView()
                               }
                
                
                Spacer()
            }
            .padding(24)
            .padding(.top, 48)
            
            
            
            
            
            
        }
        //        .navigationViewStyle(.stack)
    }
}


struct CheckInComplete: View {
    @EnvironmentObject var userData: UserData
    @Binding var username: String
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0){
            Text("이제부터 당신의 짝꿍은")
                .font(.system(size: 32, weight: .bold))
            + Text(username)
                .foregroundColor(.blue)
                .font(.system(size: 32, weight: .bold))
            + Text(" 입니다.")
                .font(.system(size: 32, weight: .bold))
            
            Spacer()
                .frame(height: 48)
            
            Image("Rectangle")
                .resizable()
                .frame(width: 345.0, height: 345.0)
            Spacer()
            
            Button(action: {
                withAnimation(.easeInOut(duration: 1.0), {
                    userData.isOnBoarding = false
                })
            }, label: {
                Text("시작하기")
                    .font(.custom("ButtonStyle", size: 18))
                    .foregroundColor(.white)
                    .frame(width: 345,height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundColor(.blue)
                        
                    )
                
            })
            
        }
        .padding(24)
        .padding(.top, 48)
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        CheckInScreen()
    }
}
