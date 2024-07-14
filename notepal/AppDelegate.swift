//
//  AppDelegate.swift
//  notepal
//
//  Created by ahmad naufal alfakhar on 15/07/24.
//

import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        NotificationCenter.default.post(name: .didReceiveCustomURL, object: url)
        return true
    }
}

extension Notification.Name {
    static let didReceiveCustomURL = Notification.Name("didReceiveCustomURL")
}
