//
//  UIColor+.swift
//  Fansomnia
//
//  Created by Krešimir Baković on 02/11/2020.
//

import UIKit

extension UIColor {
    // Pallette colors
    
    @nonobjc class var ohmicsBlue: UIColor {
        return UIColor(red: 103.0 / 255.0, green: 161.0 / 255.0, blue: 171.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var ohmicsBlueWith02: UIColor {
        return UIColor(red: 103.0 / 255.0, green: 161.0 / 255.0, blue: 171.0 / 255.0, alpha: 0.2)
    }
    
    @nonobjc class var shadowColor: UIColor {
        return UIColor(red: 200.0 / 255.0, green: 205.0 / 255.0, blue: 205.0 / 255.0, alpha: 0.8)
    }
    
    /// (201, 203, 203, 1.0)
    @nonobjc class var grayTabBar: UIColor {
        return UIColor(red: 201.0 / 255.0, green: 203.0 / 255.0, blue: 203.0 / 255.0, alpha: 1.0)
    }
    
    /// (59, 158, 54, 1.0)
    @nonobjc class var appGreen: UIColor {
        return UIColor(red: 59.0 / 255.0, green: 158.0 / 255.0, blue: 54.0 / 255.0, alpha: 1.0)
    }
    
    /// (161, 219, 185, 1.0)
    @nonobjc class var appLightGreen: UIColor {
        return UIColor(red: 161.0 / 255.0, green: 219.0 / 255.0, blue: 185.0 / 255.0, alpha: 1.0)
    }
    
    /// (3, 120, 57, 1.0)
    @nonobjc class var appDarkGreen: UIColor {
        return UIColor(red: 3.0 / 255.0, green: 120.0 / 255.0, blue: 57.0 / 255.0, alpha: 1.0)
    }
    
    /// (28, 72, 48, 1.0)
    @nonobjc class var appVeryDarkGreen: UIColor {
        return UIColor(red: 28.0 / 255.0, green: 72.0 / 255.0, blue: 48.0 / 255.0, alpha: 1.0)
    }
    
    /// (255, 203, 5, 1.0)
    @nonobjc class var appYellow: UIColor {
        return UIColor(red: 255.0 / 255.0, green: 203.0 / 255.0, blue: 5.0 / 255.0, alpha: 1.0)
    }
    
    /// (204, 37, 37, 1.0)
    @nonobjc class var appred: UIColor {
        return UIColor(red: 204.0 / 255.0, green: 37.0 / 255.0, blue: 37.0 / 255.0, alpha: 1.0)
    }
    
    /// (173, 27, 27, 0.5)
    @nonobjc class var appredWIth05: UIColor {
        return UIColor(red: 173.0 / 255.0, green: 27.0 / 255.0, blue: 27.0 / 255.0, alpha: 0.5)
    }
    
    /// (0, 0, 0, 1.0)
    @nonobjc class var appBlack: UIColor {
        return UIColor(red: 0.0 / 255.0, green: 0.0 / 255.0, blue: 0.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var blackWith008: UIColor {
        return UIColor(red: 0.0 / 255.0, green: 0.0 / 255.0, blue: 0.0 / 255.0, alpha: 0.08)
    }
    
    @nonobjc class var blackWith01: UIColor {
        return UIColor(red: 0.0 / 255.0, green: 0.0 / 255.0, blue: 0.0 / 255.0, alpha: 0.1)
    }
    
    @nonobjc class var blackWith02: UIColor {
        return UIColor(red: 0.0 / 255.0, green: 0.0 / 255.0, blue: 0.0 / 255.0, alpha: 0.2)
    }
    
    @nonobjc class var blackWith03: UIColor {
        return UIColor(red: 0.0 / 255.0, green: 0.0 / 255.0, blue: 0.0 / 255.0, alpha: 0.3)
    }
    
    @nonobjc class var blackWith04: UIColor {
        return UIColor(red: 0.0 / 255.0, green: 0.0 / 255.0, blue: 0.0 / 255.0, alpha: 0.4)
    }
    
    @nonobjc class var blackWith05: UIColor {
        return UIColor(red: 0.0 / 255.0, green: 0.0 / 255.0, blue: 0.0 / 255.0, alpha: 0.5)
    }
    
    @nonobjc class var blackWith06: UIColor {
        return UIColor(red: 0.0 / 255.0, green: 0.0 / 255.0, blue: 0.0 / 255.0, alpha: 0.6)
    }
    
    @nonobjc class var blackWith07: UIColor {
        return UIColor(red: 0.0 / 255.0, green: 0.0 / 255.0, blue: 0.0 / 255.0, alpha: 0.7)
    }
    
    @nonobjc class var blackWith08: UIColor {
        return UIColor(red: 0.0 / 255.0, green: 0.0 / 255.0, blue: 0.0 / 255.0, alpha: 0.8)
    }
    
    @nonobjc class var blackWith095: UIColor {
        return UIColor(red: 0.0 / 255.0, green: 0.0 / 255.0, blue: 0.0 / 255.0, alpha: 0.95)
    }
    
    /// (255, 255, 255, 1.0)
    @nonobjc class var appWhite: UIColor {
        return UIColor(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
    }
    
    /// (255, 255, 255, 0.3)
    @nonobjc class var whiteWith03: UIColor {
        return UIColor(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0, alpha: 0.3)
    }
    
    /// (255, 255, 255, 0.5)
    @nonobjc class var whiteWith05: UIColor {
        return UIColor(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0, alpha: 0.5)
    }
    
    /// (255, 255, 255, 0.95)
    @nonobjc class var whiteWith095: UIColor {
        return UIColor(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0, alpha: 0.95)
    }
    
    @nonobjc class var white237: UIColor {
        return UIColor(red: 237.0 / 255.0, green: 237.0 / 255.0, blue: 237.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var black30: UIColor {
        return UIColor(red: 30.0 / 255.0, green: 30.0 / 255.0, blue: 30.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var black34: UIColor {
        return UIColor(red: 34.0 / 255.0, green: 34.0 / 255.0, blue: 34.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var gray15: UIColor {
        return UIColor(red: 15.0 / 255.0, green: 15.0 / 255.0, blue: 15.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var gray51: UIColor {
        return UIColor(red: 51.0 / 255.0, green: 51.0 / 255.0, blue: 51.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var gray51With03: UIColor {
        return UIColor(red: 51.0 / 255.0, green: 51.0 / 255.0, blue: 51.0 / 255.0, alpha: 0.3)
    }
    
    @nonobjc class var gray51With05: UIColor {
        return UIColor(red: 51.0 / 255.0, green: 51.0 / 255.0, blue: 51.0 / 255.0, alpha: 0.5)
    }
    
    @nonobjc class var gray51With06: UIColor {
        return UIColor(red: 51.0 / 255.0, green: 51.0 / 255.0, blue: 51.0 / 255.0, alpha: 0.6)
    }
    
    @nonobjc class var gray51With08: UIColor {
        return UIColor(red: 51.0 / 255.0, green: 51.0 / 255.0, blue: 51.0 / 255.0, alpha: 0.8)
    }
    
    @nonobjc class var gray55: UIColor {
        return UIColor(red: 55.0 / 255.0, green: 55.0 / 255.0, blue: 55.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var gray70: UIColor {
        return UIColor(red: 70.0 / 255.0, green: 70.0 / 255.0, blue: 70.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var gray70With01: UIColor {
        return UIColor(red: 70.0 / 255.0, green: 70.0 / 255.0, blue: 70.0 / 255.0, alpha: 0.1)
    }
    
    @nonobjc class var gray102: UIColor {
        return UIColor(red: 102.0 / 255.0, green: 102.0 / 255.0, blue: 102.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var gray126: UIColor {
        return UIColor(red: 126.0 / 255.0, green: 126.0 / 255.0, blue: 126.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var gray157: UIColor {
        return UIColor(red: 157.0 / 255.0, green: 157.0 / 255.0, blue: 157.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var gray157With06: UIColor {
        return UIColor(red: 157.0 / 255.0, green: 157.0 / 255.0, blue: 157.0 / 255.0, alpha: 0.6)
    }
    
    @nonobjc class var gray185: UIColor {
        return UIColor(red: 185.0 / 255.0, green: 185.0 / 255.0, blue: 185.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var gray204: UIColor {
        return UIColor(red: 204.0 / 255.0, green: 204.0 / 255.0, blue: 204.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var gray204With02: UIColor {
        return UIColor(red: 204.0 / 255.0, green: 204.0 / 255.0, blue: 204.0 / 255.0, alpha: 0.2)
    }
    
    @nonobjc class var gray204With03: UIColor {
        return UIColor(red: 204.0 / 255.0, green: 204.0 / 255.0, blue: 204.0 / 255.0, alpha: 0.3)
    }
    
    @nonobjc class var gray204With04: UIColor {
        return UIColor(red: 204.0 / 255.0, green: 204.0 / 255.0, blue: 204.0 / 255.0, alpha: 0.4)
    }
    
    @nonobjc class var gray215: UIColor {
        return UIColor(red: 215.0 / 255.0, green: 215.0 / 255.0, blue: 215.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var gray235: UIColor {
        return UIColor(red: 235.0 / 255.0, green: 235.0 / 255.0, blue: 235.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var gray238: UIColor {
        return UIColor(red: 238.0 / 255.0, green: 238.0 / 255.0, blue: 238.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var gray238With08: UIColor {
        return UIColor(red: 238.0 / 255.0, green: 238.0 / 255.0, blue: 238.0 / 255.0, alpha: 0.8)
    }
}
