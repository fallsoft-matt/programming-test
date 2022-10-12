//
//
//  Created by Matthew Faller on 10/10/22.
//

import XCTest
@testable import ProgrammingTest

final class PersistenceTests: XCTestCase {
    
    let persistence = CoreDataWeatherPersistence()
        
    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        
        try persistence.fetchAll().forEach { try persistence.delete(identifier: $0.ident)}
    }

    func testEmptyPersistence() throws {
        
        do {
            let result = try persistence.fetchAll().count
            XCTAssertEqual(result, 0)
            
        } catch {
            XCTFail("Error testing persistence")
        }
    }
    
    func testSaveOneItem() {
        do {
            let _ = try persistence.createWeatherConditions(from: jsonWeather1)
            
            let count = try persistence.fetchAll().count
            
            try persistence.fetchAll().forEach { print($0.ident) }
            
            XCTAssertEqual(count, 1)
        } catch {
            XCTFail("Error testing persistence")
        }
    }
    
    func testSaveMultipleItems() {
        do {
            
            let _ = try persistence.createWeatherConditions(from: jsonWeather1)
            let _ = try persistence.createWeatherConditions(from: jsonWeather2)
            let _ = try persistence.createWeatherConditions(from: jsonWeather3)
            
            let count = try persistence.fetchAll().count
            
            try persistence.fetchAll().forEach { print($0.ident) }
            
            XCTAssertEqual(count, 3)
        } catch {
            XCTFail("Error testing persistence")
        }
    }
    
    func testSaveDeleteOneItem() {
        do {
            let result = try persistence.createWeatherConditions(from: jsonWeather1)
            try persistence.delete(identifier: result.ident)
            
            let count = try persistence.fetchAll().count
            
            try persistence.fetchAll().forEach { print($0.ident) }
            
            XCTAssertEqual(count, 0)
        } catch {
            XCTFail("Error testing persistence")
        }
    }
    
    func testSaveFetchOneItem() {
        do {
            let _ = try persistence.createWeatherConditions(from: jsonWeather1)
            let result = try persistence.fetch(identifier: "KPWM")
                        
            XCTAssertNotNil(result)
        } catch {
            XCTFail("Error testing persistence")
        }
    }
    
    lazy var jsonWeather1 = Weather.empty("KPWM")
    
    lazy var jsonWeather2 = Weather.empty("KAUS")
    
    lazy var jsonWeather3 = Weather.empty("KORL")
}

fileprivate extension Weather {
    static func empty(_ ident: String = "KORL") -> Weather {
        return Weather(ident: ident, dateIssued: "", elevationFt: 0, flightRules: "", visibility: "", prevailingVisibility: "", windSpeed: 0, windDirection: 0, windFrom: 0, windVariable: false, forecastDateFrom: "", forecastDateTo: "", forecastElevationFt: 0, forecastFlightRules: "", forecastVisibility: "", forecastPrevailingVisibility: "", forecastWindSpeed: 0, forecastWindDirection: 0, forecastWindFrom: 0, forecastWindVariable: false)
    }
}
