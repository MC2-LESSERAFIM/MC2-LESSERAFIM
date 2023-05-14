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
    enum FocusField: Hashable {
        case title
        case content
    }
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var postData: UserData
    
    @State private var imagePickerPresented = false
    @State private var selectedImage: UIImage?
    @State private var profileImage: Image?
    
    @State private var showingAlert = false
    @State var titleRecord: String = ""   // 챌린지 타이틀
    @State var contentRecord: String = ""   // 챌린지 내용
    var type: String
    
    @FocusState private var focusedField: FocusField?

    func loadImage() {
        guard let selectedImage = selectedImage else { return }
        profileImage = Image(uiImage: selectedImage)
    }
    
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack(spacing: 10) {
                    
                    Button(action: {
                        imagePickerPresented.toggle()
                    }, label: {
                        if profileImage == nil {
                            ZStack {
                                Text("이미지를 업로드 해주세요.")
                                
                                Rectangle()
                                    .foregroundColor(.mainGray)
                                    .frame(width: geo.size.width - 40, height: geo.size.height - 239, alignment: .center)
                            }
                        }
                        else{
                            profileImage!
                                .resizable()
                                .scaledToFill()
                                .frame(width: geo.size.width - 40, height: geo.size.height - 239, alignment: .center)
                                .clipped()
                        }
                    })
                    
                    TitleTextField(titleRecord: $titleRecord, placeholder: "이번 챌린지 사진에 제목을 붙여볼까요?")
                        .submitLabel(.return)
                    
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
                                let newPost =  Post(type: type,
                                                    imageData: selectedImage?.jpegData(compressionQuality: 1.0),
                                                    title: titleRecord,
                                                    content: contentRecord,
                                                    category: Category.random())
                                postData.posts.append(newPost)
                                self.presentationMode.wrappedValue.dismiss()
                            }
                            else{
                                self.showingAlert = true
                            }
                        }.foregroundColor(.blue)
                }
                
            }
        }
    }
}


extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct WritingView_Previews: PreviewProvider {
    static var previews: some View {
        WritingView(type: "글+사진")
    }
}
