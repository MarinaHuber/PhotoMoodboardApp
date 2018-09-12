

//
//  AppDelegate.swift
//  OdetteNew
//
//  Created by Marina Huber on 18/04/16.
//  Copyright © 2016 xs2. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import SystemConfiguration





@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Fabric.with([Crashlytics.self])
        customizeUI()
        // ********************************************************
        // check for Internet connection on launch
        // ********************************************************
//        if Reachability.isConnectedToNetwork() == true {
//          } else {
//            print("Internet connection FAILED")
//            let alert = UIAlertView(title: "No Internet connection", message: "Make sure your device is connected to the internet.", delegate: nil, cancelButtonTitle: "OK")
//            alert.show()
//        }
//
      return true
 }
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
       
        switch UIDevice().userInterfaceIdiom {
        case UIUserInterfaceIdiom.pad:
           
            return [.landscapeRight, .landscapeLeft]
         default:
            return .portrait
        }

    
    }
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    

}

//UI CUSTOMIZATION
extension AppDelegate {
    
    func customizeUI() {

        UINavigationBar.appearance().barTintColor = UIColor.white
        UINavigationBar.appearance().tintColor = UIColor.black
//        if (UIScreen.mainScreen().bounds.size.height == 568) {
//            [NSForegroundColorAttributeName: Colors.odetteTitle, NSFontAttributeName: UIFont(name: "Servetica-Thin", size: 15)!]
//        }
        
        //add here for iPad and iPhone version
        let isPad = UIDevice().userInterfaceIdiom  == .pad
        
        UINavigationBar.appearance().titleTextAttributes = isPad ? [NSForegroundColorAttributeName: Colors.odetteTitle, NSFontAttributeName: UIFont(name: "Servetica-Thin", size: 25.5)!] : [NSForegroundColorAttributeName: Colors.odetteTitle, NSFontAttributeName: UIFont(name: "Servetica-Thin", size: 24)!]
        if (UIScreen.main.bounds.size.height == 480) {
            [NSForegroundColorAttributeName: Colors.odetteTitle, NSFontAttributeName: UIFont(name: "Servetica-Thin", size: 15)!]
        }
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().layer.shadowColor = UIColor.clear.cgColor


    }
    
}

