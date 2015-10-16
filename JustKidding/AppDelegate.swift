//
//  AppDelegate.swift
//  JustKidding
//
//  Created by Henok Weldemicael on 3/15/15.
//  Copyright (c) 2015 Henok WeldeMicael. All rights reserved.
//

import UIKit
import Parse


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        application.statusBarHidden = false
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        let navigationBarAppearace = UINavigationBar.appearance()
        // change navigation item title color
        navigationBarAppearace.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        
        
        Parse.setApplicationId("65TYBuSV4wiiTh2mdfzimCJ1ytilJ1BQVdGjkv7Z", clientKey: "hy2WGSKdIY7hOl4v2ralS0nTfnlUnbjpj2FyOEps")
        
        let notificationTypes:UIUserNotificationType = [UIUserNotificationType.Alert, UIUserNotificationType.Badge, UIUserNotificationType.Sound]
        
        let notificationSettings:UIUserNotificationSettings = UIUserNotificationSettings(forTypes: notificationTypes, categories: nil)
        
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
        
//        
//        PFInstallation *currentInstallation = [PFInstallation currentInstallation];
//        
//        [currentInstallation addUniqueObject:@"Hi" forKey:@"channels"];
//        [currentInstallation saveInBackground];
        
      
        
        //PFFacebookUtils.initializeFacebook()
        
        
        return true
    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        UIApplication.sharedApplication().registerForRemoteNotifications()
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        
        let currentInstallation:PFInstallation = PFInstallation.currentInstallation()
        currentInstallation.addUniqueObject("newJokes", forKey: "channels")
        currentInstallation.addUniqueObject(PFUser.currentUser()!, forKey: "user")
        currentInstallation.setDeviceTokenFromData(deviceToken)
        currentInstallation.saveInBackgroundWithBlock { (bool:Bool, error:NSError?) -> Void in
            
            if(error == nil){
                print("Installation saved in appDelegate")
            }else{
                print("Installation did not save in appDelegate")
            }
            
        }
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print(error.localizedDescription)
    }
    
    
//    func application(application: UIApplication, didReceiveRemoteNotification userInfo:NSDictionary!) {
//        
//       
//        
//        
//    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        
//        var notification:NSDictionary = userInfo.objectForKey("aps") as! NSDictionary
//        
//        if notification.objectForKey("content-available"){
//            if notification.objectForKey("content-available")?.isEqualToNumber(1){
//                NSNotificationCenter.defaultCenter().postNotificationName("sendNewOnStage", object: nil)
//            }
//        }else{
//            
//            
//            PFPush.handlePush(userInfo)
//            
//      }
        
        
        //var notification = [userInfo["aps"]?["content-available"]] as? Int
        let notification = ((userInfo["aps"] as? NSDictionary) ?? NSDictionary())["content-available"] as? Int
        
    
        
        if (notification != nil){
            
            if notification == 1{
                NSNotificationCenter.defaultCenter().postNotificationName("sendNewOnStage", object: nil)
            }
            
        }else{
            
            PFPush.handlePush(userInfo)
            
            
        }
        
    }
    
    
//    
//    func application(application: UIApplication,
//        openURL url: NSURL,
//        sourceApplication: String?,
//        annotation: AnyObject?) -> Bool {
//            return FBAppCall.handleOpenURL(url, sourceApplication:sourceApplication,
//                withSession:PFFacebookUtils.session())
//    }
    
   
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
        //FBAppCall.handleDidBecomeActiveWithSession(PFFacebookUtils.session())
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

