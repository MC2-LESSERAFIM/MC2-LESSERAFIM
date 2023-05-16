//
//  SelectableButton.swift
//  MC2-LESSERAFIM
//
//  Created by 손서연 on 2023/05/16.
//

import SwiftUI

struct SelectableButton: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void
    
    init(
        title: String,
        isSelected: Bool,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.isSelected = isSelected
        self.action = action
    }
    
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Spacer()
                Text(title)
                    .font(.system(size: 17))
                    .fontWeight(.semibold)
                Spacer()
            }
            .frame(height: 48)
            .background(isSelected ? Color.mainPink : Color.opacityWhiteChallenge)
            .foregroundColor(isSelected ? Color.white : Color.mainBlack)
            .cornerRadius(12)
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isSelected ? Color.mainPink : Color.mainPinkOpacity, lineWidth: 2)
            }
        }
    }
}

struct NextButtonStyle: ButtonStyle {
    var isAbled: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 17, weight: .semibold))
            .frame(height: 48)
            .background(isAbled ? Color.mainPink : Color.disabledButtonGray)
            .foregroundColor(Color.white)
            .cornerRadius(12)
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isAbled ? Color.mainPink : Color.disabledButtonGray, lineWidth: 2)
            }
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}
