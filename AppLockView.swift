//
//  AppLockView().swift
//  MC2-LESSERAFIM
//
//  Created by Kim Andrew on 2023/05/11.
//

import SwiftUI

struct AppLockView: View {
    
    @State var blurRadius: CGFloat = 0
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject var appLockVM: BiometricLock
        
        var body: some View {
            ZStack {
                // Show HomeView app lock is not enabled or app is in unlocked state
                if !appLockVM.isAppLockEnabled || appLockVM.isAppUnLocked {
                    ContentView()
                } else {
                    ContentView()
                                   .environmentObject(appLockVM)
                                   .blur(radius: blurRadius)
                                   .onChange(of: scenePhase, perform: { value in
                                       switch value {
                                       case .active :
                                           blurRadius = 0
                                       case .background:
                                           appLockVM.isAppUnLocked = false
                                       case .inactive:
                                           blurRadius = 5
                                       @unknown default:
                                           print("unknown")
                                       }
                                   })
                }
            }
            .onAppear {
                // if 'isAppLockEnabled' value true, then immediately do the app lock validation
                if appLockVM.isAppLockEnabled {
                    appLockVM.appLockValidation()
                }
            }
        }
}

struct AppLockViewPreviews: PreviewProvider {
    static var previews: some View {
        AppLockView()
    }
}
