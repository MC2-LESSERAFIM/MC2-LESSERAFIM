//
//  ProfileScreen.swift
//  MC2-LESSERAFIM
//
//  Created by 손서연 on 2023/05/07.
//

import SwiftUI
import LocalAuthentication

struct ProfileScreen: View {
    
    @EnvironmentObject var postData: UserData
    @EnvironmentObject var appLock : BiometricLock
    
    @State private var isNotificationEnabled: Bool = true
    @State private var isLockEnabled: Bool = true
    
    var width: CGFloat
    var height: CGFloat
    @Binding var opacities: [CGFloat]
    
    var body: some View {
        ZStack{
            
            background2View(width: width, height: height, opacities: $opacities)
                .ignoresSafeArea()
                .frame(width: width, height: height)
                .border(.red)
                
            VStack(spacing: 0) {
                Rectangle()
                    .frame(width: 140, height: 140)
                    .cornerRadius(70)
                
                Text("김지민")
                    .font(.system(size: 32, weight: .bold))
                    .padding(.top, 8)
                
                Text("아직 기록되지 않았어요.")
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(.gray)
                    .frame(width: 140, height: 28)
                    .background(.thinMaterial)
                    .cornerRadius(5)
                    .padding(.top, 4)
                
                HStack(alignment: .center) {
                    Image(systemName: isNotificationEnabled ? "bell" : "bell.slash")
                        .font(.system(size: 20))
                        .foregroundColor(.black)
                        .frame(width: 30, height: 30)
                        .background(.ultraThinMaterial)
                        .cornerRadius(15)
                        .padding(.trailing, 24)
                        .onTapGesture {
                            isNotificationEnabled.toggle()
                        }
                    
                    Image(systemName: isLockEnabled ? "lock" : "lock.slash")
                        .font(.system(size: 20))
                        .foregroundColor(.black)
                        .frame(width: 30, height: 30)
                        .background(.ultraThinMaterial)
                        .cornerRadius(15)
                        .onTapGesture {
                            isLockEnabled.toggle()
                            if isLockEnabled {
                                appLock.isAppLockEnabled = true
                            }else {
                                appLock.isAppLockEnabled = false
                            }
                        }
                    
                }
                .padding(.top, 12)
                
                Spacer()
                
            }
            .padding(.top, 48)
        }
    }
}
