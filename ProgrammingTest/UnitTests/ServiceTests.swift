//
//
//  Created by Matthew Faller on 10/10/22.
//

import XCTest
@testable import ProgrammingTest

final class ServiceTests: XCTestCase {
        

    func testWeatherInfoParsing() async throws {
        
        do {
            let result = try await WeatherService.shared.getWeather(identifier: "kpwm")
            XCTAssertEqual(result.report.conditions.ident, "kpwm")
            
        } catch {
            XCTFail("Unable to retrieve airport weather")
        }
    }
    
}
