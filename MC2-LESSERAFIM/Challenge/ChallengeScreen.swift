//
//  ChallengeScreen.swift
//  MC2-LESSERAFIM
//
//  Created by 손서연 on 2023/05/07.
//

import SwiftUI

struct ChallengeScreen: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [])
    private var posts: FetchedResults<Post>
    
    @FetchRequest(sortDescriptors: [])
    private var challenges: FetchedResults<Challenge>
    
    // tables swipe action
    @State private var action = ""
    // user picked challenge
    @State private var isPickedChallenge: Bool = false
    @State private var numberOfTimeLeft: Int = 3
    @State private var showingAlert: Bool = false
    @State var nextView = false
    @AppStorage("selectedImageName") var selectedImageName: String = ""
    @AppStorage("userName") var userName: String = ""
    @AppStorage("todayChallenges") var todayChallenges: [Int] = []
    @AppStorage("todayRemovedChallenges") var todayRemovedChallenges: [Int] = []
    
    private let challengeNumber: Int = 3
    
    @AppStorage("dailyFirstUse") var dailyFirstUse: Bool = false    // 오늘 앱 처음 사용 여부 == 첫 기록 확인용
    
    var body: some View {
        NavigationView {
            ZStack {
                backgroundView()
                VStack {
                    VStack {
                        PageTitle(titlePage: "Day1")
                    }
                    .padding(.top, 48)
                    
                    VStack {
                        VStack {
                            Image(selectedImageName)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 320)
                            
                            Text(userName)
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
                            .padding(.horizontal, 24)
                            
                            List {
                                ForEach(0..<3) { i in
                                    NavigationLink {
                                        RecordView(challenge: challenges[todayChallenges[i]])
                                            .environment(\.managedObjectContext, viewContext)
                                    } label: {
                                        Text(challenges[todayChallenges[i]].question!)
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
                                                .tint(.mainPink)
                                            }
                                        
                                    }
                                }
                                .listStyle(.inset)
                                .padding(.top, 12)
                            }
                        }
                    } else {
                        // 뽑기 버튼
                        Button {
                            isPickedChallenge.toggle()
                            
                            dailyFirstUse = true  // 당일 챌린지 도전 0인 상태로 변경
                        } label: {
                            Text("오늘의 챌린지 뽑기")
                                .foregroundColor(.white)
                                .font(.system(.headline))
                        }
                        .frame(width: UIScreen.main.bounds.width - 48, height: 120)
                        .background(Color.mainPink)
                        .cornerRadius(12)
                    }
                }
                .onAppear(perform: {
                    // DateFormatter 사용한 '오늘의 챌린지 뽑기'로 리프레시
                    let today = NSDate().formatted  // 오늘 날짜
                    let lastLaunchDate = UserDefaults.standard.string(forKey: Constants.FIRSTLAUNCH)    // 최근 사용 기록 날짜
                    if lastLaunchDate != today   // 오늘 앱 첫 실행
                    {
                        UserDefaults.standard.setValue(today, forKey:Constants.FIRSTLAUNCH)
                        isPickedChallenge = false   // '오늘의 챌린지' 아직 뽑지 않은 상태로 변경
                    }
                    
                    if todayChallenges.isEmpty {
                        initChallenges(number: challengeNumber)
                    }
                })
                .alert("오늘 다시 뽑기 도전 횟수가 부족해요.\n내일 다시 도전해주세요.", isPresented: $showingAlert) {
                    Button("알겠어요", role: .cancel){
                        self.showingAlert = false
                    }
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .toolbar(.visible, for: .tabBar)
    }
}

struct ChallengeScreen_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geo in
            ChallengeScreen()
        }
    }
}

fileprivate extension ChallengeScreen {
    func initChallenges(number: Int) {
        
        func addChallenge() {
            var num = Int.random(in: 0 ..< challenges.count)
            while (todayRemovedChallenges.contains(num)) {
                num = Int.random(in: 0 ..< challenges.count)
            }
            todayRemovedChallenges.append(num)
            todayChallenges.append(num)
        }
        
        for _ in 0..<number {
            addChallenge()
        }
    }
    
    func modifyChallenge(index: Int) {
        var num = Int.random(in: 0 ..< challenges.count)
        while (todayRemovedChallenges.contains(num)) {
            num = Int.random(in: 0 ..< challenges.count)
        }
        todayRemovedChallenges.append(num)
        todayChallenges[index] = num
    }
}

extension NSDate {
    var formatted: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter.string(from: self as Date)
    }
}

struct Constants {
    static let FIRSTLAUNCH = "first_launch"
}
