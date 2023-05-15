//
//  RecordCollectionView.swift
//  MC2-LESSERAFIM
//
//  Created by Gucci on 2023/05/07.

import SwiftUI

struct RecordCollectionView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @EnvironmentObject var userData: UserDataModel
    
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

struct Record: Hashable, Codable {
    var id: Int
    var category: Category
    var imageName: String
    var postedAt: String
    var image: Image {
        Image(imageName)
    }
    var beforeDay: Int {
        //MARK: - 0 == today, 1 == yesterday, 2 == the day before yesterday(two days ago)
        let yearMonthDay = postedAt.split(separator: "-").compactMap({ Int($0) })
        let year = yearMonthDay[0]
        let month = yearMonthDay[1]
        let day = yearMonthDay[2]
        let postedDateComponent = DateComponents(year: year, month: month, day: day)
        let postedDate = Calendar.current.date(from: postedDateComponent) ?? Date()
        let gap = abs(postedDate - Date())
        return Int(gap / 86400) // 86400 == 1 day
    }
    init(id: Int, category: Category, imageName: String, postedAt: String) {
        self.id = id
        self.category = category
        self.imageName = imageName
        self.postedAt = postedAt
    }
    
    enum CodingKeys : String, CodingKey {
        case imageName
        case category
        case id
        case postedAt
    }
}

fileprivate extension Date {
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
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
                        (Image.fromData(post.imageData ?? Data())  ?? Image(systemName: "x.circle"))
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
                                .clipped()
                                .cornerRadius(12)
                        } else  {
                            Image("niko")
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
        (Image.fromData(post.imageData ?? Data())  ?? Image(systemName: "x.circle"))
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
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
