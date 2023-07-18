//
//  MessagePresenter+.swift
//  Fansomnia
//
//  Created by Azzaro on 07/10/2020.
//  Copyright © 2020 Speck. All rights reserved.
//

import UIKit

protocol MessagePresenter {
    func presentNativeMessage(_ message: String,
                              title: String,
                              actionButtonTitle: String,
                              completion: (() -> Void)?)
    
    func presentActionAlertWithCancel(title: String?,
                                      description: String?,
                                      firstButton: String?,
                                      cancelButton: String?,
                                      completion: (() -> Void)?)
}

extension UIViewController: MessagePresenter {
    func presentNativeMessage(_ message: String,
                              title: String = "",
                              actionButtonTitle: String = "Ok",
                              completion: (() -> Void)? = nil)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString(actionButtonTitle, comment: ""), style: .default) { _ in completion?() }
        alertController.addAction(okAction)

        present(alertController, animated: true, completion: nil)
    }
    
    func presentActionAlertWithCancel(title: String?,
                                      description: String?,
                                      firstButton: String?,
                                      cancelButton: String? = "Cancel".localized(),
                                      completion: (() -> Void)? = nil)
    {
        let alertController = UIAlertController(title: title, message: description, preferredStyle: .alert)
        let firstButtonAction = UIAlertAction(title: NSLocalizedString(firstButton ?? "Ok".localized(), comment: ""), style: .default) { _ in completion?() }
        let cancelButton = UIAlertAction(title: NSLocalizedString(cancelButton ?? "Cancel".localized(), comment: ""), style: .cancel) { _ in alertController.dismiss(animated: true) }
        alertController.addAction(cancelButton)
        alertController.addAction(firstButtonAction)

        present(alertController, animated: true, completion: nil)
    }
}
