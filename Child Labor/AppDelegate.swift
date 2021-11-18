//
//  AppDelegate.swift
//  Child Labor
//
//  Created by E J Kalafarski on 3/2/15.
//  U.S. Government Work https://www.usa.gov/government-works
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Init Google Analytics
        GAI.sharedInstance().trackUncaughtExceptions = true
        GAI.sharedInstance().dispatchInterval = 20
//        GAI.sharedInstance().logger.logLevel = GAILogLevel.Verbose
        GAI.sharedInstance().tracker(withTrackingId: "UA-61504244-3").set(kGAIAnonymizeIp, value: "1")

        return true
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
    
    @available(iOS 9.0, *)
    //@available(iOS 13.0, *)
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        let navigationController = self.window?.rootViewController as! UINavigationController
        if #available(iOS 13.0, *) {
            decorateActionBar(navigationController: navigationController)
        }
        
        let mainViewController = navigationController.viewControllers[0] as! IndexViewController
        
        navigationController.popToRootViewController(animated: false)
        if shortcutItem.type == "OpenCountries" {
            mainViewController.performSegue(withIdentifier: "countriesSelectedFromIndex", sender: self)
        } else if shortcutItem.type == "OpenGoods" {
            mainViewController.performSegue(withIdentifier: "goodsSelectedFromIndex", sender: self)
        } else if shortcutItem.type == "OpenExploitationTypes" {
            mainViewController.performSegue(withIdentifier: "exploitationSelectedFromIndex", sender: self)
        }
    }
    
    @available(iOS 13.0, *)
    func decorateActionBar(navigationController:UINavigationController){
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 0.0, green: 0.2, blue: 0.33, alpha: 1.0)
        navigationController.navigationBar.standardAppearance = appearance;
        navigationController.navigationBar.scrollEdgeAppearance = navigationController.navigationBar.standardAppearance
        
    }


}

