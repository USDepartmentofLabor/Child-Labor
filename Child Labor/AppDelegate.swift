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


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // Init Google Analytics
        GAI.sharedInstance().trackUncaughtExceptions = true
        GAI.sharedInstance().dispatchInterval = 20
//        GAI.sharedInstance().logger.logLevel = GAILogLevel.Verbose
        GAI.sharedInstance().trackerWithTrackingId("UA-61504244-3").set(kGAIAnonymizeIp, value: "1")

        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    @available(iOS 9.0, *)
    func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {
        let navigationController = self.window?.rootViewController as! UINavigationController
        let mainViewController = navigationController.viewControllers[0] as! IndexViewController
        
        navigationController.popToRootViewControllerAnimated(false)
        if shortcutItem.type == "OpenCountries" {
            mainViewController.performSegueWithIdentifier("countriesSelectedFromIndex", sender: self)
        } else if shortcutItem.type == "OpenGoods" {
            mainViewController.performSegueWithIdentifier("goodsSelectedFromIndex", sender: self)
        } else if shortcutItem.type == "OpenExploitationTypes" {
            mainViewController.performSegueWithIdentifier("exploitationSelectedFromIndex", sender: self)
        }
    }


}

