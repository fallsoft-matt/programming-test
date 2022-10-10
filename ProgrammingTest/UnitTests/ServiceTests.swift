//
//
//  Created by Matthew Faller on 10/10/22.
//

import XCTest
@testable import ProgrammingTest

final class ServiceTests: XCTestCase {
        
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testWeatherInfoParsing() async throws {
        
        do {
            let result = try await WeatherService.shared.getWeather(identifier: "kpwm")
            XCTAssertEqual(result.report.conditions.ident, "kpwm")
            
        } catch {
            XCTFail("Unable to retrieve airport weather")
        }
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
