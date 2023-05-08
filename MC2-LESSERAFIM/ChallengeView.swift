//
//  ChallengeView.swift
//  MC2-LESSERAFIM
//
//  Created by Jun on 2023/05/07.
//

import SwiftUI

struct ChallengeView: View {
    
    @EnvironmentObject var postData: UserData
    
    var body: some View {
        NavigationView {
            VStack{
                ForEach(postData.challenges, id: \.self) { challenge in
                    NavigationLink{
                        RecordView(challenge: challenge)
                            .environmentObject(postData)
                    } label: {
                        Label("\(challenge)", systemImage: "folder")
                    }
                    .navigationBarTitle("")
                }
            }
        }
    }
}
