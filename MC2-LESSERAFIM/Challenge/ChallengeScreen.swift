//
//  ChallengeScreen.swift
//  MC2-LESSERAFIM
//
//  Created by 손서연 on 2023/05/07.
//

import SwiftUI

struct ChallengeScreen: View {
    @EnvironmentObject var userData: UserData
    // tables swipe action
    @State private var action = ""
    // user picked challenge
    @State private var isPickedChallenge: Bool = false
    @State private var numberOfTimeLeft: Int = 3
    @State private var showingAlert: Bool = false
    @State var nextView = false
    @State var pageNumber = 0
    @State var tappedImageName: String
    @Binding var username: String
//    @Binding var tappedImageName: String
    
    private let challengeNumber: Int = 3
    
    var body: some View {
            VStack {
                VStack {
                    PageTitle(titlePage: "Day1")
                    //                    Text("Day1")
                    //                        .font(.system(size: 32, weight: .bold))
                }
                //                .frame(width: UIScreen.main.bounds.width - 48, alignment: .leading)
                .padding(.top, 48)
                
                VStack {
                    VStack {
                        Image(tappedImageName)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 320)
                        
                        Text(username)
                            .font(.system(size: 20, weight: .semibold))
                            .padding(.bottom, 15)
                    }
                    .padding(.top, 24)
                    .frame(width: UIScreen.main.bounds.width - 48, height: 346)
                    .frame(alignment: .bottom)
//                    .background(.cyan)
                }
                .padding(.top, 24)
                .padding(.bottom, 24)
                
                Spacer()
                
                if isPickedChallenge {
                    VStack {
                        HStack(alignment: .bottom) {
                            Text("오늘의 챌린지")
                                .font(.system(size: 24, weight: .bold))
                            
                            Spacer()
                            
                            Text("다시 뽑기 \(numberOfTimeLeft)회")
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal, 24)
                        
                        NavigationLink(destination:
                                        RecordView(challenge: userData.todayChallenges[pageNumber])
                            .environmentObject(userData),
                                       isActive: $nextView
                        ) {
                            EmptyView()
                        }
                        .navigationBarTitle("")
                        
                        List {
                            ForEach(0..<3) { i in
                                Text(userData.todayChallenges[i])
                                    .swipeActions(edge: .trailing) {
                                        Button {
                                            if numberOfTimeLeft > 0 {
                                                modifyChallenge(index: i)
                                                self.numberOfTimeLeft -= 1
                                                print("retry")
                                            } else {
                                                self.showingAlert = true
                                            }
                                        } label: {
                                            Label("다시 뽑기", systemImage: "arrow.counterclockwise")
                                        }
                                        .tint(.purple)
                                    }
                                    .swipeActions(edge: .leading) {
                                        Button {
                                            pageNumber = pageNumber
                                            nextView = true
                                        } label: {
                                            Label("기록하기", systemImage: "square.and.pencil")
                                        }
                                        .tint(.blue)
                                    }
                            }
                        }
                        .listStyle(.inset)
                        .padding(.top, 12)
                    }
                    //            .padding(.top, 24)
                } else {
                    // 뽑기 버튼
                    Button {
                        self.isPickedChallenge = !self.isPickedChallenge // true 대신에 !self.isPickedChallenge로 사용 가능함.
                        print("뽑기")
                    } label: {
                        Text("오늘의 챌린지 뽑기")
                            .foregroundColor(.white)
                            .font(.system(.headline))
                    }
                    .frame(width: UIScreen.main.bounds.width - 48, height: 120)
                    .background(.blue)
                    .cornerRadius(12)
                }
                Spacer()
            }
            .onAppear(perform: {
                if userData.todayChallenges.isEmpty {
                    initChallenges(number: challengeNumber)
                }
            })
            .alert("오늘 다시 뽑기 도전 횟수가 부족해요.\n내일 다시 도전해주세요.", isPresented: $showingAlert) {
                Button("알겠어요", role: .cancel){
                    self.showingAlert = false
                }
            }
            .toolbar(.hidden, for: .navigationBar)
    }
}

struct ChallengeScreen_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeScreen(tappedImageName: "girl1", username: .constant("베리"))
            .environmentObject(UserData())
    }
}

fileprivate extension ChallengeScreen {
    func initChallenges(number: Int) {
        
        func addChallenge() {
            var num = Int.random(in: 0 ..< userData.challenges.count)
            while (userData.todayRemovedChallenges.contains(num)) {
                num = Int.random(in: 0 ..< userData.challenges.count)
            }
            userData.todayRemovedChallenges.append(num)
            userData.todayChallenges.append(userData.challenges[num])
        }
        
        for _ in 0..<number {
            addChallenge()
        }
    }
    
    func modifyChallenge(index: Int) {
        var num = Int.random(in: 0 ..< userData.challenges.count)
        while (userData.todayRemovedChallenges.contains(num)) {
            num = Int.random(in: 0 ..< userData.challenges.count)
        }
        userData.todayRemovedChallenges.append(num)
        userData.todayChallenges[index] = userData.challenges[num]
    }
}
