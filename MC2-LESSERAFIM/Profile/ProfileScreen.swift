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
                    
                    Image(systemName: "pencil.circle")
                        .foregroundColor(Color.mainPink)
                        .onTapGesture {
                            showNameModal = true
                        }
                        .sheet(isPresented: $showNameModal) {
                            NameModalScreen()
                        }
                    
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
                                
                                Image(systemName: "pencil.circle")
                                    .foregroundColor(Color.mainPink)
                                    .onTapGesture {
                                        showImageModal = true
                                    }
                                    .sheet(isPresented: $showImageModal) {
                                        ImageModalScreen()
                                    }
                            }.padding(.horizontal, 36)
                            Spacer()
                                .frame(height: 308)
                        }
                        
                        
                    }
                    
                    HStack {
                        Image(systemName: "pencil.circle")
                            .foregroundColor(Color.clear)

                        Text(userName)
                            .font(.system(size: 26, weight: .bold))
                        
                        Image(systemName: "pencil.circle")
                            .foregroundColor(Color.mainPink)
                            .onTapGesture {
                                showNameModal = true
                            }
                            .sheet(isPresented: $showNameModal) {
                                NameModalScreen()
                            }
                    }
                    .padding(.top, 12)
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

