//
//  UIColor.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 11/5/15.
//  Copyright © 2015 Yuji Hato. All rights reserved.
//

import UIKit

extension UIColor {

    convenience init(hex: String) {
        self.init(hex: hex, alpha:1)
    }

    convenience init(hex: String, alpha: CGFloat) {
        var hexWithoutSymbol = hex
        if hexWithoutSymbol.hasPrefix("#") {
            hexWithoutSymbol = hex.substring(1)
        }
        
        let scanner = Scanner(string: hexWithoutSymbol)
        var hexInt:UInt32 = 0x0
        scanner.scanHexInt32(&hexInt)
        
        var r:UInt32!, g:UInt32!, b:UInt32!
        switch (hexWithoutSymbol.length) {
        case 3: // #RGB
            r = ((hexInt >> 4) & 0xf0 | (hexInt >> 8) & 0x0f)
            g = ((hexInt >> 0) & 0xf0 | (hexInt >> 4) & 0x0f)
            b = ((hexInt << 4) & 0xf0 | hexInt & 0x0f)
            break;
        case 6: // #RRGGBB
            r = (hexInt >> 16) & 0xff
            g = (hexInt >> 8) & 0xff
            b = hexInt & 0xff
            break;
        default:
            // TODO:ERROR
            break;
        }
        
        self.init(
            red: (CGFloat(r)/255),
            green: (CGFloat(g)/255),
            blue: (CGFloat(b)/255),
            alpha:alpha)
    }
    static let customerTheme = UIColor(red:1, green:0.5, blue:0.25, alpha:1)
    static let driverTheme = UIColor(red:0.31, green:0.85, blue:0.71, alpha:1)
    static let buttonSelected = UIColor(red:24.0/255.0, green:161.0/255.0, blue:190.0/255.0, alpha:1)
    static let buttonUnSelected = UIColor(red:230.0/255.0, green:230.0/255.0, blue:230.0/255.0, alpha:1)
    static let unselecteButtonTextColor = UIColor(red:74.0/255.0, green:74.0/255.0, blue:74.0/255.0, alpha:1)
    
    static let borderColor = UIColor(red:236.0/255.0, green:236.0/255.0, blue:237.0/255.0, alpha:1)
    
}
