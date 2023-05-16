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

