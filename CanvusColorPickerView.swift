//
//  CanvusColorPickerView.swift
//  MC2-LESSERAFIM
//
//  Created by Kim Andrew on 2023/05/05.
//

import SwiftUI

//Color Picker View
struct CanvusColorPickerView: View {
    
    let colorArr1 = [Color.black, Color.red, Color.orange, Color.yellow, Color.green] //디폴트 색상
    
    let colorArr2 = [Color.blue, Color.cyan, Color.purple, Color.pink, Color.white] //디폴트 색상
    
    @Binding var selectedColor: Color
    
    @Binding var colorOpacity : Double
    
    
    var body: some View {
        VStack(alignment: .leading){
            Text("Opacity")
                .frame(height: 18)
        
            HStack{ //Opacity Slider
                
                Slider(value: $colorOpacity, in : 0.0...1.0)
                    .frame(width: 227)
                
                Text("100%") //Opacity 값
            }
                HStack{
                    
                    Rectangle()
                        .fill(selectedColor)
                        .opacity(colorOpacity)
                        .frame(width: 82, height: 82)
                        .cornerRadius(10)
                    
                    VStack{
                        HStack{
                            ForEach(colorArr1, id: \.self) {color in
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
                        HStack{
                            ForEach(colorArr2, id: \.self) {color in
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
        }
    }
}
