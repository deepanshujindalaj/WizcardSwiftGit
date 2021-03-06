//
//  AppDelegate.swift
//  Wizcard
//
//  Created by Akash Jindal on 15/02/18.
//  Copyright © 2018 Akash Jindal. All rights reserved.
//

import UIKit
import CoreData
import Fabric
import Crashlytics
import UserNotifications
import IQKeyboardManagerSwift
import TwitterKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    var locationManager : LocationManager!
    var cordinateLocation: CLLocationCoordinate2D!
    static var appDelgate : AppDelegate!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        locationManager = LocationManager(delegate:self)
        locationManager.startUpdatingLocation()
        
        Fabric.with([Crashlytics.self])

        TWTRTwitter.sharedInstance().start(withConsumerKey: "fPTSaC1Zoul1I0pK78sOZLKvv", consumerSecret: "RXJr0er1bLo5XPZjg4yBu1Axp6BlP6EYeuYrfgxHV6oVSUBRuj")
        
        HelperFunction.saveValueInUserDefaults(key: ProfileKeys.deviceID, value: UIDevice.current.identifierForVendor!.uuidString)
        
        registerForPushNotifications()
        
        IQKeyboardManager.shared.enable = true
//        IQKeyboardManager.shared.canAdjustAdditionalSafeAreaInsets = true
        
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(urls[urls.count-1] as URL)
        
        AppDelegate.appDelgate = self
        return true
    
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return TWTRTwitter.sharedInstance().application(app, open: url, options: options)
    }
    
    private func decideViewController()
    {
//        if !HelperFunction.getUserId().isEmpty
//        {
//            let storyBoard = UIStoryboard.init(name: StoryboardNames.main, bundle: nil)
//            let initialViewController = storyBoard.instantiateViewController(withIdentifier: IdentifierName.Main.decideNavigation)
//            self.window = UIWindow(frame: UIScreen.main.bounds)
//            self.window?.rootViewController = initialViewController
//            self.window?.makeKeyAndVisible()
//        }
    }
    
    open class func getAppDelegate() -> AppDelegate{
        return appDelgate
    }
    
    private func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    private func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            print("Permission granted: \(granted)")
            UNUserNotificationCenter.current().delegate = self
            guard granted else { return }
            self.getNotificationSettings()
        }
    }
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        
        let token = tokenParts.joined()
        updateToken(token: token)
        print("Device Token: \(token)")
        
    }
    
    private func updateToken(token : String)
    {
        HelperFunction.saveValueInUserDefaults(key: ProfileKeys.deviceToken, value: token)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "WizcardCore")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext(){
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}


extension AppDelegate : LocationManagerDelegate
{
    func locationDenied() {
        
    }
    
    func didChangeinLocation(cordinate: CLLocationCoordinate2D){
        cordinateLocation = cordinate
        locationManager.stopUpdatingLocation()
    }
    
    func didErrorinLocation(error: Error) {
        locationManager.stopUpdatingLocation()
    }
    
    func locationNotAvailable() {
        DispatchQueue.main.async {
            
        }
    }
    func locationFaliedToUpdate(status: CLAuthorizationStatus) {
        DispatchQueue.main.async {
            
        }
    }
    
}

