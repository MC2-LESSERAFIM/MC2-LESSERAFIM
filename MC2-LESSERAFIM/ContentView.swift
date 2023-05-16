//
//  ContentView.swift
//  MC2-LESSERAFIM 2
//
//  Created by Kim Andrew on 2023/05/03.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @ObservedObject var appLock  = BiometricLock()
    @AppStorage("isOnBoarding") var isOnBoarding: Bool = true
    @AppStorage("userName") var userName: String = ""
    @AppStorage("isSelectedTab") var isSelectedTab: Int = 1
    @AppStorage("isFirstPosting") var isFirstPosting: Bool = true
    
    @AppStorage("isTutorial") var isTutorial = true
    @State var currentTutorialIndex: Int

    @FetchRequest(sortDescriptors: [])
    private var challenges: FetchedResults<Challenge>
    let prompts = [
        "나와의 관계를 돈독하게 만들어줄 \n오늘의 챌린지를 만나볼까요?\n아래의 버튼을 눌러주세요.",
        "매일 최대 3개의 챌린지를 시도할 수 있어요.\n 원하는 만큼 자유롭게 도전해보세요.",
        "오늘 도전하기 어려운 도전은 \n옆으로 스와이프해서 새롭게 뽑을 수 있어요.",
        "챌린지를 시도했다면 나의 새로운 모습을 \n발견하면서 느낀 감정과 생각을 남겨보세요."
    ]
    
    let point: CGPoint
    let xPosition: [CGFloat]
    let yPosition: [CGFloat]
    
    init() {
        self._currentTutorialIndex = State(initialValue: 0)
        self.xPosition = [200, 200, 175, 210]
        self.yPosition = [450, 475, 475, 475]
        self.point = CGPoint(x: xPosition[self._currentTutorialIndex.wrappedValue], y: yPosition[self._currentTutorialIndex.wrappedValue])
    }
    
    var body: some View {
        GeometryReader { geo in
            if isOnBoarding {
                OnBoardingScreen()
                    .onAppear{
                        loadData()
                        isFirstPosting = true
                    }
            } else {
                ZStack {
                    TabView(selection: $isSelectedTab) {
                        RecordCollectionView()
                            .tabItem {
                                Image(systemName: "magazine.fill")
                                Text("기록모음")
                            }
                            .environment(\.managedObjectContext, viewContext)
                            .tag(0)
                        ChallengeScreen(currentTutorialIndex: $currentTutorialIndex)
                            .tabItem {
                                Image(systemName: "star")
                                Text("챌린지")
                            }
                            .environment(\.managedObjectContext, viewContext)
                            .tag(1)
                            .allowsHitTesting(!isTutorial)
                        
                        ProfileScreen()
                            .tabItem {
                                Image(systemName: "person.crop.circle.fill")
                                Text("프로필")
                            }
                            .environmentObject(appLock)
                            .tag(2)
                    }
                    .onAppear {
                        makeTabBarTransparent()
                    }
                    
                    if isTutorial {
                        PopoverView(prompts[currentTutorialIndex], point)
                        
                        Color.clear
                            .ignoresSafeArea()
                            .contentShape(Rectangle())
                            .onTapGesture {
                                goToNextPrompt()
                            }
                    }
                    
                }
            }
        }
    }
    
    func addChallenges(category: String, difficulty: Int16, isSuccess: Bool = false, question: String){
        let challenge = Challenge(context: viewContext)
        challenge.category = category
        challenge.difficulty = difficulty
        challenge.isSuccess = isSuccess
        challenge.question = question
        saveContext()
    }
    
    
    func saveContext() {
      do {
          try viewContext.save()
      } catch {
        print("Error saving managed object context: \(error)")
      }
    }
    
    func loadData() {
        if challenges.count == 0 {
            print("CoreData : Initialize challenges")
            getCSVData()
            print("CoreData : \(challenges.count) challenges added")
        }
        else {
            print("CoreData : Already \(challenges.count) challenges in CoreData")
        }
    }
    
    func getCSVData() {
        guard let filepath = Bundle.main.path(forResource: "Challenges", ofType: "csv") else {
            print("Error: Could not find CSV file")
            return
        }
        var data = ""
        do {
            data = try String(contentsOfFile: filepath)
        } catch {
            print(error)
            return
        }
        var rows = data.components(separatedBy: "\r\n")
        //rows.removeFirst()

        //now loop around each row, and split it into each of its columns
        for row in rows {
            let columns = row.components(separatedBy: ",")
            
            //check that we have enough columns
            if columns.count == 5 {
                let category = columns[0]
                let subdivision = columns[1]
                let keyword = columns[2]
                let question = columns[3]
                let difficulty = Int16(columns[4]) ?? 0
                addChallenges(category: category, difficulty: difficulty, question: question)
            }
        }
    }
}


func makeTabBarTransparent() -> Void {
    let appearance = UITabBarAppearance()
    
    appearance.configureWithTransparentBackground() // 배경 투명
    appearance.backgroundEffect = UIBlurEffect(style: .regular)   // 블러 효과 적용 -> tabItem 색상 변경 불가
    appearance.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0) // 탭바 배경색
    
    appearance.stackedLayoutAppearance.normal.titleTextAttributes = [   // 선택되지 않은 tabItem 색상 변경
        .foregroundColor: UIColor(red: 157/255, green: 157/255, blue: 157/255, alpha: 1)    // mainGray 색상
    ]
    
    UITabBar.appearance().standardAppearance = appearance
    UITabBar.appearance().scrollEdgeAppearance = appearance // 항상 스크롤엣지 효과를 보임
}

private extension ContentView {
    func goToNextPrompt() {
        if currentTutorialIndex == prompts.count - 1 {
            isTutorial = false
        }
        else {
            withAnimation() {
                currentTutorialIndex += 1
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

