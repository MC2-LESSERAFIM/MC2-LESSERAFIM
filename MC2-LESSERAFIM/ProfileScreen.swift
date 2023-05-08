//
//  ProfileScreen.swift
//  MC2-LESSERAFIM
//
//  Created by 손서연 on 2023/05/07.
//

import SwiftUI

struct ProfileScreen: View {
    
    @State private var isNotificationEnabled: Bool = true
    @State private var isLockEnabled: Bool = true
    
    var body: some View {
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
                    Button(action: {
                        if self.isNotificationEnabled {
                            // 알림 울리지 않도록
                        }
                        self.isNotificationEnabled.toggle()
                    }) {
                        Image(systemName: isNotificationEnabled ? "bell" : "bell.slash")
                            .font(.system(size: 20))
                            .foregroundColor(.black)
                            .frame(width: 30, height: 30)
                            .background(.ultraThinMaterial)
                            .cornerRadius(15)
                            .padding(.trailing, 24)
                    }
                    
                    Button(action: {
                        if self.isLockEnabled {
                            // 잠금 안 하기
                        }
                        self.isLockEnabled.toggle()
                    }) {
                        Image(systemName: isLockEnabled ? "lock" : "lock.slash")
                            .font(.system(size: 20))
                            .foregroundColor(.black)
                            .frame(width: 30, height: 30)
                            .background(.ultraThinMaterial)
                            .cornerRadius(15)
                    }
                }
                .padding(.top, 12)
                
                Spacer()
                
            }
            .padding(.top, 48)
        }
}

struct ProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProfileScreen()
    }
}
