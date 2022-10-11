//
//  WeatherPersistence.swift
//  ProgrammingTest
//
//  Created by Matthew Faller on 10/11/22.
//

import Foundation

/// Abstracts placing weather objects into and out of the whatever persistence layer is decided
public protocol WeatherPersistenceAdapter {
    /**
    Create a new object to be saved in the database
            
     
    - Parameter conditions: The new weather report to convert and save
    - Returns:A copy of the newly created object
     */
    func createWeatherConditions(from conditions: WeatherReport) -> WeatherReport
    
    /**
     Retrieve all items from storage
     
      - Returns: The list of weather reports
     */
    func fetchAll() throws -> [WeatherReport]
    
    /**
     Removes a single item from storage
     
      - Parameter identifier: The airport identifier for the report to delete
     */
    @discardableResult
    func delete(identifier: String) throws -> WeatherReport
    
    /**
     Removes a single item from storage
     
      - Parameter identifier: The airport identifier for the report to delete
      - Returns: The weather report, or nil if the report is not found
     */
    func fetch(identifier: String) throws -> WeatherReport?
}

/**
 A protocol for making asynconous calls to a server and persistence layer
 
 A history of function calls using this protocol must adhere to sequential consistency
 */
public protocol AsyncWeatherService {
    
    func create(identifier: String) async throws -> WeatherReport
    func fetchOne(identifier: String) async throws -> WeatherReport?
    func fetchAll() async throws -> [WeatherReport]
    
    @discardableResult
    func delete(identifier: String) async throws -> WeatherReport
}

/// An protocol for representing a weather report
public protocol WeatherReport {
    
    var ident: String { get }
    var dateIssued: String { get }
    var lat: Double { get }
    var lon: Double { get }
    var elevationFt: Double { get }
    var densityAltitudeFt: Double { get }
    var flightRules: String { get }
}

// Note: Using these JSON models here is just for brevity
// Normally we'd probably not use them directly as our implementation like we are here
extension WeatherConditionsModel: WeatherReport { }
