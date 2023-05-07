//
//  ContentView.swift
//  MC2-LESSERAFIM 2
//
//  Created by Kim Andrew on 2023/05/03.
//

import SwiftUI

struct Post : Identifiable {
    var id = UUID()
    var image: UIImage
    var title: String
    var content: String
}

struct ContentView: View {
    @ObservedObject var postData = UserData()
    
    var body: some View {
        TabView {
            RecordCollectionView()
                .tabItem {
                    Image(systemName: "star")
                    Text("기록모음")
                }
                .environmentObject(postData)
            
            ChallengeView()
                .tabItem {
                    Image(systemName: "star")
                    Text("챌린지")
                }
                .environmentObject(postData)
            
            ProfileView()
                .tabItem {
                    Image(systemName: "star")
                    Text("프로필")
                }
                .environmentObject(postData)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
