//
//  RecordCollectionView.swift
//  MC2-LESSERAFIM
//
//  Created by Gucci on 2023/05/07.

import SwiftUI

struct RecordCollectionView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [])
    private var challenges: FetchedResults<Challenge>

    @State var posts: [Post] = []
    @State var postsByCategory: [String: [Post]] = [:]
    
    enum SortBy: String, CaseIterable, Identifiable {
        case day = "날짜"
        case category = "주제"
        var id: Self { self }
    }
    
    @State private var selectedSort: SortBy = .day
    
    init() {
        self.posts = PersistenceController.shared.getAllPosts()
        self.postsByCategory = PersistenceController.shared.getPostsByCategory()
    }
    
    func saveContext() {
        do {
            try viewContext.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                VStack {
                    HStack(alignment: .bottom) {
                        PageTitle(titlePage: "나의 기록")
                            .padding(.top, 48)
                        
                        Menu {
                            Button(action: {
                                selectedSort = SortBy.day
                            }, label: {
                                Text("날짜")
                            })
                            Button(action: {
                                selectedSort = SortBy.category
                            }, label: {
                                Text("주제")
                            })
                        } label: {
                            Label(title: {
                                Text("\(selectedSort.rawValue)")
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
                        if selectedSort == .day {
                            GalleryView(posts: posts)
                        }
                        else if selectedSort == .category {
                            CategoryView(categories: postsByCategory)
                        }
                    }
                    .toolbar(.visible, for: .tabBar)
                }
            }
            .onAppear {
                self.posts = PersistenceController.shared.getAllPosts()
                self.postsByCategory = PersistenceController.shared.getPostsByCategory()
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
    
    var textFromCSV: String {
        switch self {
        case .favorites:
            return "Favorites"
        case .dislikes:
            return "Dislikes"
        case .strengths:
            return "Strengths"
        case .weaknesses:
            return "Weaknesses"
        case .comfortZone:
            return "ComfortZone"
        case .valuesAndAim:
            return "Values"
        }
    }
}


fileprivate extension Date {
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
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
                        ThumbnailView(post: post)
                    }
                }
            }
            Spacer()
        }
    }
}

struct ThumbnailView: View {
    let post: Post
    
    var body: some View {
        if let imageData = post.imageData,
           let image = Image.fromData(imageData) {
            // MARK: - 사진 or 그림 Post
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 129, height: 172)
                .clipped()
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color(.systemGray5), Color(.systemGray2)]),
                                   startPoint: .top, endPoint: .bottom)
                )
                .overlay {
                    DayLabel(isFirstPost: post.isFirstPost, day: Int(post.day))
                        .frame(alignment: .topLeading)
                        .padding([.leading, .top], 4)
                }
        } else {
            // MARK: - 글 Post
            VStack(spacing: 30) {
                Text(post.title ?? "")
                    .padding([.leading, .top], 4)
                    .font(.title3)
                    .lineLimit(1)
                
                Text(post.content ?? "")
                    .padding([.leading], 4)
                    .foregroundColor(.black)
                    .font(.body)
                    .lineLimit(5)
            }
            .frame(width: 129, height: 172, alignment: .topLeading)
            .background(.white)
            .overlay {
                DayLabel(isFirstPost: post.isFirstPost, day: Int(post.day))
                    .frame(alignment: .topLeading)
                    .padding([.leading, .top], 4)
            }
        }
    }
}

struct DayLabel: View {
    let isFirstPost: Bool
    let day: Int
    
    var body: some View {
        Capsule()
            .frame(maxWidth: 70, maxHeight: 30)
            .foregroundColor(.white)
            .cornerRadius(12)
            .overlay {
                Text("Day+\(day)")
                    .foregroundColor(.black)
                    .font(.body.bold())
            }
            .opacity(isFirstPost ? 1 : 0)
    }
}

struct CategoryView: View {
    let categoryKeys: [Category] = Category.allCases
    let categories: [String: [Post]]
    private let numberColumns = Array(repeating: GridItem(.fixed(160), spacing: 25), count: 2)
    
    var body: some View {
        LazyVGrid(columns: numberColumns, spacing: 24) {
            ForEach(categoryKeys, id: \.self) { category in
                let category = category.textFromCSV
                let posts = categories[category] ?? []
                
                NavigationLink {
                    GalleryView(posts: posts)
                        .navigationTitle(category)
                } label: {
                    VStack(alignment: .leading) {
                        if let first = posts.first,
                           let data = first.imageData,
                           let image = Image.fromData(data) {
                            
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 170, height: 170, alignment: .center)
                                .cornerRadius(12)
                                .clipped()
                        } else  {
                            Image(category)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 170, height: 170)
                                .cornerRadius(12)
                        }
                        
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
    
    @State var isTabBarVisible = false
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            CardView(post:post)
            /*
            (Image.fromData(post.imageData ?? Data())  ?? Image(systemName: "x.circle"))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button {
                            isTabBarVisible = true
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.mainPink)
                        }
                    }
                }
                .toolbar(isTabBarVisible ? .visible : .hidden, for: .tabBar)
                .navigationBarBackButtonHidden()
             */
        }
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
