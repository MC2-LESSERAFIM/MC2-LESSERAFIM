//
//  UserDataView.swift
//  MC2-LESSERAFIM
//
//  Created by 손서연 on 2023/05/08.
//

import SwiftUI

struct UserDataView: View {
    @ObservedObject var userData = UserData()
    var body: some View {
        ChallengeScreen()
            .environmentObject(userData)
    }
}

struct UserDataView_Previews: PreviewProvider {
    static var previews: some View {
        UserDataView()
    }
}
