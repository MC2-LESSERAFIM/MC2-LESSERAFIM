//
//  CanvusThicknessSlider.swift
//  MC2-LESSERAFIM
//
//  Created by Kim Andrew on 2023/05/08.
//

import SwiftUI

struct CanvusThicknessSlider: View {
    
    @Binding var panThickness : Double
    
    var body: some View {
        HStack{
            Text("\(Int(panThickness))")
                .frame(width: 30)
            
            Slider(value: $panThickness, in: 1...30)
                .frame(width: 280)
        }
        .frame(width: 325, height: 40)
        .overlay(RoundedRectangle(cornerRadius: 20) //테두리 Radius
            .stroke(Color.black, lineWidth: 1))
    }
}

