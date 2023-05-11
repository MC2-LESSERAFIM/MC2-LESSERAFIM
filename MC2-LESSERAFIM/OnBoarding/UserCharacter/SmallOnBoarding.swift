//
//  SmallOnBoarding.swift
//  ImageSwipeHorizontalTest
//
//  Created by 손서연 on 2023/05/11.
//

import SwiftUI

struct UserCharacterData {
    let UserCharacterImage: String
}

private let UserCharacterDataSteps = [
    UserCharacterData(UserCharacterImage: "boy1"),
    UserCharacterData(UserCharacterImage: "boy2"),
    UserCharacterData(UserCharacterImage: "girl1"),
    UserCharacterData(UserCharacterImage: "girl2")
    ]

struct SmallOnBoarding: View {
    
    @State private var currentStep = 0
    @Binding var tappedImageName: String
    
    
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                TabView(selection: $currentStep){
                    ForEach(0..<UserCharacterDataSteps.count) { index in
                        let imageName = UserCharacterDataSteps[index].UserCharacterImage
                        VStack {
                            ZStack {
                                Image(imageName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: geometry.size.width * 0.7)
                                    .background(tappedImageName == imageName ? Color.pink : Color.clear)
                                    .cornerRadius(12)
                                    .onTapGesture {
                                        tappedImageName = imageName
                                    }

                            }
                        }
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                HStack {
                    ForEach(0..<UserCharacterDataSteps.count) { it in
                        if it == currentStep {
                            Rectangle()
                                .frame(width: 20, height: 10)
                                .cornerRadius(10)
                                .foregroundColor(Color.pink)
                        } else {
                            Circle()
                                .frame(width: 10, height: 10)
                                .foregroundColor(Color.gray)
                                .opacity(0.3)
                        }
                    }
                }
                .padding(.bottom, 24)
            }
        }
    }
}

//struct SmallOnBoarding_Previews: PreviewProvider {
//    @State var tappedImageName:String?
//    static var previews: some View {
//        SmallOnBoarding(.constant(tappedImageName))
//            .environmentObject(UserData())
//    }
//}
