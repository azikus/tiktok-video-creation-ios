//
//  UIViewController+.swift
//  Fansomnia
//
//  Created by Dino Bozic on 24/08/2020.
//  Copyright © 2020 Speck. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func presentNativeMessage(_ message: String, title: String = "", completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default) { _ in completion?() }
        alertController.addAction(okAction)

        present(alertController, animated: true, completion: nil)
    }
    
    func presentError(message: String, withTitle title: String = "Error") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "Dismiss", style: .default) { [weak self] _ in
            self?.becomeFirstResponder()
        }
        alert.addAction(dismiss)
        present(alert, animated: true, completion: nil)
    }
    
    func embedInNavigationController() -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: self)
        navigationController.modalPresentationStyle = .fullScreen

        return navigationController
    }
    
    func getSystemImage(name: String, size: CGFloat) -> UIImage? {
        let buttonImageConfig = UIImage.SymbolConfiguration(pointSize: size)
        return  UIImage(systemName: name, withConfiguration: buttonImageConfig)
    }
}
