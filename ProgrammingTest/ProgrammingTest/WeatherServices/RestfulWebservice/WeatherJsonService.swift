//
//  WeatherService.swift
//  ProgrammingTest
//
//  Created by Matthew Faller on 10/10/22.
//

import Foundation
import Alamofire
import Combine

/**
 A service that fetches from weather data for a given airport
 */
internal class WeatherService {

    internal static let shared = WeatherService()
    
    internal func getWeather(identifier: String) async throws -> TerminalWeatherInformationModel {
        let url = urlRoute + identifier
        
        return try await session.request(url, headers: headers).validate()
            .serializingDecodable(TerminalWeatherInformationModel.self)
            .result
            .get()
    }
    
    private let session: Session
    private let headers: HTTPHeaders = ["ff-coding-exercise": "1"]
    private let urlRoute = "https://qa.foreflight.com/weather/report/"
        
    private init() {
        // This sort of session manager is where normally more advanced behavior
        // like request interceptors for authentication or logging would be added
        session = Session()
    }
}
