//
//  WritingView.swift
//  MC2-LESSERAFIM
//
//  Created by OhSuhyun on 2023/05/08.
//

import SwiftUI

struct WritingView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State var titleRecord: String = ""   // 챌린지 타이틀
    @State var contentRecord: String = ""   // 챌린지 내용
    var challenge: Challenge
    @AppStorage("currentChallenge") var currentChallenge: Int = UserDefaults.standard.integer(forKey: "currentChallenge")
    @AppStorage("postedChallenges") var postedChallenges: [Bool] = [false, false, false]
    @AppStorage("postChallenge") var postChallenge: Bool = UserDefaults.standard.bool(forKey: "postChallenge")
    @AppStorage("todayPostsCount") var todayPostsCount = UserDefaults.standard.integer(forKey: "todayPostsCount")
    
    @State private var showingAlert = false // 경고 출력 여부
    
    @State var onStory = false   // 챌린지 내용 입력 중 여부
    @AppStorage("opacities") var opacities: [Double] = UserDefaults.standard.array(forKey: "opacities") as? [Double] ?? [0.2, 0.2, 0.2, 0.2, 0.2, 0.2]
    
    @FetchRequest(entity: Post.entity(), sortDescriptors: [])
    private var posts: FetchedResults<Post>
    
    @AppStorage("dailyFirstUse") var dailyFirstUse: Bool = false
    @AppStorage("progressDay") var progressDay: Int = 0
    @AppStorage("isDayChanging") var isDayChanging: Bool = false
    @AppStorage("isSelectedTab") var isSelectedTab: Int = 1
    @AppStorage("isFirstPosting") var isFirstPosting: Bool = UserDefaults.standard.bool(forKey: "isFirstPosting")
    @State var firstCompleteScreen: Bool = false
    
    var body: some View {
        
        ZStack {
            BackgroundView()
            NavigationLink(destination: RecordCompleteScreen().environment(\.managedObjectContext, viewContext), isActive: $firstCompleteScreen, label: {EmptyView()})
            GeometryReader() { geo in   // 화면 크기 이용을 위해 사용
                VStack() {
                    // 챌린지 제목
                    TitleTextField(titleRecord: $titleRecord, placeholder: "이번 챌린지에 제목을 붙여볼까요?")
                        .submitLabel(.return)
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                Button("완료") {
                                    hideKeyboard()
                                }
                            }
                        }
                    
                    // 챌린지 내용
                    OnlyWritingContentTextField(contentRecord: $contentRecord, onStory: false, placeholder: "어떤 이야기가 담겨있나요?")
                        .submitLabel(.return)
                        .frame(height: onStory ? geo.size.height - 100 : 580)   // 챌린지 내용 입력 중이면 키보드에 가리지 않게 크기 유동적으로 수정
                        .onTapGesture {
                            onStory = true
                        }
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                Button("완료") {
                                    hideKeyboard()
                                }
                            }
                        }
                    
                    // 위로 밀기
                    Spacer()
                    
                }   // VStack
                .font(.subheadline)
                .padding(.horizontal, 24)   // 양 옆 가드 영역
                // 내용 입력 누락 시 경고
                .alert("내용을 모두 작성해주세요", isPresented: $showingAlert) {
                    Button("OK", role: .cancel) {
                        self.showingAlert = false
                    }
                }
                // 제출 버튼
                .toolbar{
                    Image(systemName: "checkmark.circle")
                        .foregroundColor(.mainPink) // 기본색이 검정이어서 변경
                        .onTapGesture {
                            if titleRecord == "" {   // 제목 입력 누락
                                print("no title")
                                self.showingAlert = true
                            } else if contentRecord == "" {    // 내용 입력 누락
                                print("no story")
                                self.showingAlert = true
                            } else {    // 내용 입력 누락이 없을 경우 제출 가능
                                // 데이가 바뀐적이 없다면 데이가 바뀐다..?
                                if isDayChanging == false {
                                    isDayChanging = true
                                }
                                addPost(title: titleRecord, content: contentRecord, createdAt: Date.now, day: Int16(progressDay), isFirstPost: dailyFirstUse)
                                todayPostsCount += 1
                                postedChallenges[currentChallenge] = true
                                changeBackgroundOpacity()
                                if isFirstPosting {
                                    firstCompleteScreen = true
                                } else {
                                    isSelectedTab = 0
                                    postChallenge = false
                                }
                                updateFirstUse()
                            }
                        }
                }
            }
        }
    }   // body
    
    private func updateFirstUse() {
        if dailyFirstUse {
            self.dailyFirstUse = false
        }
    }
    
    func saveContext() {
      do {
        try viewContext.save()
      } catch {
        print("Error saving managed object context: \(error)")
      }
    }
    
    func addPost(title: String, content: String, createdAt: Date, day: Int16, isFirstPost: Bool) {
        let post = Post(context: viewContext)
        post.title = title
        post.content = content
        post.day = day
        post.isFirstPost = isFirstPost
        post.createdAt = createdAt
        post.challenge = self.challenge
        self.challenge.isSuccess = true
        saveContext()
    }

    func changeBackgroundOpacity() {
        switch(challenge.category){
        case "Favorites":
            opacities[0] = min(opacities[0] + 0.4, 1.0)
        case "Dislikes":
            opacities[1] = min(opacities[1] + 0.4, 1.0)
        case "Strengths":
            opacities[2] = min(opacities[2] + 0.4, 1.0)
        case "Weaknesses":
            opacities[3] = min(opacities[3] + 0.4, 1.0)
        case "ComfortZone":
            opacities[4] = min(opacities[4] + 0.4, 1.0)
        case "Values":
            opacities[5] = min(opacities[5] + 0.4, 1.0)
        case .none:
            break
        case .some(_):
            break
        }
    }
}

