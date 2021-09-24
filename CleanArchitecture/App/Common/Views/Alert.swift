//
//  Alert.swift
//  NewsApp
//
//  Created by Dinh Quan on 2/4/21.
//

import UIKit

struct Alert {
    func show(title: String? = nil,
              message: String? = nil,
              cancelTitle: String = NSLocalizedString("Ok", comment: ""),
              actionTitle: String? = nil,
              actionHandler: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: cancelTitle,
                                   style: .cancel,
                                   handler: nil)
        alertController.addAction(cancelAction)

        if let actionTitle = actionTitle {
            let action = UIAlertAction(title: actionTitle,
                                       style: .default) {_ in
                actionHandler?()
            }
            alertController.addAction(action)
        }

        UIViewController.top()?.present(alertController, animated: true, completion: nil)
    }
}

private extension UIViewController {
    class func top(controller: UIViewController? = keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return top(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return top(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return top(controller: presented)
        }
        return controller
    }
}

private let keyWindow = UIApplication.shared.keyWindow
