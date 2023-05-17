//
//  ChallengeScreen.swift
//  MC2-LESSERAFIM
//
//  Created by 손서연 on 2023/05/07.
//

import SwiftUI

struct ChallengeScreen: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Challenge.question, ascending: true)])
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
    @AppStorage("postedChallenges") var postedChallenges: [Bool] = [false, false, false]
    @AppStorage("currentChallenge") var currentChallenge: Int = 0
    
    private let challengeNumber: Int = 3
    
    @AppStorage("dailyFirstUse") var dailyFirstUse: Bool = false    // 오늘 앱 처음 사용 여부 == 첫 기록 확인용
    @AppStorage("isPickedChallenge") var isPickedChallenge: Bool = false
    @AppStorage("progressDay") var progressDay: Int = 0
    @AppStorage("isDayChanging") var isDayChanging: Bool = true
    @AppStorage("isFirstPosting") var isFirstPosting: Bool!
    @AppStorage("postChallenge") var postChallenge: Bool = false
    @AppStorage("difficulty") var difficulty: Int = 0
    @AppStorage("isTutorial") var isTutorial = UserDefaults.standard.bool(forKey: "isTutorial")
    @Binding var currentTutorialIndex: Int
    
    @State var timeNowByMinute = ""
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    private var hasPassedDay: Bool {
        let today = NSDate().formatted  // 오늘 날짜
        let lastLaunchDate = UserDefaults.standard.string(forKey: Constants.FIRSTLAUNCH)    // 최근 사용 기록 날짜
        return lastLaunchDate != today
    }

    var body: some View {
        NavigationView {
            ZStack {
                if postChallenge {
                    NavigationLink(destination: ChallengeCheckScreen(currentChallenge: challenges[todayChallenges[currentChallenge]])
                                                    .environment(\.managedObjectContext, viewContext)
                                   ,
                                   isActive: $postChallenge, label: {EmptyView()})
                }
                BackgroundView()
                VStack {
                    VStack {
                        HStack {
                            PageTitle(titlePage: "Day \(progressDay)")
                            
                            Spacer()
                            
                            //MARK: - 우상단 도움 버튼
                            Button {
                                withAnimation {
                                    isTutorial = true
                                    currentTutorialIndex = 1
                                }
                            } label: {
                                Image(systemName: "questionmark.circle.fill")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(.mainGray)
                                    .opacity(0.3)
                            }
                        }

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
                                    .foregroundColor(.subText)
                            }
                            .padding(.horizontal, 24)
                            
                            List {
                                ForEach(0..<3) { i in
                                    Button {
                                        currentChallenge = i
                                        postChallenge = true
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
                                    }.buttonStyle(.plain)
                                    .disabled(postedChallenges[i])
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
                            withAnimation {
                                currentTutorialIndex = 1
                            }
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
                .alert("오늘 다시 뽑기 도전 횟수가 부족해요.\n내일 다시 도전해주세요.", isPresented: $showingAlert) {
                    Button("알겠어요", role: .cancel){
                        self.showingAlert = false
                    }
                }
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .onAppear {
                passedDayOperation()
            }
        }
        .navigationViewStyle(.stack)
        .onReceive(timer) { _ in
            passedDayOperation()
        }
    }
}

struct ChallengeScreen_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geo in
            ChallengeScreen(currentTutorialIndex: .constant(0))
        }
    }
}

private extension ChallengeScreen {
    func initChallenges(number: Int) {
        
        func addChallenge() {
            var count = challenges.count
            var num = 0 // 초기화
            repeat {
                if(count == 0) {
                    // 더이상 뽑을 퀘스쳔이 없을 때
                    num = 0
                    break
                }
                count -= 1
                num = Int.random(in: 0 ..< challenges.count)
            } while (todayRemovedChallenges.contains(num) || challenges[num].isSuccess == true || Int(challenges[num].difficulty) > difficulty)
            todayRemovedChallenges.append(num)
            todayChallenges.append(num)
        }
        
        for _ in 0..<number {
            addChallenge()
        }
    }
    
    func modifyChallenge(index: Int) {
        var count = challenges.count
        var num = 0 // 초기화
        repeat {
            if(count == 0) {
                // 더이상 뽑을 퀘스쳔이 없을 때
                num = 0
                break
            }
            count -= 1
            num = Int.random(in: 0 ..< challenges.count)
        } while (todayRemovedChallenges.contains(num) || challenges[num].isSuccess == true || Int(challenges[num].difficulty) > difficulty)
        todayRemovedChallenges.append(num)
        todayChallenges[index] = num
    }
    
    /// 변하는 변수: AppStorage 변수
    /// 1. isPickedChallenge - 뽑기 버튼이 눌린지 확인하는 변수
    /// 2. dailyFirstUse - Post가 오늘 첫 포스트인지 확인하는 변수
    /// 3. isDayChanging - 오늘 날짜가 바뀌었는지 확인하는 변수, 어디서 쓰기작업이 발생하는지 모르겠음
    /// 4. progressDay - 진행일 기록 변수
    /// 5. todayRemovedChallenges - 다시 뽑기로 제거된 인덱스가 포함된 배열
    /// 6. todayChallenges - 현재 표시중인 챌린지의 인덱스가 포함된 배열
    //MARK: - Day가 물리적인 시간으로 지나갔는지 혹은 오늘 올린 포스트의 개수가 3개 이상이면 뷰 및 각종 변수 초기화
    func passedDayOperation() {
        if hasPassedDay {
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
                changeDifficulty(day : progressDay)
                isDayChanging = false
            }
            numberOfTimeLeft = 3
            todayRemovedChallenges = []
            todayChallenges = []
            postedChallenges = [false, false, false]
            initChallenges(number: challengeNumber)
        }
    }
    
    func changeDifficulty(day: Int) {
        if day <= 10 {
            difficulty = 1
        } else if day <= 30 {
            difficulty = 2
        } else if day <= 60 {
            difficulty = 3
        } else {
            difficulty = 4
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

struct PopoverView: View {
    let prompts = [
        "나와의 관계를 돈독하게 만들어줄 \n오늘의 챌린지를 만나볼까요?\n아래의 버튼을 눌러주세요.",
        "매일 최대 3개의 챌린지를 시도할 수 있어요.\n원하는 만큼 자유롭게 도전해보세요.",
        "오늘 도전하기 어려운 도전은\n옆으로 스와이프해서 새롭게 뽑을 수 있어요.",
        "챌린지를 시도했다면 나의 새로운 모습을\n발견하면서 느낀 감정과 생각을 남겨보세요."
    ]
     
    let index: Int
    init(_ index: Int) {
        self.index = index
    }
    
    var body: some View {
        Text(prompts[index])
            .padding()
            .foregroundColor(Color.white)
            .background(Color.mainPink)
            .cornerRadius(12)
            .position(x: xPosition[index], y: yPosition[index])
    }
}
