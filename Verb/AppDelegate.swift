//
//  AppDelegate.swift
//  Verb
//
//  Created by Jonathan Porta on 8/27/14.
//  Copyright (c) 2014 Jonathan Porta. All rights reserved.
//

import UIKit
import Foundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool{

    var storyBoard: UIStoryboard!

    // Set the logo and custom font
    if let font = UIFont(name: "verb", size: 32.0) {
      UINavigationBar.appearance().titleTextAttributes = [
        NSFontAttributeName: font,
        NSForegroundColorAttributeName: UIColor.whiteColor()
      ]
    }

    // Push Notifications
    var types: UIUserNotificationType = UIUserNotificationType.Badge | UIUserNotificationType.Sound | UIUserNotificationType.Alert
    var settings: UIUserNotificationSettings = UIUserNotificationSettings(forTypes: types, categories: nil)

    application.registerUserNotificationSettings(settings)
    application.registerForRemoteNotifications()

    // FB SDK
    FBLoginView.self
    FBProfilePictureView.self

    FBSession.openActiveSessionWithAllowLoginUI(false)

    if hasValidFacebookSession() {
      didLogin()
      changeStoryBoard("Main")
    }
    else {
      changeStoryBoard("Login")
    }

    return true
  }

  func didLogin() {
    // Log into the API, backend will update the user's token if needed.
    getVerbAPI().doLogin()
    // Preload Some Data
    CategoryFactory.All()
    FriendFactory.All()
  }

  func hasValidFacebookSession() -> Bool {
    var activeSession = FBSession.activeSession()
    return activeSession.isOpen
  }

  func getFacebookAccessToken() -> String {
    var activeSession = FBSession.activeSession()
    var accessToken = ""
    if activeSession.isOpen {
      accessToken = activeSession.accessTokenData.accessToken
    }
    return accessToken
  }

  func getVerbAPI() -> VerbAPI {
    var accessToken = getFacebookAccessToken()
    return VerbAPI(hostname: "http://development.verb.social", accessToken: accessToken)
  }

  func application(application: UIApplication, openURL url: NSURL, sourceApplication: NSString?, annotation: AnyObject) -> Bool{
    var wasHandled:Bool = FBAppCall.handleOpenURL(url, sourceApplication: sourceApplication)
    return wasHandled
  }

  func application(application: UIApplication!, didReceiveRemoteNotification userInfo:NSDictionary!) {
    println("RECEIVED REMOTE PUSH NOTIFICATION")
    NSNotificationCenter.defaultCenter().postNotificationName("reloadActivities", object: nil)
  }

  func application(application: UIApplication!, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData!){
    println("Push Notifications Approved")
    var characterSet: NSCharacterSet = NSCharacterSet(charactersInString: "<>")
    var deviceTokenString: String = (deviceToken.description as NSString).stringByTrimmingCharactersInSet(characterSet).stringByReplacingOccurrencesOfString(" ", withString: "") as String
    if hasValidFacebookSession() {
       getVerbAPI().registerDevice(deviceTokenString)
    }

    println(deviceTokenString)
  }

  func application(application: UIApplication!, didFailToRegisterForRemoteNotificationsWithError error: NSError!){
    println("Push Notifications NOT Approved")
    println(error.localizedDescription)
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

  func changeStoryBoard(name :String) {
    var storyBoard = UIStoryboard(name:name, bundle: nil)
    var viewController: AnyObject! = storyBoard.instantiateInitialViewController() ;
    self.window!.rootViewController = viewController as? UIViewController
  }
}
