//
//  OnBoardingTabView.swift
//  MC2-LESSERAFIM
//
//  Created by Niko Yejin Kim on 2023/05/08.
//

import SwiftUI

struct OnboardingTabView: View {
    var data: OnBoardingData

    var body: some View {
        VStack {
            Image(data.objectImage)
                .resizable()
                .frame(width: 345.0, height: 345.0)
            
            Spacer()
                .frame(height: 39.5)
            
            Text(data.primaryText)
                .font(.system(size: 26, weight: .bold))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 25.0)
            
            Spacer()
                .frame(height: 23.5)
            
            Text(data.secondaryText)
                .font(.system(size: 17))
                .lineSpacing(4)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30.0)
                .foregroundColor(.mainGray)
            
            Spacer()
                .frame(height: 60)
            
        }
    }
}
