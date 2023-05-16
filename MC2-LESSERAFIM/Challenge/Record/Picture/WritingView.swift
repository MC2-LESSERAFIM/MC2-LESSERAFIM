//
//  WritingView.swift
//  MC2-LESSERAFIM
//
//  Created by Jun on 2023/05/07.
//

import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var mode
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let image = info[.originalImage] as? UIImage else { return }
            self.parent.image = image
            self.parent.mode.wrappedValue.dismiss()
        }
    }
}

struct WritingView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @StateObject var permissionManager = PermissionManager()
    
    @AppStorage("opacities") var opacities: [Double] = UserDefaults.standard.array(forKey: "opacities") as? [Double] ?? [0.2, 0.2, 0.2, 0.2, 0.2, 0.2]
    
    enum FocusField: Hashable {
        case title
        case content
    }
    @Environment(\.dismiss) private var dismiss // 화면 이탈
    
    @FetchRequest(entity: Post.entity(), sortDescriptors: [])
    private var posts: FetchedResults<Post>
    
    @State private var imagePickerPresented = false
    @State private var selectedImage: UIImage?
    @State private var profileImage: Image?
    
    @State private var showingAlert = false
    @State var titleRecord: String = ""   // 챌린지 타이틀
    @State var contentRecord: String = ""   // 챌린지 내용
    @State var backToCollection: Bool = false   // 기록 컬랙숀 이동
    var challenge: Challenge
    
    @FocusState private var focusedField: FocusField?
    
    @AppStorage("dailyFirstUse") var dailyFirstUse: Bool = false
    @AppStorage("progressDay") var progressDay: Int = 0
    @AppStorage("isDayChanging") var isDayChanging: Bool = false
    @AppStorage("todayPostsCount") var todayPostsCount = 0
    
    var body: some View {
        ZStack {
            BackgroundView()
            NavigationLink(destination:  ChallengeScreen().environment(\.managedObjectContext, viewContext), isActive: $backToCollection, label: {EmptyView()})
            GeometryReader { geo in
                ScrollView {
                    VStack(spacing: 10) {
                        
                        Button(action: {backToCollection
                            imagePickerPresented.toggle()
                        }, label: {
                            if profileImage == nil {
                                ZStack {
                                    Rectangle()
                                        .foregroundColor(.mainPinkOpacity)
                                        .frame(width: geo.size.width - 40, height: geo.size.height - 239, alignment: .center)

                                    Text("이미지를 업로드 해주세요.")
                                        .foregroundColor(.white)
                                }
                            }
                            else{
                                profileImage!
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: geo.size.width - 40, height: geo.size.height - 239, alignment: .center)
                                    .clipped()
                            }
                        })
                        
                        TitleTextField(titleRecord: $titleRecord, placeholder: "이번 챌린지 사진에 제목을 붙여볼까요?")
                            .submitLabel(.return)
                            .toolbar {
                                ToolbarItemGroup(placement: .keyboard) {
                                    Button("완료") {
                                        hideKeyboard()
                                    }
                                }
                            }
                        
                        //                TextField("어떤 이야기가 담겨있나요?\n", text: $content, axis: .vertical)
                        OtherContentTextField(contentRecord: $contentRecord, placeholder: "어떤 이야기가 담겨있나요?")
                            .lineLimit(3)
                            .submitLabel(.return)
                            .toolbar {
                                ToolbarItemGroup(placement: .keyboard) {
                                    Button("완료") {
                                        hideKeyboard()
                                    }
                                }
                            }
                    }
                }
                .onSubmit {
                    switch focusedField {
                    case .title:
                        focusedField = .content
                    default:
                        hideKeyboard()
                    }
                }
                .padding(EdgeInsets(top: 47-30, leading: 20, bottom: 34, trailing: 20))
                .alert("이미지를 업로드 해주세요", isPresented: $showingAlert) {
                    Button("OK", role: .cancel) {
                        self.showingAlert = false
                    }
                }
                .sheet(isPresented: $imagePickerPresented,
                       onDismiss: loadImage,
                       content: { ImagePicker(image: $selectedImage) })
                .toolbar {
                    ToolbarItem {
                        Image(systemName: "checkmark.circle")
                            .foregroundColor(.mainPink)
                            .onTapGesture {
                                if (selectedImage != nil) {
                                    if isDayChanging == false{
                                        isDayChanging = true
                                    }
                                    addPost(title: titleRecord, content: contentRecord, createdAt: Date.now, day: Int16(progressDay), isFirstPost: dailyFirstUse, imageData: (selectedImage?.jpegData(compressionQuality: 1.0))!)
                                    todayPostsCount += 1
                                    changeBackgroundOpacity()
                                    backToCollection = true
                                    updateFirstUse()
                                }
                                else{
                                    self.showingAlert = true
                                }
                            }.foregroundColor(.mainPink)
                    }
                    
                }
            }
        }
        .onAppear{
            permissionManager.requestAlbumPermission()
        }
    }
    
    private func updateFirstUse() {
        if dailyFirstUse {
            self.dailyFirstUse = false
        }
    }
    
    func loadImage() {
        guard let selectedImage = selectedImage else { return }
        profileImage = Image(uiImage: selectedImage)
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


extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
