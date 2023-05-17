//
//  ProfileScreen.swift
//  MC2-LESSERAFIM
//
//  Created by 손서연 on 2023/05/07.
//

import SwiftUI
import LocalAuthentication
import UserNotifications

struct ProfileScreen: View {
    @EnvironmentObject var appLock : BiometricLock
    
    @StateObject var permissionManager = PermissionManager()
    
    @State var showImageModal: Bool = false
    @State var showNameModal: Bool = false
    
    @State private var notificationStatus = false//알림 상태 가져오기
    
    @AppStorage("isLockEnabled") var isLockEnabled: Bool = false
    @AppStorage("isNotificationEnabled") var isNotificationEnabled: Bool = false
    @AppStorage("userName") var userName: String!
    @AppStorage("selectedImageName") var selectedImageName: String!
    
    func openAppSettings() { //알람을 끄기 위해서 알람 창을 호출
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
            
            if UIApplication.shared.canOpenURL(settingsURL) {
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            }
        }
    
    func checkNotificationSettings() {//알림이 꺼졌는지 확인합니다.
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                DispatchQueue.main.async {
                    notificationStatus = (settings.authorizationStatus == .authorized)
                }
            }
        }
    
    func scheduleNotification() { //알림 내용 설정
            let content = UNMutableNotificationContent()
            content.title = "DeMi"
            content.body = "자기야 나 잊었어?"
            content.sound = UNNotificationSound.default

//            // 특정 시간을 설정하려면 Calendar, DateComponents를 사용합니다.
//            var dateComponents = DateComponents()
//            dateComponents.hour = 18
//            dateComponents.minute = 0

            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 300, repeats: true)

            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request) { error in
                    if let error = error {
                        print("Failed to schedule notifications: \(error.localizedDescription)")
                    } else {
                        print("Notifications scheduled successfully.")
                    }
            }
        }
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack(spacing: 0) {
                HStack {
                    Text("나의 짝꿍")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(.mainBlack)
                    
                    Text(userName)
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(.mainPink)

                    HStack{
                        Image(systemName: "pencil.circle")
                            .font(.system(size: 12))
                            .frame(width: 8, height: 8)
                            .foregroundColor(Color.mainPink)
                        
                        Text("수정")
                            .font(.system(size: 12))
                            .frame(height: 12)
                            .foregroundColor(Color.mainPink)
                            .onTapGesture {
                                showNameModal = true
                            }
                            .sheet(isPresented: $showNameModal) {
                                NameModalScreen()
                            }
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.mainPink.opacity(0.2))
                    .cornerRadius(9)
                    
                    Spacer()
                }
                .padding(.horizontal, 24)
                
                VStack {
                    ZStack {
                        VStack{
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.mainPinkOpacity, lineWidth: 3)
                                .frame(width: 345, height: 345)
                                .background(Color.opacityWhiteChallenge)
                                .cornerRadius(12)
                            
                        }
                        VStack{
                            Image(selectedImageName)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 320)
                        }
                        
                        VStack{
                            HStack(alignment: .bottom){
                                Spacer()
                                
                                HStack{
                                    Image(systemName: "pencil.circle")
                                        .font(.system(size: 12))
                                        .frame(width: 8, height: 8)
                                        .foregroundColor(Color.mainPink)
                                    
                                    Text("수정")
                                        .font(.system(size: 12))
                                        .frame(height: 12)
                                        .foregroundColor(Color.mainPink)
                                        .onTapGesture {
                                            showImageModal = true
                                        }
                                        .sheet(isPresented: $showImageModal) {
                                            ImageModalScreen()
                                        }
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color.mainPink.opacity(0.2))
                                .cornerRadius(9)
                            }
                            .padding(.horizontal, 36)
                            
                            Spacer()
                                .frame(height: 290)
                        }
                    }
                }
                .padding(.top, 48)
                
                VStack {
                    HStack {
                        Toggle("알림", isOn: $isNotificationEnabled)
                            .font(.system(size: 18, weight: .medium))
                            .toggleStyle(SwitchToggleStyle(tint: Color.mainPink))
                            .onChange(of: isNotificationEnabled) {value in
                                if value{
                                    permissionManager.requestAlramPermission()
                                    scheduleNotification()
                                    print("\(isNotificationEnabled)")
                                }else {
                                    openAppSettings()
                                    checkNotificationSettings()
                                    isNotificationEnabled = !notificationStatus
                                    print("\(isNotificationEnabled)")
                                }
                            }
                            
                       
                            
                    }
                    HStack {
                        Toggle("잠금", isOn: $isLockEnabled)
                            .font(.system(size: 18, weight: .medium))
                            .toggleStyle(SwitchToggleStyle(tint: Color.mainPink))
                            .onChange(of: isLockEnabled, perform: { value in
                                appLock.appLockStateChange(appLockState: value)
                                appLock.isAppLockEnabled = value
                            })
                           
                    }
                    .padding(.top, 24)
                }
                .padding(.horizontal, 36)
                .padding(.top, 48)
                
                Spacer()
                
            }
            .padding(.top, 48)
        }
    }
}

