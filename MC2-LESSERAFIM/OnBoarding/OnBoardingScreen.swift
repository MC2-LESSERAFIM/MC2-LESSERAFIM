//
//  OnBoardingScreen.swift
//  MC2-LESSERAFIM
//
//  Created by Niko Yejin Kim on 2023/05/08.
//

import SwiftUI

struct OnBoardingScreen: View {
    @EnvironmentObject var userData: UserData
    
    @State var pageTag:Int? = nil
    @State var tag:Int? = nil
    @State private var currentTab = 0
    
    var body: some View {
        NavigationView{
            VStack{
                
                HStack{
                    
                    Spacer()
                    
                    if currentTab < OnBoardingData.list.count - 1 {
                        Button(action: {
                            self.currentTab = OnBoardingData.list.count - 1
                        }, label: {
                            Text("SKIP")
                                .padding(.trailing, 30)
                                .foregroundColor(.gray)
                                .font(.system(size:15))
                            
                        })
                    }
                    else {
                        Button(action: {
                            self.currentTab = OnBoardingData.list.count - 1
                        }, label: {
                            Text("SKIP")
                                .padding(.trailing, 30)
                                .foregroundColor(.clear)
                                .font(.system(size:15))
                            
                        })
                    }
                }
                
                
                TabView(selection: $currentTab,
                        content:  {
                    ForEach(OnBoardingData.list) { viewData in
                        OnboardingTabView(data: viewData)
                            .tag(viewData.id)
                    }
                })
                //            .tabViewStyle(PageTabViewStyle())
                //            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                HStack {
                    ForEach(0..<OnBoardingData.list.count) { viewData in
                        if viewData == currentTab {
                            Rectangle()
                                .frame(width: 10, height: 10)
                                .cornerRadius(10)
                                .foregroundColor(.blue)
                        } else {
                            Circle()
                                .frame(width: 10, height: 10)
                                .opacity(0.3)
                        }
                    }
                }
                .padding(.bottom, 24)
                
                if currentTab < OnBoardingData.list.count - 1 {
                    Button(action: {
                        self.currentTab += 1
                    }, label: {
                        Text("다음")
                            .font(.custom("ButtonStyle", size: 18))
                            .foregroundColor(.blue)
                            .frame(width: 345,height: 50)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(lineWidth: 1)
                                    .foregroundColor(.blue)
                            )
                        
                    }) .padding(.bottom, 30)
                } else {
                    NavigationLink(destination:
                        CheckInScreen()
                            .environmentObject(userData)
                    , label: {
                        Text("나와의 연애 시작하기")
                            .font(.custom("ButtonStyle", size: 18))
                            .foregroundColor(.white)
                            .frame(width: 345,height: 50)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .foregroundColor(.blue)
                            )
                    }) .padding(.bottom, 30)
                }
            }
        }
    }
}
