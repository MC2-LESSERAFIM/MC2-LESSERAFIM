//
//  AuthSetting.swift
//  MC2-LESSERAFIM
//
//  Created by Jun on 2023/05/13.
//

import UserNotifications
import Photos

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
