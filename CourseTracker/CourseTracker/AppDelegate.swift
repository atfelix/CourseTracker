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

//        let defaultRealmPath = Realm.Configuration.defaultConfiguration.fileURL
//        let bundleRealmPath = Bundle.main.resourceURL?.appendingPathComponent("default.realm")
//
//        if let defaultPath = defaultRealmPath?.absoluteString {
//            if !FileManager.default.fileExists(atPath: defaultPath) {
//                try! FileManager.default.copyItem(at: bundleRealmPath!, to: defaultRealmPath!)
//            }
//        }

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
}
