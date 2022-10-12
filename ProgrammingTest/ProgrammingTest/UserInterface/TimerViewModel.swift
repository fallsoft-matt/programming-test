//
//  TimerViewModel.swift
//  ProgrammingTest
//
//  Created by Matthew Faller on 10/12/22.
//

import Foundation

class TimerViewModel {
    
    private var timer: Timer?
    
    func restartTimer() {
        timer?.invalidate()
        
        let isEnabled = UserDefaults.standard.bool(forKey: "timer.isEnabled")
        let timeInterval = UserDefaults.standard.double(forKey: "timer.duration")
        
        if isEnabled {
            timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { timer in
                print("Performing auto-update for weather reports")
                WeatherViewModel.shared.updateReports()
            }
        }
    }
    
    func updateTimerSettings(isEnabled: Bool, duration: TimeInterval) {
        UserDefaults.standard.setValue(isEnabled, forKey: "timer.isEnabled")
        UserDefaults.standard.setValue(duration, forKey: "timer.duration")
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private init() {}
    static let shared = TimerViewModel()
}
