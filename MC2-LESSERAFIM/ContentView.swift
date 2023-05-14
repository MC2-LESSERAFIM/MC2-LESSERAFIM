//
//  ContentView.swift
//  MC2-LESSERAFIM 2
//
//  Created by Kim Andrew on 2023/05/03.
//

import SwiftUI

struct PostModel : Identifiable, Codable {
    var id = UUID()
    var type: String
    var title: String
    var content: String
    var category: Category
    var image: Image {
        Image.fromData(imageData ?? Data()) ?? Image(systemName: "x.circle")
    }
    private var imageData: Data?
    
    // MARK: - init 1
    init(type: String, imageData: Data?, title: String, content: String, category: Category) {
        self.type = type
        self.imageData = imageData
        self.title = title
        self.content = content
        self.category = category
    }
    
    // MARK: - init 2, Decode
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(UUID.self, forKey: .id)
        type = try container.decode(String.self, forKey: .type)
        title = try container.decode(String.self, forKey: .title)
        content = try container.decode(String.self, forKey: .content)
        category = try container.decode(Category.self, forKey: .category)

        imageData = try container.decode(Data.self, forKey: .imageData)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
        try container.encode(imageData, forKey: .imageData)
        try container.encode(title, forKey: .title)
        try container.encode(content, forKey: .content)
        try container.encode(category, forKey: .category)
    }
    
    enum CodingKeys : String, CodingKey {
        case id
        case type, content, title
        case imageData
        case category
    }
}

struct ContentView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @StateObject var permissionManager = PermissionManager()
    @ObservedObject var appLock  = BiometricLock()
    @AppStorage("isOnBoarding") var isOnBoarding: Bool = true
    @AppStorage("userName") var userName: String = ""
/*
    @AppStorage("charaterData") var charaterData: Data = Data()
    @AppStorage("selectedImageName") var selectedImageName: String = ""
    @AppStorage("isLockEnabled") var lockSetting: Bool = false
    @AppStorage("isNotificationEnabled") var AlarmSetting: Bool = false
    @AppStorage("todayChallenges") var todayChallenges: [Int] = []
    @AppStorage("todayRemovedChallenges") var todayRemovedChallenges: [Int] = []
    @AppStorage("opacities") var opacities: [Double] = []
    */
    @State var isSeletedTab: Int = 1
    @FetchRequest(sortDescriptors: [])
    private var challenges: FetchedResults<Challenge>
    
    
    var body: some View {
        if isOnBoarding {
            OnBoardingScreen()
                .onAppear{
                    loadData()
                }
        } else {
            TabView(selection: $isSeletedTab) {
                RecordCollectionView()
                    .tabItem {
                        Image(systemName: "star")
                        Text("기록모음")
                    }
                    .environment(\.managedObjectContext, viewContext)
                    .tag(0)
                ChallengeScreen()
                    .tabItem {
                        Image(systemName: "star")
                        Text("챌린지")
                    }
                    .environment(\.managedObjectContext, viewContext)
                    .tag(1)
                ProfileScreen()
                    .tabItem {
                        Image(systemName: "star")
                        Text("프로필")
                    }
                    .environmentObject(appLock)
                    .tag(2)
            } .onAppear {
                makeTabBarTransparent()
                permissionManager.requestAlbumPermission()
                permissionManager.requestAlramPermission()
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
            addChallenges(category: "Favorites", difficulty: Int16(1), question: "당신이 가장 좋아하는 별명은 무엇인가요?")
            addChallenges(category: "Dislikes", difficulty: Int16(1), question: "올해 가장 화났던 일화 들려주기")
            addChallenges(category: "Strengths", difficulty: Int16(1), question: "내가 가진 습관 중 가장 멋진 습관 자랑하기")
            addChallenges(category: "Weaknesses", difficulty: Int16(2), question: "고치고 싶은 나쁜 습관이 무엇인가요?")
            addChallenges(category: "ComfortZone", difficulty: Int16(1), question: "내 이름 세 번 부르기")
            addChallenges(category: "Values", difficulty: Int16(3), question: "힘든 시간을 보내는 사람을 보면 어떤 감정이 드나요?")
            print("CoreData : \(challenges.count) challenges added")
        }
        else {
            print("CoreData : Already \(challenges.count) challenges in CoreData")
        }
    }
    
}


func makeTabBarTransparent() -> Void {
    let appearance = UITabBarAppearance()
    
    appearance.configureWithTransparentBackground()
    appearance.backgroundEffect = UIBlurEffect(style: .regular)
    
    UITabBar.appearance().standardAppearance = appearance
    UITabBar.appearance().scrollEdgeAppearance = appearance
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

