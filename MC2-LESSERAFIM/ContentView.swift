//
//  ContentView.swift
//  MC2-LESSERAFIM 2
//
//  Created by Kim Andrew on 2023/05/03.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var userData = UserData()
    var body: some View {
        ChallengeScreen()
            .environmentObject(userData)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
