//
//  DetailWeatherView.swift
//  ProgrammingTest
//
//  Created by Matthew Faller on 10/12/22.
//

import Foundation
import UIKit
import Combine

class WeatherDetailViewController: UIViewController {
    
    @IBOutlet private weak var timeRange: UILabel!
    @IBOutlet private weak var elevation: UILabel!
    @IBOutlet private weak var flightRules: UILabel!
    @IBOutlet private weak var visibility: UILabel!
    @IBOutlet private weak var prevailingVisibility: UILabel!
    @IBOutlet private weak var windSpeed: UILabel!
    @IBOutlet private weak var windDirection: UILabel!
    @IBOutlet private weak var windFrom: UILabel!
    @IBOutlet private weak var windVariable: UILabel!
    
    private var isForecast: Bool = false
    
    private var sub: AnyCancellable?
    private var weatherData: [String: WeatherReport] = [:] {
        didSet {
            updateUI()
        }
    }
    
    var targetAirportIdentifier: String = ""
    
    override func viewDidLoad() {
        title = targetAirportIdentifier.uppercased()
        
        sub = WeatherViewModel.shared.$weatherReports
            .receive(on: DispatchQueue.main)
            .assign(to: \.weatherData, on: self)
        
        weatherData = WeatherViewModel.shared.weatherReports
    }
    
    @IBAction private func switchDidChange(sender: UISegmentedControl) {
        isForecast = sender.selectedSegmentIndex == 1
        updateUI()
    }
    
    private func updateUI() {
        guard let report = weatherData[targetAirportIdentifier] else {
            print("No report available for airport")
            return
        }
        
        if isForecast {
            updateForecast(with: report)
        } else {
            updateCurrentWeather(with: report)
        }
    }
    
    private func updateCurrentWeather(with report: WeatherReport) {
        
        timeRange.text = hoursMinutes(from: report.dateIssued)
        elevation.text = "\(report.elevationFt) ft"
        flightRules.text = report.flightRules
        visibility.text = report.visibility
        prevailingVisibility.text = report.prevailingVisibility
        windSpeed.text = report.windSpeed.formatted(decimalFormat)
        windDirection.text = report.windDirection.formatted(decimalFormat)
        windFrom.text = report.windFrom.formatted(decimalFormat)
        windVariable.text = report.windVariable ? "YES" : "NO"
    }
    
    private func updateForecast(with report: WeatherReport) {
        timeRange.text = forecastTimeRange(from: report)
        elevation.text = "\(report.forecastElevationFt) ft"
        flightRules.text = report.forecastFlightRules
        visibility.text = report.forecastVisibility
        prevailingVisibility.text = report.forecastPrevailingVisibility
        windSpeed.text = report.forecastWindSpeed.formatted(decimalFormat)
        windDirection.text = report.forecastWindDirection.formatted(decimalFormat)
        windFrom.text = report.forecastWindFrom.formatted(decimalFormat)
        windVariable.text = report.forecastWindVariable ? "YES" : "NO"
    }
    
    private func forecastTimeRange(from report: WeatherReport) -> String {
        let start = hoursMinutes(from: report.forecastDateFrom)
        let end = hoursMinutes(from: report.forecastDateTo)
        
        return "\(start) to \(end)"
    }
    
    private func hoursMinutes(from dateString: String) -> String {
        guard let date = formatter.date(from: dateString) else {
            print("Unable to parse 8601 date string")
            return dateString
        }
        
        return dateTime.string(from: date)
    }
    
    private lazy var formatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        return formatter
    }()
    
    private lazy var timeOnly: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    private lazy var dateTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "(MMM dd) HH:mm"
        return formatter
    }()
    
    private let decimalFormat = FloatingPointFormatStyle<Double>.number.precision(.significantDigits(2))
}
