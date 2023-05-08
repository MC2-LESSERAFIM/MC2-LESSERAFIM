//
//  ChallengeView.swift
//  MC2-LESSERAFIM
//
//  Created by Jun on 2023/05/07.
//

import SwiftUI

struct ChallengeView: View {
    
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        NavigationView {
            VStack{
                ForEach(userData.challenges, id: \.self) { challenge in
                    NavigationLink{
                        RecordView(challenge: challenge)
                            .environmentObject(userData)
                    } label: {
                        Label("\(challenge)", systemImage: "folder")
                    }
                    .navigationBarTitle("")
                }
            }
        }
    }
}
