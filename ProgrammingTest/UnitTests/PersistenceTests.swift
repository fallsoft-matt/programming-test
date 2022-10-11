//
//
//  Created by Matthew Faller on 10/10/22.
//

import XCTest
@testable import ProgrammingTest

final class PersistenceTests: XCTestCase {
    
    let persistence = CoreDataWeatherPersistence()
    let jsonWeather = WeatherConditionsModel(
        text: "KPWM 091457Z 0915/1012 26010G20KT P6SM FEW050 BKN250 FM092100 29005KT P6SM SKC",
        ident: "KPWM",
        dateIssued: "2022-10-09T14:57:00+0000",
        lat: 43.64564406983302,
        lon: -70.30861611249378,
        elevationFt: 76.0,
        tempC: 12.0,
        dewpointC: 3.0,
        pressureHg: 30.0,
        pressureHpa: 1015.959,
        reportedAsHpa: false,
        densityAltitudeFt: -240,
        relativeHumidity: 54,
        flightRules: "vfr")
    
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
            let _ = persistence.createWeatherConditions(from: jsonWeather)
            
            let count = try persistence.fetchAll().count
            
            try persistence.fetchAll().forEach { print($0.ident) }
            
            XCTAssertEqual(count, 1)
        } catch {
            XCTFail("Error testing persistence")
        }
    }
    
    func testSaveDeleteOneItem() {
        do {
            let result = persistence.createWeatherConditions(from: jsonWeather)
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
            let _ = persistence.createWeatherConditions(from: jsonWeather)
            let result = try persistence.fetch(identifier: "KPWM")
                        
            XCTAssertNotNil(result)
        } catch {
            XCTFail("Error testing persistence")
        }
    }
}
