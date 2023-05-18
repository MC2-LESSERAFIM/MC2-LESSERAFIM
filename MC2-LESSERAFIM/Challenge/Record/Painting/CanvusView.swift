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
    var lineWidth : Double = 5.0
}

struct CanvusView: View {
    @Environment(\.managedObjectContext) private var viewContext
    var challenge: Challenge
    @AppStorage("currentChallenge") var currentChallenge: Int = UserDefaults.standard.integer(forKey: "currentChallenge")
    @AppStorage("postedChallenges") var postedChallenges: [Bool] = [false, false, false]
    @AppStorage("postChallenge") var postChallenge: Bool = UserDefaults.standard.bool(forKey: "postChallenge")
    @AppStorage("todayPostsCount") var todayPostsCount = UserDefaults.standard.integer(forKey: "todayPostsCount")
    
    //전역 변수 설정
    @State private var currentLine = PaintingLine()
    @State private var lines : [PaintingLine] = [] //다수의 라인을 저장하는 Arr
    @State private var selectedColor : Color = .black //기본 색상은 Black으로 지정
    //투명도는 여기서 필요없음
    //@State private var colorOpacity : Double = 1.0
    @State private var thickness : Double = 5.0 //기본 팬 굵기
    @State private var eraserThickness : Double = 5.0 //기본 지우개 굵기

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
    @AppStorage("isSelectedTab") var isSelectedTab: Int = 1
    @AppStorage("isFirstPosting") var isFirstPosting: Bool = UserDefaults.standard.bool(forKey: "isFirstPosting")
    @State var firstCompleteScreen: Bool = false

    @State var canvusHeight: CGFloat = 430
    
    //View에 사용될 Canvus 정의
    var canvus: some View{
        Canvas { context, size in
            for line in lines {
                var path = Path()
                path.addLines(line.point)
                context.stroke(path, with: .color(line.color), lineWidth: line.lineWidth)
            }
        }
        .background(.white)
        .cornerRadius(12)
        .frame(width: 345, height: canvusHeight)
        .overlay(RoundedRectangle(cornerRadius: 12) //테두리 Radius
            .stroke(Color.mainPinkOpacity, lineWidth: 2))
        .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onChanged({ value in
                toolClicked = false
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
        .padding(.horizontal, 4)
        .frame(width: 345, height: 44)
    }
    
    
    var body: some View {
        GeometryReader { geo in
            //화면 시작
            ZStack {
                BackgroundView()
                ZStack(alignment: .top) {
                    NavigationLink(destination: RecordCompleteScreen().environment(\.managedObjectContext, viewContext), isActive: $firstCompleteScreen, label: {EmptyView()})
                    VStack{
                        //캔버스 호출
                        canvus
                        
                        //툴바 호출
                        drawingTools
                        
                        Spacer()
                    }.offset(y: geo.size.height - 672)
                    .frame(alignment: .top)
                    VStack{
                        Spacer()
                            .frame(width: 10 , height: geo.size.height - 180)
                        TitleTextField(titleRecord: $titleRecord, placeholder: "이번 챌린지 그림에 제목을 붙여볼까요?")
                            .onTapGesture {
                                toolClicked = false
                            }
                            .padding(.horizontal, 24)
                            .submitLabel(.return)
                            .toolbar {
                                ToolbarItemGroup(placement: .keyboard) {
                                    Button("완료") {
                                        hideKeyboard()
                                    }
                                }
                            }
                        
                        OtherContentTextField(contentRecord: $contentRecord, placeholder: "어떤 이야기가 담겨있나요?")
                            .onTapGesture {
                                toolClicked = false
                            }
                            .padding(.horizontal, 24)
                            .submitLabel(.return)
                            .toolbar {
                                ToolbarItemGroup(placement: .keyboard) {
                                    Button("완료") {
                                        hideKeyboard()
                                    }
                                }
                            }
                    }
                    //필요시 나타나는 View
                    VStack{ //case문 좀 치겠는데?
                        Spacer()
                            .frame(width: 325, height: 375)
                        
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
        } //geo
        .toolbar{
            //Tool bar 상단에 체크 버튼 생성
            Button {
                //체크 버튼 엑션
                let canvusImage = ImageRenderer(content: canvus)
                
                if let image = canvusImage.uiImage{
                    //이미지 처리
                    //renImage = Image(uiImage: image)
                    //만약 앨범에 추가하고 싶다면 이거 사용하면 됩니다.
                    //                                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                    
                    if isDayChanging == false{
                        isDayChanging = true
                    }
                    addPost(title: titleRecord, content: contentRecord, createdAt: Date.now, day: Int16(progressDay), isFirstPost: dailyFirstUse, imageData: (image.jpegData(compressionQuality: 1.0))!)
                    todayPostsCount += 1
                    postedChallenges[currentChallenge] = true
                    changeBackgroundOpacity()
                    if isFirstPosting {
                        firstCompleteScreen = true
                    } else {
                        isSelectedTab = 0
                        postChallenge = false
                    }
                    updateFirstUse()
                }
                
                
            } label: {
                Image(systemName: "checkmark.circle")
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func updateFirstUse() {
        if dailyFirstUse {
            self.dailyFirstUse = false
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
        self.challenge.isSuccess = true
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
