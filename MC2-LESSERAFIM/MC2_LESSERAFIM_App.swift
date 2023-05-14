//
//  MC2_LESSERAFIM_2App.swift
//  MC2-LESSERAFIM 2
//
//  Created by Kim Andrew on 2023/05/03.
//

import SwiftUI
import CoreData


struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "Model")
        
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Container load failed: \(error)")
            }
        }
    }
    
    func saveContext() {
      let context = container.viewContext
      if context.hasChanges {
        do {
          try context.save()
        } catch {
          let nserror = error as NSError
          fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
      }
    }
    
}


struct Offset {
    var x: CGFloat
    var y: CGFloat
}

@main
struct MC2_LESSERAFIM_2App: App {
    let persistenceController = PersistenceController.shared
    
    @FetchRequest(sortDescriptors: [])
    private var challenges: FetchedResults<Challenge>
    
    func addChallenges(category: String, difficulty: Int16, isSuccess: Bool = false, question: String){
        let challenge = Challenge(context: persistenceController.container.viewContext)
        challenge.category = category
        challenge.difficulty = difficulty
        challenge.isSuccess = isSuccess
        challenge.question = question
        saveContext()
    }
    
    func deleteChallenge(at offsets: IndexSet) {
      offsets.forEach { index in
        let challenge = self.challenges[index]
          persistenceController.container.viewContext.delete(challenge)
      }
      saveContext()
    }
    
    func readData() -> [Challenge] {
            var challenges: [Challenge] = []
            
            do {
                challenges = try persistenceController.container.viewContext.fetch(Challenge.fetchRequest())
            } catch {
                print("CoreDataDAO ReadData Method \(error.localizedDescription)")
            }
            return challenges
        }
    
    func deleteAllData() {
        let challenges = readData()
        
        if challenges.count > 0 {
            for object in challenges {
                persistenceController.container.viewContext.delete(object)
            }
            saveContext()
        }
    }
    
    func saveContext() {
      do {
          try persistenceController.container.viewContext.save()
      } catch {
        print("Error saving managed object context: \(error)")
      }
    }
    
    init() {
        //챌린지 임시 추가
        let challenges = readData()
        if (challenges.count == 0) {
            addChallenges(category: "Favorites", difficulty: Int16(1), question: "당신이 가장 좋아하는 별명은 무엇인가요?")
            addChallenges(category: "Dislikes", difficulty: Int16(1), question: "올해 가장 화났던 일화 들려주기")
            addChallenges(category: "Strengths", difficulty: Int16(1), question: "내가 가진 습관 중 가장 멋진 습관 자랑하기")
            addChallenges(category: "Weaknesses", difficulty: Int16(2), question: "고치고 싶은 나쁜 습관이 무엇인가요?")
            addChallenges(category: "ComfortZone", difficulty: Int16(1), question: "내 이름 세 번 부르기")
            addChallenges(category: "Values", difficulty: Int16(3), question: "힘든 시간을 보내는 사람을 보면 어떤 감정이 드나요?")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext,
                             persistenceController.container.viewContext)
        }
    }
}

extension Array: RawRepresentable where Element: Codable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode([Element].self, from: data)
        else {
            return nil
        }
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}
