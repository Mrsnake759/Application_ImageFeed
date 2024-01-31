//
//  UIViewController+Extensions.swift
//  ImageFeed
//
//  Created by artem on 30.01.2024.
//

import Foundation
import UIKit

extension UIViewController {
    static var topViewController: UIViewController? {
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first

        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        }
        return nil
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            alert.dismiss(animated: true)
        }))
        present(alert, animated: true)
    }
}
