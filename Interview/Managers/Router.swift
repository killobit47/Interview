//
//  Router.swift
//  Interview
//
//  Created by Developer on 7/30/18.
//  Copyright © 2018 Roman Ganzha. All rights reserved.
//

import UIKit

enum Segue {    
    enum splashViewSegue: String {
        case toHomeView = "splashView.toHomeView"
        case toLoginView = "splashView.toLoginView"
    }
    enum loginSegue:String {
        case toSignUp = "login.toSignUp"
        case toGallery = "login.toGallery"
    }
    enum siginSegue: String {
      case toGallery = "sigin.toGallery"
    }
    enum gallerySegue: String {
        case toAddNewImage = "gallery.toAddNewImage"
        case toViewGif = "gallery.toViewGif"
        case toViewImage = "gallery.toViewImage"
    }
}

protocol Router {}

extension Router {
    
    typealias completion = () -> Void
    
    var topViewController: UIViewController {
        guard var topController = UIApplication.shared.keyWindow?.rootViewController else {
            fatalError("can not get root ViewController")
        }
        while let presentedViewController = topController.presentedViewController {
            topController = presentedViewController
        }
        return topController
    }

    func show(viewController: UIViewController, animated: Bool, completion: (completion)? = nil) {
        topViewController.present(viewController, animated: animated, completion: completion)
    }
    
    func hide(animated: Bool, completion: (completion)? = nil) {
        topViewController.dismiss(animated: animated, completion: completion)
    }
    
    func openApplicationSettings() {
        if let url = URL(string: UIApplicationOpenSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
    
    func openApplicationSettingsWithAlert(message:String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            self.openApplicationSettings()
        }))
        self.show(viewController: alert, animated: true)
    }
    
    func lounchSplashView() {
        APIManager.clearToken()
        let sViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SplashViewController")
        topViewController.present(sViewController, animated: true, completion: nil)
    }
}

class RoutManager: Router {
    
    static let shared = RoutManager()
    
}
