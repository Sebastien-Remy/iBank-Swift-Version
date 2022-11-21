//
//  ColorToHex-Extension.swift
//  iBank
//
//  Created by Sebastien REMY on 21/11/2022.
//

import SwiftUI
import AppKit

extension Color {
    func toHexString() -> String {
        
        func getComponents() -> (red: Double, green: Double, blue: Double, alpha: Double) {
            var r: CGFloat = 0
            var g: CGFloat = 0
            var b: CGFloat = 0
            var a: CGFloat = 0
            
            let color = NSColor(self)
            color.getRed(&r, green: &g, blue: &b, alpha: &a) //& is pointer for historical reasons
            
            return (r, g, b, a)
        }
        
        let components = getComponents()
       
        let r = Float(components.red)
        let g = Float(components.green)
        let b = Float(components.blue)
        let a = Float(components.alpha)
        
        return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
        
    }
}
