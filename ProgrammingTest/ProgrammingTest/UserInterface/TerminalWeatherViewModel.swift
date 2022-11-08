//
//  TerminalWeatherViewModel.swift
//  ProgrammingTest
//
//  Created by Matthew Faller on 10/11/22.
//

import Foundation

class WeatherViewModel {
    
    @Published var weatherReports: [String: WeatherReport] = [:]
       
    func loadReports() async throws {
        let results = try await terminalService.fetchAll()
        
        DispatchQueue.main.async {
            
            var reports: [String: WeatherReport] = [:]
            results.forEach { report in
                reports[report.ident] = report
            }
            self.weatherReports = reports
        }
    }
    
    func delete(report: WeatherReport) async throws {
        let deleted = try await terminalService.delete(identifier: report.ident)
        weatherReports.removeValue(forKey: deleted.ident)
    }
    
    func fetchOrCreate(ident: String) async throws -> WeatherReport {
        if let result = try await terminalService.fetchOne(identifier: ident) {
            weatherReports[result.ident] = result
            return result
        }
        
        let freshReport = try await terminalService.create(identifier: ident)
        weatherReports[freshReport.ident] = freshReport
        return freshReport
    }
    
    func saveContext() {
        terminalService.saveContext()
    }
    
    func updateReports() {
        Task {
            var updatedReports: [String: WeatherReport] = [:]
            do {
                for key in weatherReports.keys {
                    let result = try await terminalService.update(identifier: key)
                    updatedReports[key] = result
                }
            } catch {
                print("Error durring automatic weather update \(error)")
                return
            }
            
            weatherReports = updatedReports
        }
    }
    
    static let shared = WeatherViewModel()
    private init() { }
    private let terminalService = TerminalWeatherService()
}
