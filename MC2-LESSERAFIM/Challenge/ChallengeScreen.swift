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
    @State var pageNumber = 0
    
    private let challengeNumber: Int = 3
    
    // [ocean ~] 앱 당일 처음 실행 여부 판독기
    // 참고: https://paulyoungsuklee.com/2021/11/09/how-to-detect-first-time-app-launch-in-swiftui/
    @AppStorage("dailyFirstUse") var dailyFirstUse: Bool = false    // '오늘의 챌린지 뽑기'-> true, 기록 남기기-> false
    // print(UserDefaults.standard.bool(forKey: "dailyFirstUse"))  // 사용방법
    // [~ ocean]
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    PageTitle(titlePage: "Day1")
                    //                    Text("Day1")
                    //                        .font(.system(size: 32, weight: .bold))
                }
                //                .frame(width: UIScreen.main.bounds.width - 48, alignment: .leading)
                .padding(.top, 47)
                
                VStack {
                    VStack {
                        Rectangle()
                            .foregroundColor(.mint)
                        
                        Text("베리")
                            .font(.system(size: 20, weight: .semibold))
                            .padding(.bottom, 15)
                    }
                    .padding(.top, 24)
                    .frame(width: UIScreen.main.bounds.width - 48, height: 346)
                    .frame(alignment: .bottom)
                    .background(.cyan)
                }
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
                        
                        NavigationLink(destination:
                                        RecordView(challenge: userData.todayChallenges[pageNumber])
                            .environmentObject(userData),
                                       isActive: $nextView
                        ) {
                            EmptyView()
                        }
                        .navigationBarTitle("")
                        
                        List {
                            ForEach(0..<3) { i in
                                Text(userData.todayChallenges[i])
                                    .swipeActions(edge: .trailing) {
                                        Button {
                                            if numberOfTimeLeft > 0 {
                                                modifyChallenge(index: i)
                                                self.numberOfTimeLeft -= 1
                                                print("retry")
                                            } else {
                                                self.showingAlert = true
                                            }
                                        } label: {
                                            Label("다시 뽑기", systemImage: "arrow.counterclockwise")
                                        }
                                        .tint(.purple)
                                    }
                                    .swipeActions(edge: .leading) {
                                        Button {
                                            pageNumber = pageNumber
                                            nextView = true
                                        } label: {
                                            Label("기록하기", systemImage: "square.and.pencil")
                                        }
                                        .tint(.blue)
                                    }
                            }
                        }
                        .listStyle(.inset)
                        .padding(.top, 12)
                    }
                    //            .padding(.top, 24)
                } else {
                    // 뽑기 버튼
                    Button {
                        self.isPickedChallenge = !self.isPickedChallenge // true 대신에 !self.isPickedChallenge로 사용 가능함.
                        print("뽑기")
                        
                        // [ocean ~]
                        dailyFirstUse = true  // 당일 챌린지 도전 0인 상태로 변경
                        /*
                         기록 뷰에서 기록을 저장할 때 firstCheck: Bool 값을 생성
                         firstCheck = dailyFirstUse로 그날의 처음 여부 확인
                         기록 뷰에서 체크 버튼을 누를 경우 false로 변경(토글 아님)
                         false로 변경되었기 때문에 당일 다른 기록을 남길 경우 firstCheck = false인 상태
                         (firstCheck = true)인 기록의 수 + 1 = 다음날 Day 값
                         Today's First Launch 주석 아래 부분에 Day 값 변경 부분 작성
                        */
                        // [~ ocean]
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
                // [ocean ~] DateFormatter 사용한 '오늘의 챌린지 뽑기'로 리프레시
                let today = NSDate().formatted
                if (UserDefaults.standard.string(forKey: Constants.FIRSTLAUNCH) == today)
                    {
                         //Already Launched today
                    }
                    else
                    {
                         //Today's First Launch
                        UserDefaults.standard.setValue(today, forKey:Constants.FIRSTLAUNCH)
                        isPickedChallenge = false   // '오늘의 챌린지' 아직 뽑지 않은 상태로 변경
                    }
                // [~ ocean]
                
                /* 미확인 -> let으로 선언되어 있어 제대로 된 결과 안 나올 듯
                // [ocean ~] 날짜 바뀔 경우 '오늘의 챌린지 뽑기'로 리프레시
                // isPickedChallenge를 false로 변경
                let savedDate = UserDefaults.standard.object(forKey: "lastDate") as? Date ?? Date.distantPast   // 저장된 날짜 = 이전 날짜
                let currentDate = Date()    // 현재 날짜
                let calendar = Calendar.current
                let components = calendar.dateComponents([.day], from: savedDate, to: currentDate)  // 현재 날짜와 저장된 날짜 간의 차이 = 날짜 바뀜(Bool)

                // 날짜가 바뀌었을 경우
                if let day = components.day, day >= 1 {
//                    // 오늘 챌린지와 삭제된 챌린지 초기화
//                    userData.todayChallenges.removeAll()
//                    userData.todayRemovedChallenges.removeAll()
                    isPickedChallenge = false   // '오늘의 챌린지' 아직 뽑지 않은 상태로 변경
                    UserDefaults.standard.set(currentDate, forKey: "lastDate")  // 현재 날짜로 저장된 날짜 변경 = 날짜 바뀜 없음
                }
                // [~ ocean]
                 */
                
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
    }
}

struct ChallengeScreen_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeScreen()
            .environmentObject(UserData())
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

// [ocean ~] [ocean ~] DateFormatter 사용한 '오늘의 챌린지 뽑기'로 리프레시
// 참고: https://www.appsloveworld.com/swift/100/166/how-to-detect-daily-first-launch-in-ios
extension NSDate {
    var formatted: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter.string(from: self as Date as Date)
    }
}

struct Constants {
    static let FIRSTLAUNCH = "first_launch"
}
// [~ ocean]
