//
//  Loading.swift
//  NewsApp
//
//  Created by Dinh Quan on 2/4/21.
//

import UIKit

private var loadingView: UIView?

struct Loading {
    static func show(isFull: Bool = false) {
        let keyWindow = UIApplication.shared.keyWindow

        loadingView = UIView(frame: keyWindow?.bounds ?? .zero)
        loadingView?.backgroundColor = UIColor.clear
        if isFull {
            let borderView = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
            borderView.layer.cornerRadius = 10
            if #available(iOS 13.0, *) {
                borderView.backgroundColor = .secondarySystemBackground
            } else {
                borderView.backgroundColor = .white
            }
            borderView.center = loadingView?.center ?? .zero
            loadingView?.addSubview(borderView)
            loadingView?.backgroundColor = UIColor(white: 0, alpha: 0.6)
        }
        var aiView: UIActivityIndicatorView!
        if #available(iOS 13.0, *) {
            aiView = UIActivityIndicatorView(style: .medium)
        } else {
            aiView = UIActivityIndicatorView(style: .gray)
        }
        aiView.tag = 1
        aiView.center = loadingView?.center ?? .zero
        loadingView?.addSubview(aiView)
        keyWindow?.addSubview(loadingView!)
        loadingView?.alpha = 0
        UIView.animate(withDuration: 0.1) {
            loadingView?.alpha = 1
        }
        aiView.startAnimating()
    }

    static func dismiss() {
        guard let aiView = loadingView?.viewWithTag(1) as? UIActivityIndicatorView else { return }
        aiView.stopAnimating()
        loadingView?.removeFromSuperview()
    }
}
