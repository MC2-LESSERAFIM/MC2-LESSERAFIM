//
//  CanvusThicknessSlider.swift
//  MC2-LESSERAFIM
//
//  Created by Kim Andrew on 2023/05/08.
//

import SwiftUI

struct CanvusThicknessSlider: View {
    
    @Binding var panThickness : Double
    @Binding var currentLine : PaintingLine
    
    var body: some View {
        HStack{
            Text("\(Int(panThickness))")
                .frame(width: 30)
            
            Slider(value: $panThickness, in: 5...50,onEditingChanged: { _ in
                currentLine.lineWidth = panThickness
            })
            .frame(width: 280)
        }
        .frame(width: 325, height: 40)
        .background(Color.white)
        .cornerRadius(12)
        .background(
            Rectangle()
                .fill(Color.white)
                .cornerRadius(12)
                .shadow(radius: 12)
                .opacity(0.5)
        )
    }
}

