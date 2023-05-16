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
    private var challenges: FetchedResults<Challenge>
    
    // tables swipe action
    @State private var action = ""
    // user picked challenge
    @AppStorage("numberOfTimeLeft") var numberOfTimeLeft: Int = 3
    @State private var showingAlert: Bool = false
    @State var nextView = false
    @AppStorage("selectedImageName") var selectedImageName: String!
    @AppStorage("userName") var userName: String = ""
    @AppStorage("todayChallenges") var todayChallenges: [Int] = []
    @AppStorage("todayRemovedChallenges") var todayRemovedChallenges: [Int] = []
    
    private let challengeNumber: Int = 3
    
    @AppStorage("dailyFirstUse") var dailyFirstUse: Bool = false    // 오늘 앱 처음 사용 여부 == 첫 기록 확인용
    @AppStorage("isPickedChallenge") var isPickedChallenge: Bool = false
    @AppStorage("progressDay") var progressDay: Int = 0
    @AppStorage("isDayChanging") var isDayChanging: Bool = true
    @AppStorage("todayPostsCount") var todayPostsCount = 0
    
    /* MARK: - Tutorial Prompt 로직 코드, 추후 이용 or 삭제 by Gucci
     @State var isTutorial = true
     @State var currentIndex = 0
     let xPosition: [CGFloat] = [10, 100]
     let yPosition: [CGFloat] = [100, 300]
     let prompts = ["1번 도움말", "2번 도움말"]
     */
    
    
    private var hasPassedDay: Bool {
        let today = NSDate().formatted  // 오늘 날짜
        let lastLaunchDate = UserDefaults.standard.string(forKey: Constants.FIRSTLAUNCH)    // 최근 사용 기록 날짜
        return lastLaunchDate != today
    }

    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                VStack {
                    VStack {
                        PageTitle(titlePage: "Day \(progressDay)")
                    }
                    .padding(.top, 48)
                    .padding(.horizontal, 24)
                    
                    VStack {
                        Image(selectedImageName)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 320)
                        
                        Text(userName)
                            .font(.system(size: 20, weight: .semibold))
                            .padding(.bottom, 15)
                        
                    }
                    .frame(width: UIScreen.main.bounds.width - 48, height: 346)
                    .frame(alignment: .bottom)
                    .padding(.bottom, 12)
                    
                    Spacer()
                    
                    if isPickedChallenge {
                        VStack(spacing: 0) {
                            HStack(alignment: .bottom) {
                                Text("오늘의 챌린지")
                                    .font(.system(size: 20, weight: .bold))
                                
                                Spacer()
                                
                                Text("다시 뽑기 \(numberOfTimeLeft)회")
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundColor(.gray)
                            }
                            .padding(.horizontal, 24)
                            
                            List {
                                ForEach(0..<3) { i in
                                    NavigationLink {
                                        ChallengeCheckScreen(currentChallenge: challenges[todayChallenges[i]]).environment(\.managedObjectContext, viewContext)
                                    } label: {
                                        Text(challenges[todayChallenges[i]].question!)
                                            .swipeActions(edge: .leading) {
                                                Button {
                                                    if numberOfTimeLeft > 0 {
                                                        modifyChallenge(index: i)
                                                        numberOfTimeLeft -= 1
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
                                .listRowBackground(Color.opacityWhiteChallenge)
                            }
                            .scrollContentBackground(.hidden)
                        }
                        .padding(.bottom, 66)
                        .ignoresSafeArea()
                    } else {
                        // 뽑기 버튼
                        Button {
                            isPickedChallenge = true
                            dailyFirstUse = true  // 당일 챌린지 도전 0인 상태로 변경
                        } label: {
                            Text("오늘의 챌린지 뽑기")
                                .foregroundColor(.white)
                                .font(.system(.headline))
                                .frame(width: UIScreen.main.bounds.width - 48, height: 50)
                                .background(Color.mainPink)
                                .cornerRadius(12)
                        }
                        .padding(.bottom, 120)
                    }
                }
                .onAppear {
                    passdedDayOperation()
                }
                .alert("오늘 다시 뽑기 도전 횟수가 부족해요.\n내일 다시 도전해주세요.", isPresented: $showingAlert) {
                    Button("알겠어요", role: .cancel){
                        self.showingAlert = false
                    }
                }
                .overlay {
                    
                    /* MARK: - Tutorial Prompt 로직 코드, 추후 이용 or 삭제 by Gucci
                    if isTutorial {
                        Text(prompts[currentIndex])
                            .position(x: xPosition[currentIndex], y: yPosition[currentIndex])
                            .onTapGesture {
                                currentIndex += 1
                                currentIndex = prompts.count == currentIndex ? 0 : currentIndex
                            }
                    }
                     */
                }
            }
            .navigationTitle("")
        }
        .navigationViewStyle(.stack)
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

private extension ChallengeScreen {
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
    
    /// 변하는 변수: AppStorage 변수
    /// 1. isPickedChallenge - 뽑기 버튼이 눌린지 확인하는 변수
    /// 2. dailyFirstUse - Post가 오늘 첫 포스트인지 확인하는 변수
    /// 3. isDayChanging - 오늘 날짜가 바뀌었는지 확인하는 변수, 어디서 쓰기작업이 발생하는지 모르겠음
    /// 4. progressDay - 진행일 기록 변수
    /// 5. todayPostsCount - 오늘 포스팅한 개수 확인 변수
    /// 6. todayRemovedChallenges - 다시 뽑기로 제거된 인덱스가 포함된 배열
    /// 7. todayChallenges - 현재 표시중인 챌린지의 인덱스가 포함된 배열
    //MARK: - Day가 물리적인 시간으로 지나갔는지 혹은 오늘 올린 포스트의 개수가 3개 이상이면 뷰 및 각종 변수 초기화
    func passdedDayOperation() {
        if hasPassedDay ||  todayPostsCount >= 3 {
            // 1. 오늘 날짜로 UserDefaults Update
            UserDefaults.standard.setValue(NSDate().formatted, forKey:Constants.FIRSTLAUNCH)
            // 2. 챌린지 뽑기를 초기화
            isPickedChallenge = false   // '오늘의 챌린지' 아직 뽑지 않은 상태로 변경
            // 3. 오늘 첫 사용 true
            dailyFirstUse = true
            // 4. 만약 날짜가 바뀌었다면
            if isDayChanging {
                // 5. 진행일을 추가
                progressDay += 1
                // 6. isDayChanging 초기화
                isDayChanging = false
            }
            
            todayPostsCount = 0
            numberOfTimeLeft = 3
            todayRemovedChallenges = []
            todayChallenges = []
            initChallenges(number: challengeNumber)
        }
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
