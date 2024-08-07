//
//  ColorEx.swift
//  Bit
//
//  Created by horo on 8/8/24.
//

import SwiftUI

extension Color {
    static let skyBlue = Color(hex: "#00CFFF")
    static let hotPink = Color(hex: "#FF5C93")
    static let brightYellow = Color(hex: "#FFEB3B")
    static let limeGreen = Color(hex: "#AEEA00")
    static let vibrantOrange = Color(hex: "#FF6D00")
    
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var hexNumber: UInt64 = 0
        
        if hex.hasPrefix("#") {
            scanner.currentIndex = scanner.string.index(after: scanner.currentIndex)
        }
        
        if scanner.scanHexInt64(&hexNumber) {
            let r = Double((hexNumber & 0xff0000) >> 16) / 255
            let g = Double((hexNumber & 0x00ff00) >> 8) / 255
            let b = Double(hexNumber & 0x0000ff) / 255
            self.init(red: r, green: g, blue: b)
            return
        }
        
        self.init(.white)
    }
}
