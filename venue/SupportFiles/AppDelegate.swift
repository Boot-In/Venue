//
//  AppDelegate.swift
//  venue
//
//  Created by Dmitriy Butin on 10.05.2020.
//  Copyright © 2020 Dmitriy Butin. All rights reserved.
//

import UIKit
import GoogleMaps
import Firebase
import FirebaseRemoteConfig

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let apiKEY = "AIzaSyCMGq_hOzYVcKMJ-RKyy3QuIB1Hn_7o_Aw" /// Google
    var remoteConfig: RemoteConfig!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        GMSServices.provideAPIKey(apiKEY)
        FirebaseApp.configure()
        
        setRemoteConfigure()
        
        return true
    }
    
    func setRemoteConfigure(){
        remoteConfig = RemoteConfig.remoteConfig()
            /// Значение ключей по умолчанию (офлайн)
        let remoteConfigDefault = [ "defultZoom" : 16 as NSObject,
            "user_admin" : "BZcvM3WVKvbcalW4QEC2MH4y3cw1" as NSObject] ///
        
        remoteConfig.setDefaults(remoteConfigDefault)
        remoteConfig.configSettings.minimumFetchInterval = 0
        
        remoteConfig.fetchAndActivate { (status, error) in
            
            if error != nil {
                print(error?.localizedDescription ?? "No error available.")
            } else {
                guard status != .error else { return }
                let zoom = self.remoteConfig.configValue(forKey: "defultZoom").numberValue as! Int
                let ua = self.remoteConfig.configValue(forKey: "user_admin").stringValue
                DataService.shared.defaultZoom = zoom
                DataService.shared.userAdmin = ua ?? "No admin"
                print("zoom = ", zoom, "Admin: ", DataService.shared.userAdmin)
            }
            
        }
        
//        remoteConfig.fetch(withExpirationDuration: TimeInterval(0)) { (status, error) -> Void in
//            print("remoteConfig.fetch")
//            if status == .success {  // remoteConfig fetched!"
//                NetworkService.shared.defaultZoom = self.remoteConfig.configValue(forKey: "defultZoom").numberValue as! Int
//                print("NetworkService.shared>defaultZoom>", NetworkService.shared.defaultZoom)
//            } else {  //remoteConfig not fetched
//                print("Error: \(error?.localizedDescription ?? "No error available.")")
//            }
//        }
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}

