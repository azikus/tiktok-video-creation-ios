//
//  UIFont+.swift
//  Azikus Architecture
//
//  Created by Krešimir Baković on 29.09.2021..
//

import UIKit

extension UIFont {
    // SYSTEM-LIGHT
    static func systemLight(with size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .light)
    }
    
    // SYSTEM-REGULAR
    static func systemRegular(with size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .regular)
    }
    
    // SYSTEM-BOLD
    static func systemBold(with size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .bold)
    }
}
