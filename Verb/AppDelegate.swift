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
class AppDelegate: UIResponder, UIApplicationDelegate, UIAlertViewDelegate {

  var window: UIWindow?
  var apiToken: String?
  var hostname = "http://development.verb.social"
  var application: UIApplication?

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
    self.application = application
    // init HockeyApp SDK
    BITHockeyManager.sharedHockeyManager().configureWithIdentifier("c6cfa89029481683c21c38653c10e61f")
    BITHockeyManager.sharedHockeyManager().startManager()
    BITHockeyManager.sharedHockeyManager().authenticator.authenticateInstallation()

    // Set the logo and custom font
    if let font = UIFont(name: "verb-logo", size: 32.0) {
      UINavigationBar.appearance().titleTextAttributes = [
        NSFontAttributeName: font,
        NSForegroundColorAttributeName: UIColor.whiteColor()
      ]
    }

    // Whenever a person opens the app, check for a cached session
    if (hasCachedFacebookSession()) {
      NSLog("Found a cached session")
      // If there's one, just open the session silently, without showing the user the login UI                       closure: { (apiToken: String) -> Void in
      //FBSession.openActiveSessionWithReadPermissions(["public_profile"], allowLoginUI:false, completionHandler: { (session:FBSession?, state:FBSessionState, error: NSError?) -> Void in
      //  self.sessionStateChanged(session, state: state, error: error)
      //})

      FBSession.openActiveSessionWithReadPermissions(["public_profile"], allowLoginUI: false, completionHandler: facebookSessionStateChanged)

      // If there's no cached session, we will show a login button
    }
    else if (hasValidFacebookSession()) {
      NSLog("Has a session already")
    }
    else {
      NSLog("there's no cached session and not current session")
      // UIButton *loginButton = [self.customLoginViewController loginButton];
      // [loginButton setTitle:@"Log in with Facebook" forState:UIControlStateNormal];
    }


    // // FB SDK
    // FBLoginView.self
    // FBProfilePictureView.self
    //
    // FBSession.openActiveSessionWithAllowLoginUI(false)
    //
    // if hasValidFacebookSession() {
    //   // We need to login before we change to the main storyboard.
    //   login({
    //     println("AppDelegate::login() last closure before storyboard switch")
    //     registerForPushNotifications()
    //     self.changeStoryBoard("Main")
    //   })
    // }
    // else {
    //   changeStoryBoard("Login")
    // }

    return true
  }

  func facebookSessionStateChanged(session: FBSession?, state: FBSessionState, error: NSError?) {
    NSLog("Session State Changed")
    // If the session was opened successfully
    if (error == nil && state == FBSessionState.Open){
      NSLog("Session opened");
      // Show the user the logged-in UI
      userLoggedIn()
      return
    }
    if (state == FBSessionState.Closed || state == FBSessionState.ClosedLoginFailed){
      // If the session is closed
      NSLog("Session closed");
      // Show the user the logged-out UI
      userLoggedOut()
    }

    // Handle errors
    if (error != nil){
      NSLog("Error");
      var alertText: String
      var alertTitle: String
      // If the error requires people using an app to make an action outside of the app in order to recover
      if (FBErrorUtility.shouldNotifyUserForError(error)){
        alertTitle = "Something went wrong"
        alertText = FBErrorUtility.userMessageForError(error)
        NSLog(alertText)
        showMessage(alertText, title: alertTitle)
      }
      else {
        // If the user cancelled login, do nothing
        if (FBErrorUtility.errorCategoryForError(error) == FBErrorCategory.UserCancelled  ) {
          NSLog("User cancelled login");

          // Handle session closures that happen outside of the app
        }
        else if (FBErrorUtility.errorCategoryForError(error) == FBErrorCategory.AuthenticationReopenSession){
          alertTitle = "Session Error"
          alertText = "Your current session is no longer valid. Please log in again."
          showMessage(alertText, title: alertTitle)


          // For simplicity, here we just show a generic message for all other errors
          // You can learn how to handle other errors using our guide: https://developers.facebook.com/docs/ios/errors
        }
        else {
          //Get more error information from the error
          var errorInfo = error!.userInfo
          //var errorInformation = errorInfo?.values. ["com.facebook.sdk:ParsedJSONResponseKey"]["body"]["error"]
          //var errorInformation = [[[error!.userInfo["com.facebook.sdk:ParsedJSONResponseKey"]].objectForKey("body")].objectForKey("error")]
          //var errorMessage = errorInformation.objectForKey("message")

          // Show the user an error message
          alertTitle = "Something went wrong"
          alertText = "Please retry. \n\n If the problem persists contact us and mention this error code: \(errorInfo)"
          showMessage(alertText, title: alertTitle)
        }
      }
      // Clear this token
      FBSession.activeSession().closeAndClearTokenInformation()
      // Show the user the logged-out UI
      userLoggedOut()
    }
  }

  func showMessage(message: String, title: String){
    NSLog("=============================")
    NSLog("ALERT MESSAGE")
    NSLog("=============================")
    NSLog("Title: \(title)")
    NSLog("Message: \(message)")
    NSLog("=============================")

    UIAlertView(title: title, message: message, delegate: self, cancelButtonTitle: "OK!").show()
  }

  func userLoggedOut() {
    // Confirm logout message
    showMessage("You're now logged out via Facebook", title:"")
  }

  // Show the user the logged-in UI
  func userLoggedIn() {
    // Welcome message
    showMessage("You're now logged in via Facebook, logging into Verb API", title: "Welcome!")
    login({
      println("AppDelegate::login() last closure before storyboard switch")
      self.registerForPushNotifications()
      self.changeStoryBoard("Main")
    })
  }

  func logout() {
    var activeSession = FBSession.activeSession()
    activeSession.closeAndClearTokenInformation()
    changeStoryBoard("Login")
  }

  func login(closure: () -> ()) {
    println("AppDelegate::login()")
    // Log into the API, backend will update the user's token if needed.
    VerbAPI.Login(self.hostname, accessToken: getFacebookAccessToken(), closure: { (apiToken: String) -> Void in
      self.apiToken = apiToken
      println("AppDelegate::login() Closure with apiToken")
      println(apiToken)
      // Preload Some Data
      CategoryFactory.All()
      FriendFactory.All()

      closure()
    })
  }

  func hasCachedFacebookSession() -> Bool {
    return FBSession.activeSession().state == FBSessionState.CreatedTokenLoaded
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
    return VerbAPI(hostname: self.hostname, apiToken: self.apiToken!)
  }

  func registerForPushNotifications() {
    var types: UIUserNotificationType = UIUserNotificationType.Badge | UIUserNotificationType.Sound | UIUserNotificationType.Alert
    var settings: UIUserNotificationSettings = UIUserNotificationSettings(forTypes: types, categories: nil)
    self.application!.registerUserNotificationSettings(settings)
    self.application!.registerForRemoteNotifications()
  }

  func application(application: UIApplication, openURL url: NSURL, sourceApplication: NSString?, annotation: AnyObject) -> Bool {
    return FBSession.activeSession().handleOpenURL(url)
    //var wasHandled:Bool = FBAppCall.handleOpenURL(url, sourceApplication: sourceApplication)
    //return wasHandled
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
    FBAppCall.handleDidBecomeActive()
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
