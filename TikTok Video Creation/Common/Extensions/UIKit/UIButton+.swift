//
//  UIButton+.swift
//  Fansomnia
//
//  Created by Dino Bozic on 07/09/2020.
//  Copyright © 2020 Speck. All rights reserved.
//

import UIKit

extension UIButton {
    static var buttonDisabledColor: UIColor = .gray235
    
    enum ButtonStyle {
        case primary
        case secondary
    }
    
    func setEnabled(buttonColor: UIColor, textColor: UIColor) {
        isEnabled = true
        backgroundColor = buttonColor
        tintColor = textColor
    }
    
    func setDisabled() {
        isEnabled = false
        backgroundColor = UIButton.buttonDisabledColor
        tintColor = .blackWith04
    }
}
