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
    
    var body: some View {
        @State var item = ["사진+글", "글", "그림"]
        
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
