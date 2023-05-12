//
//  ContentView.swift
//  MC2-LESSERAFIM 2
//
//  Created by Kim Andrew on 2023/05/03.
//

import SwiftUI
import Photos
import UserNotifications

struct Notification {
    var id: String
    var title: String
}

class LocalNotificationManager {
    var notifications = [Notification]()
    
    func addNotification(title: String) -> Void {
        notifications.append(Notification(id : UUID().uuidString, title: title))
    }
}

class PermissionManager : ObservableObject {
    @Published var permissionGranted = false
    
    func requestAlbumPermission() {
        PHPhotoLibrary.requestAuthorization(for: .readWrite, handler: { status in
            switch status{
            case .authorized:
                print("Album: 권한 허용")
            case .denied:
                print("Album: 권한 거부")
            case .restricted, .notDetermined:
                print("Album: 선택하지 않음")
            default:
                break
            }
        })
    }
    
    func requestAlramPermission() {
        UNUserNotificationCenter
            .current()
            .requestAuthorization(options: [.alert, .badge, .sound]) { status, error in
                if status == true && error == nil {
                    print("Alram: 권한 허용")
                }
                else{
                    print("Alram: 권한 거부")
                }
            }
    }
}

struct Post : Identifiable {
    var id = UUID()
    var type: String
    var image: Image
    var title: String
    var content: String
}

struct ContentView: View {
    @StateObject var permissionManager = PermissionManager()
    @ObservedObject var userData = UserData()
    
    @State var tag = 0
    
    @State var opacities: [CGFloat] = [1.0, 1.0, 1.0, 1.0, 1.0, 1.0]
    
    
    var body: some View {
        if userData.isOnBoarding {
            OnBoardingScreen()
                .environmentObject(userData)
        }
        else{
            GeometryReader { geo in
                TabView(selection: $userData.selectedTab){
                    RecordCollectionView(width:geo.size.width, height:geo.size.height, opacities: $opacities)
                        .tag(0)
                        .tabItem {
                            Image(systemName: "star")
                            Text("기록모음")
                        }
                        .environmentObject(userData)
                    
                    ChallengeScreen(width:geo.size.width, height:geo.size.height, opacities: $opacities)
                        .tag(1)
                        .tabItem {
                            Image(systemName: "star")
                            Text("챌린지")
                        }
                        .environmentObject(userData)
                    
                    ProfileScreen(width:geo.size.width, height:geo.size.height, opacities: $opacities)
                        .tag(2)
                        .tabItem {
                            Image(systemName: "star")
                            Text("프로필")
                        }
                        .environmentObject(userData)
                }
                .onAppear {
                    permissionManager.requestAlbumPermission()
                    permissionManager.requestAlramPermission()
                    
                }
                .onReceive(userData.$selectedTab, perform: { newTag in
                    let appearance = UITabBarAppearance()
                    
                    if (newTag == 1){
                        print("trasparent")
                        appearance.configureWithTransparentBackground()
                        appearance.backgroundEffect = UIBlurEffect(style: .regular)
                        appearance.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
                    }
                    else{
                        print("default")
                        appearance.configureWithOpaqueBackground()
                        appearance.backgroundEffect = nil
                        appearance.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)
                    }
                    appearance.stackedLayoutAppearance.normal.iconColor = .systemGray2
                    appearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemGray2]
                    
                    appearance.stackedLayoutAppearance.selected.iconColor = UIColor(Color.accentColor)
                    appearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(Color.accentColor)]
                    
                    UITabBar.appearance().standardAppearance = appearance
                    UITabBar.appearance().scrollEdgeAppearance = appearance
                })
            }
        }
    }
       
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
