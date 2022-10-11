//
//  ProgrammingTestTests.swift
//  ProgrammingTestTests
//
//  Created by Matthew Faller on 10/10/22.
//

import XCTest
@testable import ProgrammingTest

final class ParsingTests: XCTestCase {
    
    let jsonDecoder = JSONDecoder()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testWeatherInfoParsing() throws {
        
        do {
            let _ = try jsonDecoder.decode(TerminalWeatherInformationModel.self, from: weatherReportTestInput)
        } catch {
            XCTFail()
        }
        
    }
    
    func testWeatherConditionParsing() throws {
        
        do {
            let _ = try jsonDecoder.decode(WeatherConditionsModel.self, from: weatherConditionsTestInput)
        } catch {
            XCTFail()
        }
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

fileprivate let weatherReportTestInput = """
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
        }
    }
}
""".data(using: .utf8)!

fileprivate let weatherConditionsTestInput = """
{
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
}
""".data(using: .utf8)!
