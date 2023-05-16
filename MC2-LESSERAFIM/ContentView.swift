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
    
    @FetchRequest(sortDescriptors: [])
    private var challenges: FetchedResults<Challenge>
    
    var body: some View {
        GeometryReader { geo in
            if isOnBoarding {
                OnBoardingScreen()
                    .onAppear{
                        loadData()
                    }
            } else {
                TabView(selection: $isSelectedTab) {
                    RecordCollectionView()
                        .tabItem {
                            Image(systemName: "magazine.fill")
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
                            Image(systemName: "person.crop.circle.fill")
                            Text("프로필")
                        }
                        .environmentObject(appLock)
                        .tag(2)
                }
                .frame(height: geo.size.height)
                .onAppear {
                    makeTabBarTransparent()
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

