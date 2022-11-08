//
//
//  Created by Matthew Faller on 10/10/22.
//

import XCTest
@testable import ProgrammingTest

final class TerminalWeatherServiceTests: XCTestCase {
    
    let service = TerminalWeatherService()
    
    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        let semaphore = DispatchSemaphore(value: 1)
        Task {
            let reportsForDeletion = try await service.fetchAll()
            for report in reportsForDeletion {
                try await service.delete(identifier: report.ident)
            }
            semaphore.signal()
        }
        semaphore.wait()
    }

    func testSaveItem() async throws {

        do {
            let result = try await service.create(identifier: "KPWM")
            XCTAssertEqual(result.ident, "kpwm")

        } catch {
            XCTFail("Error testing persistence service")
        }
    }

    func testCreateFetchItem() async throws {
        do {
            let result = try await service.create(identifier: "KPWM")

            let count = try await service.fetchAll().count

            XCTAssertEqual(count, 1)
        } catch {
            XCTFail("Error testing persistence")
        }
    }
    
    func testSaveDeleteOneItem() async throws {
        do {
            let result = try await service.create(identifier: "KPWM")
            let deleted = try await service.delete(identifier: result.ident)
            let count = try await service.fetchAll().count
            
            XCTAssertEqual(count, 0)
        } catch {
            XCTFail("Error testing persistence \(error)")
        }
    }

    
}
