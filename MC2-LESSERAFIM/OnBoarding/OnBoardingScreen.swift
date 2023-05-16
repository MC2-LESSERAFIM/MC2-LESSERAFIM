//
//  OnBoardingScreen.swift
//  MC2-LESSERAFIM
//
//  Created by Niko Yejin Kim on 2023/05/08.
//

import SwiftUI

struct OnBoardingScreen: View {
    @State var pageTag:Int? = nil
    @State var tag:Int? = nil
    @State private var currentTab = 0
    
    var body: some View {
        NavigationView{
            ZStack{
                BackgroundView()
                VStack{
                    
                    HStack{
                        
                        Spacer()
                        
                        if currentTab < OnBoardingData.list.count - 1 {
                            Button(action: {
                                self.currentTab = OnBoardingData.list.count - 1
                            }, label: {
                                Text("SKIP")
                                    .padding(.trailing, 30)
                                    .foregroundColor(.mainGray)
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
                                    .foregroundColor(.mainPink)
                            } else {
                                Circle()
                                    .frame(width: 10, height: 10)
                                    .opacity(0.3)
                                    .foregroundColor(.mainGray)
                            }
                        }
                    }
                    .padding(.bottom, 24)
                    
                    if currentTab < OnBoardingData.list.count - 1 {
                        Button(action: {
                            self.currentTab += 1
                        }, label: {
                            Text("다음")
                                .font(.system(size: 17, weight: .bold))
                                .foregroundColor(.mainPink)
                                .frame(width: 345,height: 50)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(lineWidth: 1)
                                        .foregroundColor(.mainPink)
                                )
                            
                        }) .padding(.bottom, 30)
                    } else {
                        NavigationLink(destination:
                                        CheckInScreen()
                                       , label: {
                            Text("나를 찾아 떠나기")
                                .font(.system(size: 17, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 345,height: 50)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .foregroundColor(.mainPink)
                                )
                        }) .padding(.bottom, 30)
                    }
                }
                .navigationTitle("")
                
            }
        }
    }
}
