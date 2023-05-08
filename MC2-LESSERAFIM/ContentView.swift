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
    @State var isOnBoarding: Bool = true
    
    var body: some View {
        if isOnBoarding {
            OnBoardingScreen(isOnBoarding: $isOnBoarding)
        }
        else{
            TabView(){
                RecordCollectionView()
                    .tabItem {
                        Image(systemName: "star")
                        Text("기록모음")
                    }
                    .environmentObject(userData)
                
                ChallengeScreen()
                    .tabItem {
                        Image(systemName: "star")
                        Text("챌린지")
                    }
                    .environmentObject(userData)
                
                ProfileScreen()
                    .tabItem {
                        Image(systemName: "star")
                        Text("프로필")
                    }
                    .environmentObject(userData)
            } .onAppear {
                permissionManager.requestAlbumPermission()
                permissionManager.requestAlramPermission()
            }
        }
    }
       
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

