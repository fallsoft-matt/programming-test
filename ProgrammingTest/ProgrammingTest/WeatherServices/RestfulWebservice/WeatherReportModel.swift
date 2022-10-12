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
    let forecast: Forecast
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
    let visibility: Visibility
    let wind: Wind
}

internal struct Visibility: Codable {
    let distanceSm: Double
    let prevailingVisSm: Double
}

internal struct Wind: Codable {
    let speedKts: Double
    let direction: Double
    let from: Double
    let variable: Bool
}

internal struct Forecast: Codable {
    let ident: String
    let dateIssued: String
    let period: Period
    let conditions: [WeatherForecastConditions]
}

internal struct Period: Codable {
    let dateStart: String
    let dateEnd: String
}

internal struct WeatherForecastConditions: Codable {
    let dateIssued: String
    let lat: Double
    let lon: Double
    let elevationFt: Double
    let flightRules: String
    let visibility: Visibility
    let wind: Wind
}



/**
 {
     "report": {
         "conditions": {
             "text": "METAR KORL 111953Z AUTO 04007KT 10SM FEW040 SCT048 31/21 A3009 RMK AO2 SLP192 T03060211",
             "ident": "korl",
             "dateIssued": "2022-10-11T19:53:00+0000",
             "lat": 28.545462045672732,
             "lon": -81.33293013013267,
             "elevationFt": 113.0,
             "tempC": 31.0,
             "dewpointC": 21.0,
             "pressureHg": 30.09,
             "pressureHpa": 1019.0068769999999,
             "reportedAsHpa": false,
             "densityAltitudeFt": 2113,
             "relativeHumidity": 55,
             "autonomous": true,
             "flightRules": "vfr",
             "cloudLayers": [
                 {
                     "coverage": "few",
                     "altitudeFt": 4000.0,
                     "ceiling": false
                 },
                 {
                     "coverage": "sct",
                     "altitudeFt": 4800.0,
                     "ceiling": false
                 }
             ],
             "cloudLayersV2": [
                 {
                     "coverage": "few",
                     "altitudeFt": 4000.0,
                     "ceiling": false
                 },
                 {
                     "coverage": "sct",
                     "altitudeFt": 4800.0,
                     "ceiling": false
                 }
             ],
             "weather": [],
             "visibility": {
                 "distanceSm": 10.0,
                 "prevailingVisSm": 10.0
             },
             "wind": {
                 "speedKts": 7.0,
                 "direction": 40,
                 "from": 40,
                 "variable": false
             },
             "remarks": {
                 "precipitationDiscriminator": true,
                 "humanObserver": false,
                 "seaLevelPressure": 1019.2,
                 "temperature": 30.6,
                 "dewpoint": 21.1,
                 "visibility": {},
                 "sensoryStatus": [],
                 "lightning": [],
                 "weatherBeginEnds": {},
                 "clouds": [],
                 "obscuringLayers": []
             }
         },
         "forecast": {
             "text": "KMCO 111739Z 1118/1224 06008KT P6SM SCT030 BKN300 FM112100 06009KT P6SM VCTS SCT035CB BKN060 FM120000 05004KT P6SM SCT025 SCT050 BKN200 FM121400 12004KT P6SM SCT025 BKN200 FM121900 11006KT P6SM VCTS SCT035CB BKN050",
             "ident": "kmco",
             "dateIssued": "2022-10-11T17:39:00+0000",
             "period": {
                 "dateStart": "2022-10-11T18:00:00+0000",
                 "dateEnd": "2022-10-13T00:00:00+0000"
             },
             "lat": 28.429389045487017,
             "lon": -81.30900013009438,
             "elevationFt": 96.0,
             "conditions": [
                 {
                     "text": "111739Z 1118/1224 06008KT P6SM SCT030 BKN300",
                     "dateIssued": "2022-10-11T17:39:00+0000",
                     "lat": 28.429389045487017,
                     "lon": -81.30900013009438,
                     "elevationFt": 96.0,
                     "relativeHumidity": 100,
                     "flightRules": "vfr",
                     "cloudLayers": [
                         {
                             "coverage": "sct",
                             "altitudeFt": 3000.0,
                             "ceiling": false
                         },
                         {
                             "coverage": "bkn",
                             "altitudeFt": 30000.0,
                             "ceiling": true
                         }
                     ],
                     "cloudLayersV2": [
                         {
                             "coverage": "sct",
                             "altitudeFt": 3000.0,
                             "ceiling": false
                         },
                         {
                             "coverage": "bkn",
                             "altitudeFt": 30000.0,
                             "ceiling": true
                         }
                     ],
                     "weather": [],
                     "visibility": {
                         "distanceSm": 6.0,
                         "distanceQualifier": 1,
                         "prevailingVisSm": 6.0,
                         "prevailingVisDistanceQualifier": 1
                     },
                     "wind": {
                         "speedKts": 8.0,
                         "direction": 60,
                         "from": 60,
                         "variable": false
                     },
                     "period": {
                         "dateStart": "2022-10-11T18:00:00+0000",
                         "dateEnd": "2022-10-11T21:00:00+0000"
                     }
                 },
 
 */
