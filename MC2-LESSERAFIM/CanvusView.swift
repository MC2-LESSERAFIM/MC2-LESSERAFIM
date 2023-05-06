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
    
    //Zstack visible Bool & kind
    @State private var toolClicked = false
    @State private var whatTool = 0
    
    //Challenge Title TextField
    @State private var challengeTitle = ""
    
    //Challege Content TextField
    @State private var challegeContent = ""
    
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
    
    var drawingTools : some View {
        HStack{
            Image(systemName: "pencil.tip")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 30)
                .gesture(TapGesture(count: 1).onEnded({
                    toolClicked.toggle()
                    whatTool = 1
                }))
            Spacer()
            
            Image(systemName: "eraser")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 30)
                .gesture(TapGesture(count: 1).onEnded({
                    toolClicked.toggle()
                    whatTool = 2
                }))
            Spacer()
            
            Image(systemName: "scribble.variable")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 30)
                .gesture(TapGesture(count: 1).onEnded({
                    toolClicked.toggle()
                    whatTool = 3
                }))
            Spacer()
            
            Image(systemName: "eyedropper")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 30)
                .gesture(TapGesture(count: 1).onEnded({
                    toolClicked.toggle()
                    whatTool = 4
                }))
            Spacer()
            
            Image(systemName: "circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 30)
                .gesture(TapGesture(count: 1).onEnded({
                    toolClicked.toggle()
                    whatTool = 5
                }))
            
        }
        .frame(width: 345, height: 44)
    }
    
    var body: some View {
        
        NavigationStack{
            //화면 시작
            ZStack {
                VStack{
                    
                    canvus
                    
                    drawingTools
                    
                    TextField("이번 챌린지 사진에 제목을 붙여볼까요?", text: $challengeTitle)
                        .padding()
                        .frame(width: 345, height: 39)
                        .border(Color.black)
                    
                    TextField("어떤 이야기가 담겨있나요?", text: $challegeContent)
                        .padding()
                        .frame(width: 345, height: 122)
                        .border(Color.black)
                    
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
                
                VStack{ //case문 좀 치겠는데?
                    Spacer()
                        .frame(width: 325, height: 523)
                    
                    if toolClicked {
                        switch whatTool {
                        case 1:
                            Slider(value: $thickness, in: 1...30)
                        
                        case 2:
                            Slider(value: $thickness, in: 1...30)
                            
                        case 3:
                            CanvusColorPickerView(selectedColor: $selectedColor)
                                .onChange(of: selectedColor){ changeColor in
                                    currentLine.color = changeColor
                                }
                        case 4:
                            Slider(value: $thickness, in: 1...30)
                            
                        case 5:
                            Slider(value: $thickness, in: 1...30)
                            
                        default:
                            Spacer()
                            
                        }
                    }
                    
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
