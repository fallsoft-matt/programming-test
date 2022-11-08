//
//  WeatherPersistence.swift
//  ProgrammingTest
//
//  Created by Matthew Faller on 10/11/22.
//

import Foundation

/*
 
 Think of these protocols and structs and being the "Public API" of a Library
 
 */

/// Abstracts placing weather objects into and out of the whatever persistence layer is decided
public protocol WeatherPersistenceAdapter {
    /**
    Create a new object to be saved in the database
            
     
    - Parameter conditions: The new weather report to convert and save
    - Returns:A copy of the newly created object
     */
    func createWeatherConditions(from conditions: WeatherReport) throws -> WeatherReport
    
    /**
        Updates a single weather report and saves it
     
        - Parameter conditions: The weather report to update / save
        - Returns: A copy of the object that was just saved
     */
    func updateWeatherConditions(from conditions: WeatherReport) throws -> WeatherReport
    
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
    
    /**
    Saves the state of the data layer
     */
    
    func saveContext()
}

/**
 A protocol for making asynconous calls to a server and persistence layer
 
 A history of function calls using this protocol must adhere to sequential consistency
 */
public protocol AsyncWeatherService {
    
    /**
        Asyncronously create a new airport from the remote server, stores on device
     - Parameter identifier: The four letter ID for the airport
     - Returns: The newly created airport
     */
    func create(identifier: String) async throws -> WeatherReport
    
    /**
        Asyncronously updates an airport from the newest remote data, then updates the local device
     - Parameter identifier: The four letter ID for the airport
     - Returns: The newly updated airport
     */
    func update(identifier: String) async throws -> WeatherReport
    
    /**
        Fetches single report on device for the given airport
     - Parameter identifier: The four letter ID for the airport
     - Returns: The retrieved airport, if available
     */
    func fetchOne(identifier: String) async throws -> WeatherReport?
    
    /**
        Fetches all reports saved on device
     - Returns: The list of airports
     */
    func fetchAll() async throws -> [WeatherReport]
    
    /**
        Deletes a report from the local database
     - Parameter identifier: The four letter ID for the airport
     - Returns: The report that has been deleted
     */
    @discardableResult
    func delete(identifier: String) async throws -> WeatherReport
    
    /**
       Persists any remaining context changes
     */
    func saveContext()
}

/// A protocol for abstracting a weather report
public protocol WeatherReport {
    
    var ident: String { get }
    var dateIssued: String { get }
    var elevationFt: Double { get }
    var flightRules: String { get }
   
    var visibility: String { get }
    var prevailingVisibility: String  { get }
    
    var windSpeed: Double  { get }
    var windDirection: Double  { get }
    var windFrom: Double  { get }
    var windVariable: Bool  { get }
    
    var forecastDateFrom: String  { get }
    var forecastDateTo: String  { get }
    var forecastElevationFt: Double  { get }
    var forecastFlightRules: String  { get }
    var forecastVisibility: String  { get }
    var forecastPrevailingVisibility: String  { get }
    var forecastWindSpeed: Double  { get }
    var forecastWindDirection: Double  { get }
    var forecastWindFrom: Double  { get }
    var forecastWindVariable: Bool  { get }
}

/// A simple struct for holding fields
internal struct Weather: WeatherReport {
    
    public let ident: String
    public let dateIssued: String
    public let elevationFt: Double
    public let flightRules: String
    
    public let visibility: String
    public let prevailingVisibility: String
    
    public let windSpeed: Double
    public let windDirection: Double
    public let windFrom: Double
    public let windVariable: Bool
    
    public let forecastDateFrom: String
    public let forecastDateTo: String
    public let forecastElevationFt: Double
    public let forecastFlightRules: String
    public let forecastVisibility: String
    public let forecastPrevailingVisibility: String
    public let forecastWindSpeed: Double
    public let forecastWindDirection: Double
    public let forecastWindFrom: Double
    public let forecastWindVariable: Bool
}

