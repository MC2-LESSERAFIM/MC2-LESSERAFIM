//
//  CanvusColorPickerView.swift
//  MC2-LESSERAFIM
//
//  Created by Kim Andrew on 2023/05/05.
//

import SwiftUI

//Color Picker View
struct CanvusColorPickerView: View {
    
    let Colors = [Color.black, Color.red, Color.orange, Color.yellow, Color.green, Color.blue, Color.purple] //디폴트 색상
    @Binding var selectedColor: Color
    
    var body: some View {
        HStack{
            ForEach(Colors, id: \.self) {color in
                Image(systemName: selectedColor == color ?
                      CanvusColorConstant.Icons.recordCircleFill : CanvusColorConstant.Icons.circleFill) //원형 컬러 선택 Constants
                .foregroundColor(color)
                .font(.system(size: 15))
                .clipShape(Circle())
                .onTapGesture {//선택시 색상 변경
                    selectedColor = color
                }
            }
        }
    }
}
        
        struct CanvusColorPickerView_Previews: PreviewProvider{
            static var previews: some View {
                CanvusColorPickerView(selectedColor: .constant(.black))
            }
        }
