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
    //투명도는 여기서 필요없음
    //@State private var colorOpacity : Double = 1.0
    @State private var thickness : Double = 5.0 //기본 팬 굵기

    //지우개 초기 위치
    @State private var eraserCenter : CGPoint = .zero
    //지우개 visible
    @State private var eraserVisable = false
    
    //Zstack visible Bool & kind
    @State private var toolClicked = false
    @State private var whatTool = 0
    
    //Challenge Title TextField
    @State var titleRecord: String = ""   // 챌린지 타이틀
    
    //Challege Content TextField
    @State var contentRecord: String = ""   // 챌린지 내용
    
    @State private var renImage = Image("")
    
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
                    currentLine.color = selectedColor
                    let newPoint = value.location
                    currentLine.point.append(newPoint) //라인 1개 생성
                    self.lines.append(currentLine) // 그려진 라인을 빈 Arr에 추가
                    eraserCenter = value.location
                    eraserVisable = true
                        })
                    .onEnded({ value in
                        self.currentLine = PaintingLine(point: [], color: selectedColor, lineWidth: thickness)
                        eraserVisable.toggle()
                    })
            )
    }
    
    //View에 사용될 drawingTools View 정의
    var drawingTools : some View {
        HStack{
            Image(systemName: "pencil.tip")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 30)
                .gesture(TapGesture(count: 1).onEnded({
                    toolClicked.toggle()
                    whatTool = 1
                    selectedColor = .black
                }))
            Spacer()
            
            Image(systemName: "eraser")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 30)
                .gesture(TapGesture(count: 1).onEnded({
                    toolClicked.toggle()
                    whatTool = 2
                    selectedColor = .white
                }))
            Spacer()
            
            ColorPicker("", selection: $selectedColor)
                .labelsHidden()
            
            
        }
        .frame(width: 345, height: 44)
    }
    
    
    var body: some View {
        
        NavigationStack{
            //화면 시작
            ZStack {
                VStack{
                    
                    //캔버스 호출
                    canvus
                    
                    //툴바 호출
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
                        //Tool bar 상단에 체크 버튼 생성
                        Button {
                            //체크 버튼 엑션
                            print("Button Clicked")
                            let canvusImage = ImageRenderer(content: canvus)
                            
                            if let image = canvusImage.uiImage{
                                //이미지 처리
                            renImage = Image(uiImage: image)
                                //만약 앨범에 추가하고 싶다면 이거 사용하면 됩니다.
//                                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                                
                                //텍스트 처리
//                                $challengeTitle
//                                $challegeContent
                            }
                             
                        
                        } label: {
                            Image(systemName: "checkmark.circle")
                        }
                }
                
                //필요시 나타나는 View
                VStack{ //case문 좀 치겠는데?
                    Spacer()
                        .frame(width: 325, height: 225)
                    
                    if toolClicked {
                        switch whatTool {
                        case 1:
                            CanvusThicknessSlider(panThickness: $thickness, currentLine:$currentLine)
                        
                        case 2:
                            CanvusThicknessSlider(panThickness: $thickness, currentLine:$currentLine)
                            
//                        case 3:
//                            CanvusColorPickerView(selectedColor: $selectedColor, colorOpacity: $colorOpacity)
//                                .onChange(of: selectedColor){ changeColor in
//                                    currentLine.color = changeColor
//                                }
                            
                        default:
                            Spacer()
                            
                        }
                    }
                }
                
                //지우개 소환!
                if eraserVisable {
                    Circle()
                        .fill(Color.black)
                        .frame(width: thickness, height: thickness)
                    //왼쪽 공간이 남아서 그럼 (제스쳐.location은 상대적 위치만 줌)
                        .offset(x: 24)
                        .position(eraserCenter)
                    
                    Circle()
                        .fill(Color.white)
                        .frame(width: thickness * 0.9, height: thickness * 0.9)
                        .offset(x: 24)
                        .position(eraserCenter)
                    
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
