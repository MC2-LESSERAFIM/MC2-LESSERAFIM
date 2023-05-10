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
    
    private let numberColumns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        //TODO: - 들여쓰기 레벨 줄이기
        GeometryReader { geo in
            ScrollView {
                // MARK: - sorting by .day
                if selectedSort == .day {
                    
                    if postData.posts.isEmpty == false {
                        
                        VStack(alignment: .leading) {
                            ForEach(0..<5) { i in
                                HStack {
                                    ForEach(0..<3) { j in
                                        if (i*3 + j) < postData.posts.count {
                                            postData.posts[i*3 + j].image
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: (geo.size.width - 8) / 3, height: geo.size.width / 2.2, alignment: .center)
                                                .clipped()
                                        }
                                    }
                                }
                            }
                        }
                        .toolbar {
                            Picker("", selection: $selectedSort) {
                                ForEach(SortBy.allCases) { sort in
                                    Label(sort.rawValue, systemImage: "arrowtriangle.down.fill")
                                        .labelStyle(.titleAndIcon)
                                }
                            }
                        }
                    } else {
                        Text("No Data").toolbar {
                            Picker("", selection: $selectedSort) {
                                ForEach(SortBy.allCases) { sort in
                                    Label(sort.rawValue, systemImage: "arrowtriangle.down.fill")
                                        .labelStyle(.titleAndIcon)
                                }
                            }
                        }
                    }
                    
                    // MARK: - sorting by .category
                } else if selectedSort == .category {
                    LazyVGrid(columns: numberColumns, spacing: 20) {
                        ForEach(categories) { category in
                            NavigationLink {
                                Text(category.rawValue)
                            } label: {
                                VStack(alignment: .leading) {
                                    Rectangle()
                                        .frame(width: 170, height: 170)
                                        .foregroundColor(Color(.systemGray5))
                                        .cornerRadius(30)
                                    
                                    Text(category.rawValue)
                                        .foregroundColor(.black)
                                        .font(.system(size: 17, weight: .medium, design: .rounded))
                                        .padding(.leading)
                                }
                            }
                        }
                    }
                    
                }
                
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
}

struct Record: Identifiable, Codable {
    var id: Int
    var category: Category
    //    var postedAt: Date
    var imageName: String
    var image: Image {
        Image(imageName)
    }
    
    init(id: Int, category: Category, imageName: String) {
        self.id = id
        self.category = category
        self.imageName = imageName
    }
}

var records: [Record] = load("landmarkData.json")

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

struct RecordView_Preview: PreviewProvider {
    var record = Record(id: 1, category: .favorites, imageName: "stmarylake")
    
    static var previews: some View {
        NavigationStack {
            RecordCollectionView()
        }
    }
}

