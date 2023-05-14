//
//  RecordCollectionView.swift
//  MC2-LESSERAFIM
//
//  Created by Gucci on 2023/05/07.

import SwiftUI

struct RecordCollectionView: View {
    @EnvironmentObject var userData: UserData
    
    enum SortBy: String, CaseIterable, Identifiable {
        case day = "날짜"
        case category = "주제"
        var id: Self { self }
    }
    
    @State private var choiceMade = "날짜"
    var width: CGFloat
    var height: CGFloat
    
    var body: some View {
        NavigationView {
            ZStack{
                backgroundView(width: width, height: height)
                    .environmentObject(userData)
                
                VStack {
                    HStack(alignment: .bottom) {
                        PageTitle(titlePage: "나의 기록")
                            .padding(.top, 48)
                        
                        Menu {
                            Button(action: {
                                choiceMade = "날짜"
                            }, label: {
                                Text("날짜")
                            })
                            Button(action: {
                                choiceMade = "주제"
                            }, label: {
                                Text("주제")
                            })
                        } label: {
                            Label(title: {
                                Text("\(choiceMade)")
                                    .font(.system(size: 12, weight: .regular))
                            }, icon: {
                                Image(systemName: "arrowtriangle.down.fill")
                                    .font(.system(size: 12))
                                    .frame(width: 12, height: 12)
                            })
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color.mainPink.opacity(0.2))
                            .cornerRadius(9)
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    ScrollView(showsIndicators: false) {
                        if (choiceMade == "날짜") {
                            GalleryView(posts: userData.posts)
                        }
                        else if (choiceMade == "주제") {
                            CategoryView(categories: userData.categories)
                        }
                    }
                    .toolbar(.visible, for: .tabBar)
                }
            }
        }
    }
}

struct RecordCollectionView_Preview: PreviewProvider {
    static var previews: some View {
        GeometryReader { geo in
            NavigationStack {
                RecordCollectionView(width: geo.size.width, height: geo.size.height)
                    .environmentObject(ModelData())
            }
        }
    }
}

enum Category: String, CaseIterable, Codable, Identifiable {
    case favorites = "좋아하는 것"
    case dislikes = "싫어하는 것"
    case strengths = "강점"
    case weaknesses = "약점"
    case comfortZone = "안전지대"
    case valuesAndAim = "가치 및 목표"
    
    var id: Self { self }
    
    static func random() -> Self {
        return Category.allCases.randomElement() ?? .comfortZone
    }
}

struct Record: Hashable, Codable {
    var id: Int
    var category: Category
    var imageName: String
    var image: Image {
        Image(imageName)
    }
    
    init(id: Int, category: Category, imageName: String) {
        self.id = id
        self.category = category
        self.imageName = imageName
    }
    
    enum CodingKeys : String, CodingKey {
        case imageName
        case category
        case id
    }
}

class ModelData: ObservableObject {
    @Published var records: [Record] = load("landmarkData.json")
    
    var categories: [String: [Record]] {
        Dictionary(
            grouping: records,
            by: { $0.category.rawValue }
        )
    }
}

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}

struct GalleryView: View {
    let posts: [Post]
    
    private var items: [GridItem] {
        Array(repeating: .init(.adaptive(minimum: 129),spacing: 3),
              count: 3)
    }
    
    var body: some View {
        VStack {
            LazyVGrid(columns: items, spacing: 3) {
                ForEach(posts, id: \.self.id) { post in
                    NavigationLink {
                        PostDetailView(post: post)
                    } label: {
                        post.image
                            .resizable()
                            .scaledToFit()
                            .frame(minHeight: 172)
                            .background(
                                LinearGradient(gradient: Gradient(colors: [Color(.systemGray5), Color(.systemGray2)]),
                                               startPoint: .top, endPoint: .bottom)
                            )
                            .clipped()
                    }
                }
            }
            Spacer()
        }
    }
}

struct CategoryView: View {
    let categoryKeys: [Category] = Category.allCases
    let categories: [String: [Post]]
    
    private let numberColumns = [
        GridItem(.adaptive(minimum: 164)),
        GridItem(.adaptive(minimum: 164))
    ]
    
    var body: some View {
        LazyVGrid(columns: numberColumns, spacing: 20) {
            ForEach(categoryKeys, id: \.self) { category in
                let category = category.rawValue
                let posts = categories[category] ?? []
                
                NavigationLink {
                    GalleryView(posts: posts)
                        .navigationTitle(category)
                } label: {
                    VStack(alignment: .leading) {
                        posts.first?.image
                            .frame(width: 170, height: 170)
                            .foregroundColor(Color(.systemGray5))
                            .cornerRadius(12)
                        
                        Text(category)
                            .foregroundColor(.black)
                            .font(.system(size: 17, weight: .medium, design: .rounded))
                            .padding(.leading)
                    }
                }
            }
        }
        .toolbar(.hidden, for: .tabBar)
    }
}

struct PostDetailView: View {
    @Environment(\.dismiss) var dismiss
        
    let post: Post
    
    var body: some View {
        post.image
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "x.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 36)
                            .foregroundColor(.black)
                    }
                }
            }
            .toolbar(.hidden, for: .tabBar)
            .navigationBarBackButtonHidden()
        
    }
}

struct PostDetailView_Preview: PreviewProvider {
    @StateObject static var userData = UserData()
    
    static var previews: some View {
        PostDetailView(post: userData.posts.last
                       ?? Post(type: "글 + 사진",
                               imageData: nil,
                               title: "행복로",
                               content: "사랑시",
                               category: .comfortZone))
    }
}

extension Image {
    static func fromData(_ data: Data) -> Image? {
        guard let uiImage = UIImage(data: data) else {
            return nil
        }
        return Image(uiImage: uiImage)
            .renderingMode(.original)
    }
}
