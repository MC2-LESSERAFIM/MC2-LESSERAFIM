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
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var postData: UserData
    
    @State private var imagePickerPresented = false
    @State private var selectedImage: UIImage?
    @State private var profileImage: Image?
    
    @State private var showingAlert = false
    @State var title: String = ""
    @State var content: String = ""
    var type: String
    
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
                            .frame(width: geo.size.width - 40, height: geo.size.height - 180, alignment: .center)
                            .clipped()
                    }
                })
                
                TextField("이번 챌린지 사진에 제목을 붙여볼까요?", text: $title)
                    .padding()
                    .background(Color(uiColor: .secondarySystemBackground))
                TextField("어떤 이야기가 담겨있나요?", text: $content)
                    .padding()
                    .background(Color(uiColor: .secondarySystemBackground))
                
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
                                postData.posts.append(Post(image:selectedImage!, title:title, content:content))
                                dismiss()
                                //self.presentationMode.wrappedValue.dismiss()
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

struct WritingView_Previews: PreviewProvider {
    static var previews: some View {
        WritingView(type: "글+사진")
    }
}
