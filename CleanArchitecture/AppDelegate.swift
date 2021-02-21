//
//  AppDelegate.swift
//  CleanArchitecture
//
//  Created by Dinh Quan on 2/21/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        setUpRootView()
        configUI()

        return true
    }

    private func setUpRootView() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = Storyboard.load(.main, type: UINavigationController.self, isInitial: true)

        let articleNavigator = ArticleNavigator(navigationController: navigationController)
        articleNavigator.showArticles()

        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        self.window = window
    }

    private func configUI() {
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }

        UINavigationBar.appearance().barTintColor = Color.main
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
    }
}

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        register {
            ArticleRepository() as ArticleUseCase
        }
    }
}
