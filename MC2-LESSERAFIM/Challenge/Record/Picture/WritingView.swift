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
    @AppStorage("opacities") var opacities: [Double] = UserDefaults.standard.array(forKey: "opacities") as? [Double] ?? [0.2, 0.2, 0.2, 0.2, 0.2, 0.2]
    
    enum FocusField: Hashable {
        case title
        case content
    }
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @FetchRequest(entity: Post.entity(), sortDescriptors: [])
    private var posts: FetchedResults<Post>
    
    @State private var imagePickerPresented = false
    @State private var selectedImage: UIImage?
    @State private var profileImage: Image?
    
    @State private var showingAlert = false
    @State var title: String = ""
    @State var content: String = ""
    var type: String
    var challenge: Challenge
    
    @FocusState private var focusedField: FocusField?

    
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

    func loadImage() {
        guard let selectedImage = selectedImage else { return }
        profileImage = Image(uiImage: selectedImage)
    }
    
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 10) {
                
                Button(action: {
                    imagePickerPresented.toggle()
                }, label: {
                    if profileImage == nil {
                        Rectangle()
                            .foregroundColor(.gray)
                        
                    }
                    else{
                        profileImage!
                            .resizable()
                            .scaledToFill()
                            .frame(width: geo.size.width - 40, height: geo.size.height - 170, alignment: .center)
                            .clipped()
                    }
                })
                
                TextField("이번 챌린지 사진에 제목을 붙여볼까요?", text: $title)
                    .focused($focusedField, equals: .title)
                    .submitLabel(.next)
                
                TextField("어떤 이야기가 담겨있나요?\n", text: $content, axis: .vertical)
                    .focused($focusedField, equals: .content)
                    .lineLimit(3...)
                    .submitLabel(.return)
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Button("완료") {
                                hideKeyboard()
                            }
                        }
                    }
            }
            .font(.subheadline)
            .textFieldStyle(.roundedBorder)
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
                        .onTapGesture {
                            if (selectedImage != nil) {
                                addPost(title: title, content: content, createdAt: Date.now, day: Int16(1), isFirstPost: true, imageData: (selectedImage?.jpegData(compressionQuality: 1.0))!)
                                switch(self.challenge.category){
                                case "Favorites":
                                    opacities[0] = min(opacities[0] + 0.4, 1.0)
                                    let _ = print(opacities)
                                case "Dislikes":
                                    opacities[1] = min(opacities[1] + 0.4, 1.0)
                                    let _ = print(opacities)
                                case "Strengths":
                                    opacities[2] = min(opacities[2] + 0.4, 1.0)
                                    let _ = print(opacities)
                                case "Weaknesses":
                                    opacities[3] = min(opacities[3] + 0.4, 1.0)
                                    let _ = print(opacities)
                                case "ComfortZone":
                                    opacities[4] = min(opacities[4] + 0.4, 1.0)
                                    let _ = print(opacities)
                                case "Values":
                                    opacities[5] = min(opacities[5] + 0.4, 1.0)
                                    let _ = print(opacities)
                                case .none:
                                    break
                                case .some(_):
                                    break
                                }
                                /*
                                let newPost =  PostModel(type: type,
                                                    imageData: selectedImage?.jpegData(compressionQuality: 1.0),
                                                    title: title,
                                                    content: content,
                                                    category: Category  .random())
                                postData.posts.append(newPost)
                                 */
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
/*
struct WritingView_Previews: PreviewProvider {
    static var previews: some View {
        WritingView(type: "글+사진")
    }
}
*/
