//
//  RecordView.swift
//  MC2-LESSERAFIM
//
//  Created by Jun on 2023/05/07.
//

import SwiftUI

struct RecordView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    var challenge: Challenge
    
    let item = ["사진+글", "글", "그림"]
    
    var body: some View {
        
        VStack {
            List{
                ForEach(item, id: \.self) { type in
                    NavigationLink{
                        WritingView(type: type, challenge: challenge)
                            .environment(\.managedObjectContext, viewContext)
                    } label: {
                        Label(type, systemImage: "square.and.pencil")
                    }
                }
            }
        }
        .navigationBarTitle("", displayMode: .inline)
        .toolbar(.hidden, for: .tabBar)
    }
}
