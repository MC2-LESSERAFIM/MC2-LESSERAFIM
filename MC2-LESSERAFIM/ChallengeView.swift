//
//  ChallengeView.swift
//  MC2-LESSERAFIM
//
//  Created by Jun on 2023/05/07.
//

import SwiftUI

struct ChallengeView: View {
    
    @EnvironmentObject var postData: UserData
    
    @State var challenges  = ["거울보고 웃기", "파인애플 피자 선물하기", "장점 칭찬하기"]
    
    var body: some View {
        NavigationView {
            VStack{
                ForEach(challenges, id: \.self) { challenge in
                    NavigationLink{
                        RecordView(challenge: challenge)
                            .environmentObject(postData)
                    } label: {
                        Label("\(challenge)", systemImage: "folder")
                    }
                    .navigationBarTitle("")
                    .navigationTitle("")
                }
            }
        }
    }
}
