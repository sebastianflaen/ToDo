//
//  AppDelegate.swift
//  ToDo
//
//  Created by Sebastian Sundet Flaen on 18/06/2019.
//  Copyright © 2019 ssflaen. All rights reserved.
//

import UIKit
import RealmSwift
//laster ned realm gjennom cocoaPods, husk å åpne den hvite
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        print(Realm.Configuration.defaultConfiguration.fileURL)
        //location to realm
        
       
        do {
            _ = try Realm()
            
        } catch {
            print("error")
        }
        
        return true
    }
}

