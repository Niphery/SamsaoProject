//
//  AppDelegate.swift
//  SamsaoTest
//
//  Created by NIE Shanhe on 3/30/16
//  Copyright (c) 2016 Samsao. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    
        if let rootVC = storyBoard.instantiateViewControllerWithIdentifier("mainVC") as? MainVC {
        let navigationVC = UINavigationController(rootViewController: rootVC)
        navigationVC.navigationBar.barTintColor = UIColor(red: 255/255, green: 85/255, blue: 64/255, alpha: 1)
        navigationVC.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
            
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.rootViewController = navigationVC
        self.window?.makeKeyAndVisible()
    }
        
        

        return true
    }
}
