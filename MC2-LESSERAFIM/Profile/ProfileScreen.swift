//
//  ProfileScreen.swift
//  MC2-LESSERAFIM
//
//  Created by 손서연 on 2023/05/07.
//

import SwiftUI
import LocalAuthentication

struct ProfileScreen: View {
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var postData: UserData
    @EnvironmentObject var appLock : BiometricLock
    
    @State private var isNotificationEnabled: Bool = true
    @State private var isLockEnabled: Bool = true
    @State var showImageModal: Bool = false
    @State var showNameModal: Bool = false
    @Binding var tappedImageName: String
    @Binding var username: String
    
    var body: some View {
        VStack(spacing: 0) {
            VStack {
                ZStack {
                    VStack{
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.pink, lineWidth: 3)
                            .frame(width: 345, height: 345)
                            .background(.clear)
                        
                    }
                    VStack{
                        Image(tappedImageName)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 320)
                    }
                    
                    VStack{
                        HStack(alignment: .bottom){
                            Spacer()
                            
                            Image(systemName: "pencil.circle")
                                .onTapGesture {
                                    showImageModal = true
                                }
                                .sheet(isPresented: $showImageModal) {
                                    ImageModalScreen(selectedImageName: $tappedImageName)
                                }
                        }.padding(.horizontal, 24)
                        Spacer()
                            .frame(height: 320)
                    }
                    
                    
                }
                
                HStack {
                    Text(username)
                        .font(.system(size: 32, weight: .bold))
                    
                    Image(systemName: "pencil.circle")
                        .onTapGesture {
                            showNameModal = true
                        }
                        .sheet(isPresented: $showNameModal) {
                            NameModalScreen(userName: $username)
                        }
                }
                .padding(.top, 12)
            }
            .padding(.top, 48)
            
            VStack {
                HStack {
                    Toggle("알림", isOn: $isNotificationEnabled)
                        .font(.system(size: 18, weight: .medium))
                        .toggleStyle(SwitchToggleStyle(tint: Color.pink))
                }
                HStack {
                    Toggle("잠금", isOn: $isLockEnabled)
                        .font(.system(size: 18, weight: .medium))
                        .toggleStyle(SwitchToggleStyle(tint: Color.pink))
                }
                .padding(.top, 24)
            }
            .padding(.horizontal, 36)
            .padding(.top, 48)
            
            
            //                HStack(alignment: .center) {
            //                        Image(systemName: isNotificationEnabled ? "bell" : "bell.slash")
            //                            .font(.system(size: 20))
            //                            .foregroundColor(.black)
            //                            .frame(width: 30, height: 30)
            //                            .background(.ultraThinMaterial)
            //                            .cornerRadius(15)
            //                            .padding(.trailing, 24)
            //                            .onTapGesture {
            //                                isNotificationEnabled.toggle()
            //                            }
            //
            //                        Image(systemName: isLockEnabled ? "lock" : "lock.slash")
            //                            .font(.system(size: 20))
            //                            .foregroundColor(.black)
            //                            .frame(width: 30, height: 30)
            //                            .background(.ultraThinMaterial)
            //                            .cornerRadius(15)
            //                            .onTapGesture {
            //                                isLockEnabled.toggle()
            //                                if isLockEnabled {
            //                                    appLock.isAppLockEnabled = true
            //                                }else {
            //                                    appLock.isAppLockEnabled = false
            //                                }
            //                            }
            //
            //                }
            //                .padding(.top, 12)
            
            Spacer()
            
        }
        .padding(.top, 48)
    }
}

