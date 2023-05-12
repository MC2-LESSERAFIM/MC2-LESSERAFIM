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
    @State var tappedImageName: String
    @Binding var username: String
    
    private let challengeNumber: Int = 3
    
    
    var width: CGFloat
    var height: CGFloat
    //@State var opacities: [CGFloat] = [1.0, 1.0, 1.0, 1.0, 1.0, 1.0]
    //@State var opacities: [CGFloat] = [0.3, 0.2, 0.1, 0.2, 1.0, 1.0]
    var body: some View {
        GeometryReader { geo in
            NavigationView {
                ZStack{
                    
                    background2View(width: width, height: height)
                        .ignoresSafeArea()
                        .frame(width: width, height: height)
                        .border(.red)
                        .environmentObject(userData)
                    VStack {
                        VStack {
                            PageTitle(titlePage: "Day1")
                        }
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
                                .padding(.top, 47)
                                
                                List {
                                    ForEach(0..<3) { i in
                                        NavigationLink {
                                            RecordView(challenge: userData.todayChallenges[i])
                                        } label: {
                                            Text(userData.todayChallenges[i])
                                                .swipeActions(edge: .leading) {
                                                    Button {
                                                        if numberOfTimeLeft > 0 {
                                                            modifyChallenge(index: i)
                                                            self.numberOfTimeLeft -= 1
                                                        } else {
                                                            self.showingAlert = true
                                                        }
                                                    } label: {
                                                        Label("다시 뽑기", systemImage: "arrow.counterclockwise")
                                                    }
                                                    .tint(.purple)
                                                }
                                        }
                                    }
                                }
                                .listStyle(.inset)
                                .padding(.top, 12)
                            }
                        }   else {
                            // 뽑기 버튼
                            Button {
                                self.isPickedChallenge = !self.isPickedChallenge // true 대신에 !self.isPickedChallenge로 사용 가능함.
                                print("뽑기")
                            } label: {
                                Text("오늘의 챌린지 뽑기")
                                    .foregroundColor(.white)
                            }
                            .frame(width: UIScreen.main.bounds.width - 48, height: 50)
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
                        }
                            .toolbar(.hidden, for: .navigationBar)
                            .toolbar(.visible, for: .tabBar)
                    }
                }
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
