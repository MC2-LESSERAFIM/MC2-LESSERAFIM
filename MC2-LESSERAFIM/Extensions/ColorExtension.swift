import SwiftUI

extension Color {
  init(hex: String) {
    let scanner = Scanner(string: hex)
    _ = scanner.scanString("#")
    
    var rgb: UInt64 = 0
    scanner.scanHexInt64(&rgb)
    
    let r = Double((rgb >> 16) & 0xFF) / 255.0
    let g = Double((rgb >>  8) & 0xFF) / 255.0
    let b = Double((rgb >>  0) & 0xFF) / 255.0
    self.init(red: r, green: g, blue: b)
  }
}

extension Color {
    static let mainPink = Color(hex: "FC5A84")
    static let mainPinkOpacity = Color(hex: "FC5A84")
        .opacity(0.6)
    static let mainGray = Color(hex: "9D9D9D")
    static let mainBlack = Color(hex: "292929")
    static let disabledButtonGray = Color(hex: "DDDDDD")
    static let opacityWhite = Color(hex: "FFFFFF")
        .opacity(0.3)
}
