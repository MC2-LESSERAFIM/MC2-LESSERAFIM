//
//  RecordCompleteScreen.swift
//  MC2-LESSERAFIM
//
//  Created by 손서연 on 2023/05/16.
//

import SwiftUI

struct RecordCompleteScreen: View {
    @Environment(\.managedObjectContext) private var viewContext
    @AppStorage("userName") var userName: String = ""
    
    @State var backToCollection: Bool = false   // 기록 컬랙숀 이동
    @State private var navigationIsActive: Bool = false
    @AppStorage("isSelectedTab") var isSelectedTab: Int = UserDefaults.standard.integer(forKey: "isSelectedTab")
    @AppStorage("isFirstPosting") var isFirstPosting: Bool = UserDefaults.standard.bool(forKey: "isFirstPosting")
    
    var body: some View {
        ZStack {
            BackgroundView()
            NavigationLink(destination: ChallengeScreen().environment(\.managedObjectContext, viewContext), isActive: $backToCollection, label: {EmptyView()})
            VStack {
                
                VStack(alignment: .leading, spacing: 0){
                    // 화면 타이틀(PageTitle)
                    PageTitle(titlePage: "챌린지 기록을 완료했어요!")
                    
                    VStack(alignment: .leading, spacing: 19) {
                        Text("챌린지를 통해 성장한 덕분에\n\(userName)만의 새로운 색깔을 발견했어요.")
                        
                        Text("각 챌린지를 통해 내 다양한 모습을 찾아가면서\n다채로워지는 \(userName)만의 색깔을 즐겨보세요!😉")
                    }
                    .font(.system(size: 17))
                    .lineSpacing(4)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.subText)
                    .padding(.top, 12)
                }
                Spacer()
                
                Button(action: {
                    backToCollection = true
                    isFirstPosting = false
                    isSelectedTab = 0
                }, label: {Text("좋아요!")
                        .frame(maxWidth: .infinity)
                }).buttonStyle(NextButtonStyle(isAbled: true))
            }
            .padding(.horizontal, 24)
            .padding(.top, 100)
            .padding(.bottom, 100)
            .ignoresSafeArea()
        }
        .navigationTitle("")
    }
}

struct RecordCompleteScreen_Previews: PreviewProvider {
    static var previews: some View {
        RecordCompleteScreen()
    }
}
