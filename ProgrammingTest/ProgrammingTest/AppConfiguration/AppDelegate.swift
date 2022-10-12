//
//  AppDelegate.swift
//  ProgrammingTest
//
//  Created by Matthew Faller on 10/10/22.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
        
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        loadDefaultAirportsIfNeeded()
        TimerViewModel.shared.restartTimer()
        
        return true
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
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        TimerViewModel.shared.stopTimer()
        WeatherViewModel.shared.saveContext()
    }
    
    private func loadDefaultAirportsIfNeeded() {
        let key = "config.firstLaunch"
        let hasHandledFirstLaunch = UserDefaults.standard.bool(forKey: key)
        
        if hasHandledFirstLaunch {
            return
        }
        
        Task {
            do {
                let _ = try await WeatherViewModel.shared.fetchOrCreate(ident: "KPWM")
                let _ = try await WeatherViewModel.shared.fetchOrCreate(ident: "KAUS")
                
                UserDefaults.standard.set(true, forKey: key)
                
            } catch {
                print("Error loading default airports: \(error)")
            }
        }
        
    }
}

