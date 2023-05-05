//
//  Canvus.swift
//  MC2-LESSERAFIM
//
//  Created by Kim Andrew on 2023/05/05.
//

import SwiftUI

//Canvus에 그려지는 라인 저장
struct PaintingLine {
    var point = [CGPoint]()
    var color : Color = .black
    var lineWidth : Double = 1.0
}


struct CanvusView: View {
    
    //전역 변수 설정
    @State private var currentLine = PaintingLine()
    @State private var lines : [PaintingLine] = [] //다수의 라인을 저장하는 Arr
    @State private var selectedColor : Color = .black //기본 색상은 Black으로 지정
    @State private var thickness : Double = 1.0 //기본 팬 굵기
    
    //View에 사용될 Canvus 정의
    var canvus : some View{
        Canvas { context, size in
            
            for line in lines {
                var path = Path()
                path.addLines(line.point)
                context.stroke(path, with: .color(line.color), lineWidth: line.lineWidth)
            }
            
        }.frame(width: 345, height: 513) //크기 지정
            .overlay(RoundedRectangle(cornerRadius: 20) //테두리 Radius
                .stroke(Color.black, lineWidth: 5))
            .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                .onChanged({ value in
                    let newPoint = value.location
                    currentLine.point.append(newPoint) //라인 1개 생성
                    self.lines.append(currentLine) // 그려진 라인을 빈 Arr에 추가
                        })
                    .onEnded({ value in
                        self.currentLine = PaintingLine(point: [], color: selectedColor, lineWidth: thickness)
                    })
            )
    }
    
    var body: some View {
        
        NavigationStack{
            //화면 시작
            VStack{
                
                canvus
                
                }
                .toolbar{
                    //Tool bar에 체크 버튼 생성
                    Button {
                        //체크 버튼 엑션
                        print("Button Clicked")
                    } label: {
                        Image(systemName: "checkmark.circle")
                    }
                }
        }
    }
}

struct Canvus_Previews: PreviewProvider {
    static var previews: some View {
        CanvusView()
    }
}
