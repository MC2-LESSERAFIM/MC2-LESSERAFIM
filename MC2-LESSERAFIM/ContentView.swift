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
    var body: some View {
        if isOnBoarding {
            OnBoardingScreen()
        } else {
            TabView {
                RecordCollectionView()
                    .tabItem {
                        Image(systemName: "star")
                        Text("기록모음")
                    }
                    .environment(\.managedObjectContext, viewContext)
                ChallengeScreen()
                    .tabItem {
                        Image(systemName: "star")
                        Text("챌린지")
                    }
                    .environment(\.managedObjectContext, viewContext)
                
                ProfileScreen()
                    .tabItem {
                        Image(systemName: "star")
                        Text("프로필")
                    }
                    .environmentObject(appLock)
            } .onAppear {
                makeTabBarTransparent()
                permissionManager.requestAlbumPermission()
                permissionManager.requestAlramPermission()
            }
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

