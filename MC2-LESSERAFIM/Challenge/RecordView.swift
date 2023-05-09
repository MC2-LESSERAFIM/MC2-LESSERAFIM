//
//  RecordView.swift
//  MC2-LESSERAFIM
//
//  Created by Jun on 2023/05/07.
//

import SwiftUI

struct RecordView: View {
    @EnvironmentObject var userData: UserData
    var challenge: String
    let item = ["사진+글", "글", "그림"]
    
    var body: some View {
        
        VStack {
            List{
                ForEach(item, id: \.self) { type in
                    NavigationLink{
                        WritingView(type: type)
                            .environmentObject(userData)
                    } label: {
                        Label(type, systemImage: "square.and.pencil")
                    }
                }
            }
        }
        .navigationBarTitle("", displayMode: .inline)
//        .navigationBarTitle(challenge, displayMode: .inline)
    }
}
