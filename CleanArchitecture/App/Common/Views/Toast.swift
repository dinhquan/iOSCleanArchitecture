//
//  Toast.swift
//  NewsApp
//
//  Created by Dinh Quan on 2/4/21.
//

import UIKit

struct Toast {
    static func show(_ text: String, duration: Double = 2) {
        let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first

        let view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 44))
        view.backgroundColor = UIColor(white: 0, alpha: 0.75)
        view.layer.cornerRadius = 10
        let label = UILabel(frame: CGRect(x: 13, y: 0, width: view.bounds.width - 30, height: view.bounds.height))
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.text = text
        view.addSubview(label)

        guard let window = keyWindow else { return }
        view.center = CGPoint(x: window.center.x, y: window.center.y + window.bounds.height/2 - 80)
        view.alpha = 0
        window.addSubview(view)
        UIView.animate(withDuration: 0.2) {
            view.alpha = 1
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            UIView.animate(withDuration: 0.2, animations: {
                view.alpha = 0
            }, completion: { _ in
                view.isHidden = true
                view.removeFromSuperview()
            })
        }
    }
}
