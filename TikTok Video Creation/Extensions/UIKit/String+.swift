//
//  String+.swift
//  Fansomnia
//
//  Created by Dino Bozic on 24/08/2020.
//  Copyright © 2020 Speck. All rights reserved.
//

import CoreGraphics
import UIKit

extension String {
    func toURL() -> URL? {
        URL(string: self)
    }
}

extension UIColor {
    func toHex() -> String {
        let numberOfColorComponents: Int = cgColor.numberOfComponents
        let colorComponents = cgColor.components!

        var colorHexString = ""
        if numberOfColorComponents == 4 {
            let red = colorComponents[0] * 255
            let green = colorComponents[1] * 255
            let blue = colorComponents[2] * 255

            colorHexString = NSString(format: "%02X%02X%02X", Int(red), Int(green), Int(blue)) as String
        } else if numberOfColorComponents == 2 {
            let white = colorComponents[0] * 255

            colorHexString = NSString(format: "%02X%02X%02X", Int(white), Int(white), Int(white)) as String
        } else {
            return "Color format noch supported"
        }

        return colorHexString
    }
}

extension String {
    func htmlFormattedString(font: UIFont, color: UIColor) -> String {
        return NSString(format: "<html>\n <head>\n <style type=\"text/css\">\n body {font-family: \"%@\"; font-size: %@; color:#%@;}\n </style>\n </head>\n <body>%@</body>\n </html>",
                        font.familyName, "\(font.pointSize)",
                        color.toHex(), self) as String
    }

    func toInt() -> Int? {
        return Int(self)
    }
}

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
}

extension String {
    func attributedStringWithColor(_ strings: [String], color: UIColor, characterSpacing: UInt? = nil) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        for string in strings {
            let range = (self as NSString).range(of: string)
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        }

        guard let characterSpacing = characterSpacing else { return attributedString }

        attributedString.addAttribute(NSAttributedString.Key.kern, value: characterSpacing, range: NSRange(location: 0, length: attributedString.length))

        return attributedString
    }
}

extension String {
    var digits: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
    }
}

extension String {
    var isBlank: Bool {
        return trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

extension String {
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    func isValidID(startNumber: Int, endNumber: Int) -> Bool {
        let range = startNumber...endNumber
        return range.contains(count) ? true : false
    }
    
    func isValidUsername() -> Bool {
        let usernameRegex = "[a-z0-9][a-z0-9.]{4,23}"
        
        let usernamePred = NSPredicate(format: "SELF MATCHES %@", usernameRegex)
        return usernamePred.evaluate(with: self)
    }
    
    func isValidFullName() -> Bool {
        let fullNameRegex = "^[a-zA-Z0-9'\\-\\_\\. ]{4,50}"
        
        let fullNamePred = NSPredicate(format: "SELF MATCHES %@", fullNameRegex)
        return fullNamePred.evaluate(with: self)
    }
}

extension String {
    func getUnerlinedAttributedString() -> NSAttributedString? {
        let attributedString = NSMutableAttributedString(string: self)
        guard let rangeIndex = self.range(of: self) else { return nil }
        let range = NSRange(rangeIndex, in: attributedString.string)
        attributedString.addAttributes([NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue], range: range)
        
        return attributedString
    }
}
