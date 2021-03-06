//
//  AppDelegate.swift
//  CourseTracker
//
//  Created by atfelix on 2017-06-09.
//  Copyright © 2017 Adam Felix. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var realm: Realm!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        let migrationBlock: MigrationBlock = { migration, oldSchemaVersion in

            if oldSchemaVersion < 1 {
                migration.enumerateObjects(ofType: Student.className()) { oldObject, newObject in
                    if oldSchemaVersion < 1 {
                        newObject?["athleticEvents"] = List<AthleticEvent>()
                    }
                }
            }

            if oldSchemaVersion < 2 {
                migration.enumerateObjects(ofType: AthleticEvent.className()) { oldObject, newObject in
                    newObject?["studentAttending"] = false
                }
            }
        }

        let config = Realm.Configuration(schemaVersion: 2, migrationBlock: migrationBlock, shouldCompactOnLaunch: { totalBytes, usedBytes in
            return true
        })
        realm = try! Realm(configuration: config)

        window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateInitialViewController() as! ViewController
        viewController.realm = realm
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
        
        return true
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
    }
}
