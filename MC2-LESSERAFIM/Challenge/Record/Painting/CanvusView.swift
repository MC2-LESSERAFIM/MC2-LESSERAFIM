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
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss // 화면 이탈
    var challenge: Challenge
    
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
    
    @AppStorage("opacities") var opacities: [Double] = UserDefaults.standard.array(forKey: "opacities") as? [Double] ?? [0.2, 0.2, 0.2, 0.2, 0.2, 0.2]
    
    @AppStorage("dailyFirstUse") var dailyFirstUse: Bool = false
    @AppStorage("progressDay") var progressDay: Int = 0
    @AppStorage("isDayChanging") var isDayChanging: Bool = false
    
    //View에 사용될 Canvus 정의
    var canvus : some View{
        Canvas { context, size in
            for line in lines {
                var path = Path()
                path.addLines(line.point)
                context.stroke(path, with: .color(line.color), lineWidth: line.lineWidth)
            }
        }
        .overlay(RoundedRectangle(cornerRadius: 12) //테두리 Radius
            .stroke(Color.mainPinkOpacity, lineWidth: 2))
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
        .background(.white)
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
        .padding(.horizontal, 4)
        .frame(width: 345, height: 44)
    }
    
    
    var body: some View {
            GeometryReader { geo in
                NavigationStack{
                    ScrollView {
                        //화면 시작ddd
                        ZStack {
                            BackgroundView()
                        ZStack {
                            VStack{
                                //캔버스 호출
                                canvus
                                    .frame(width: geo.size.width - 40, height: geo.size.height - 283, alignment: .center)
                                
                                //툴바 호출
                                drawingTools
                                
                                TitleTextField(titleRecord: $titleRecord, placeholder: "이번 챌린지 사진에 제목을 붙여볼까요?")
                                    .padding(.horizontal, 24)
                                    .submitLabel(.return)
                                
                                OtherContentTextField(contentRecord: $contentRecord, placeholder: "어떤 이야기가 담겨있나요?")
                                    .padding(.horizontal, 24)
                                    .submitLabel(.return)
                            }
                            .toolbar{
                                //Tool bar 상단에 체크 버튼 생성
                                Button {
                                    //체크 버튼 엑션
                                    print("Button Clicked")
                                    let canvusImage = ImageRenderer(content: canvus)
                                    
                                    if let image = canvusImage.uiImage{
                                        //이미지 처리
                                        //renImage = Image(uiImage: image)
                                        //만약 앨범에 추가하고 싶다면 이거 사용하면 됩니다.
                                        //                                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                                        
                                        addPost(title: titleRecord, content: contentRecord, createdAt: Date.now, day: Int16(progressDay), isFirstPost: dailyFirstUse, imageData: (image.jpegData(compressionQuality: 1.0))!)
                                        changeBackgroundOpacity()
                                        dismiss()
                                    }
                                    
                                    
                                } label: {
                                    Image(systemName: "checkmark.circle")
                                }
                            }
                            
                            //필요시 나타나는 View
                            VStack{ //case문 좀 치겠는데?
                                Spacer()
                                    .frame(width: 325, height: 160)
                                
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
        }
    }
    
    func saveContext() {
      do {
        try viewContext.save()
      } catch {
        print("Error saving managed object context: \(error)")
      }
    }
    
    func addPost(title: String, content: String, createdAt: Date, day: Int16, isFirstPost: Bool, imageData: Data) {
        let post = Post(context: viewContext)
        post.title = title
        post.content = content
        post.day = day
        post.isFirstPost = isFirstPost
        post.imageData = imageData
        post.createdAt = createdAt
        post.challenge = self.challenge
        saveContext()
    }

    func changeBackgroundOpacity() {
        switch(challenge.category){
        case "Favorites":
            opacities[0] = min(opacities[0] + 0.4, 1.0)
        case "Dislikes":
            opacities[1] = min(opacities[1] + 0.4, 1.0)
        case "Strengths":
            opacities[2] = min(opacities[2] + 0.4, 1.0)
        case "Weaknesses":
            opacities[3] = min(opacities[3] + 0.4, 1.0)
        case "ComfortZone":
            opacities[4] = min(opacities[4] + 0.4, 1.0)
        case "Values":
            opacities[5] = min(opacities[5] + 0.4, 1.0)
        case .none:
            break
        case .some(_):
            break
        }
    }
}
