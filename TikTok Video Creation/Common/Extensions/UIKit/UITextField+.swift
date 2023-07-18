//
//  UITextField+.swift
//  Fansomnia
//
//  Created by Krešimir Baković on 14/12/2020.
//

import UIKit

extension UITextField {
    func notNilOrEmpty() -> Bool {
        if let text = self.text?.trimmingCharacters(in: .whitespacesAndNewlines), text.isEmpty {
            return false
        } else {
            return true
        }
    }
}
