//
//  ProfileScreen.swift
//  MC2-LESSERAFIM
//
//  Created by 손서연 on 2023/05/07.
//

import SwiftUI
import LocalAuthentication

struct ProfileScreen: View {
    @EnvironmentObject var appLock : BiometricLock
    
    @State var showImageModal: Bool = false
    @State var showNameModal: Bool = false
    
    @AppStorage("isLockEnabled") var isLockEnabled: Bool = false
    @AppStorage("isNotificationEnabled") var isNotificationEnabled: Bool = false
    @AppStorage("userName") var userName: String!
    @AppStorage("selectedImageName") var selectedImageName: String!
    
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
                                            showNameModal = true
                                        }
                                        .sheet(isPresented: $showNameModal) {
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

