//
//  WeatherReport.swift
//  ProgrammingTest
//
//  Created by Matthew Faller on 10/10/22.
//

import Foundation

internal struct TerminalWeatherInformationModel: Codable {
    let report: WeatherReportModel
}

internal struct WeatherReportModel: Codable {
    let conditions: WeatherConditionsModel
}

internal struct WeatherConditionsModel: Codable {
    let text: String
    let ident: String
    let dateIssued: String
    let lat: Double
    let lon: Double
    let elevationFt: Double
    let tempC: Double
    let dewpointC: Double
    let pressureHg: Double
    let pressureHpa: Double
    let reportedAsHpa: Bool
    let densityAltitudeFt: Double
    let relativeHumidity: Double
    let flightRules: String
}

/**
 
 {
     "report": {
         "conditions": {
             "text": "KPWM 091551Z 28012KT 10SM SCT060 SCT200 12/03 A3000 RMK AO2 SLP158 T01170028",
             "ident": "kpwm",
             "dateIssued": "2022-10-09T15:51:00+0000",
             "lat": 43.64564406983302,
             "lon": -70.30861611249378,
             "elevationFt": 76.0,
             "tempC": 12.0,
             "dewpointC": 3.0,
             "pressureHg": 30.0,
             "pressureHpa": 1015.959,
             "reportedAsHpa": false,
             "densityAltitudeFt": -240,
             "relativeHumidity": 54,
             "flightRules": "vfr",
             "cloudLayers": [
 */
