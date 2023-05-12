//
//  RecordCollectionView.swift
//  MC2-LESSERAFIM
//
//  Created by Gucci on 2023/05/07.

import SwiftUI

//MARK: - TabView에 포함 시킬 "기록모음" 뷰
struct RecordCollectionView: View {
    @EnvironmentObject var postData: UserData
    
    enum SortBy: String, CaseIterable, Identifiable {
        case day = "날짜"
        case category = "주제"
        var id: Self { self }
    }
    
    @State private var selectedSort: SortBy = .day
    
    var width: CGFloat
    var height: CGFloat
    @Binding var opacities: [CGFloat]
    
    var body: some View {
        //TODO: - 들여쓰기 레벨 줄이기
        GeometryReader { geo in
            NavigationView {
                ZStack {
                    background2View(width: width, height: height, opacities: $opacities)
                        .ignoresSafeArea()
                        .frame(width: width, height: height)
                        .border(.red)
                    
                    ScrollView(showsIndicators: false) {
                        // MARK: - sorting by .day
                        if selectedSort == .day {
                            GalleryView(posts: postData.posts)
                        }
                        // MARK: - sorting by .category
                        else if selectedSort == .category {
                            CategoryView(categories: postData.categories)
                        }
                    }
                    
                    Picker("", selection: $selectedSort) {
                        ForEach(SortBy.allCases) { sort in
                            Label(sort.rawValue, systemImage: "arrowtriangle.down.fill")
                                .labelStyle(.titleAndIcon)
                        }
                    }
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .topTrailing)
                }
                .navigationTitle("나의 기록")
                .navigationBarTitleDisplayMode(.large)
                .toolbar {
                    Picker("", selection: $selectedSort) {
                        ForEach(SortBy.allCases) { sort in
                            Label(sort.rawValue, systemImage: "arrowtriangle.down.fill")
                                .labelStyle(.titleAndIcon)
                        }
                    }
                }
                .toolbar(.visible, for: .tabBar)
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
