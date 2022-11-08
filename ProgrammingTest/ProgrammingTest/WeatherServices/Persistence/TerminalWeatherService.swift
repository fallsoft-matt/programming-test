//
//  WeatherAccessManager.swift
//  ProgrammingTest
//
//  Created by Matthew Faller on 10/10/22.
//

import Foundation
import Combine

/**
 This class facilitates communication between the remote and local storage
 Since we are not making remote changes, this class can only really do so for a single API call (during create)
 */
public class TerminalWeatherService: AsyncWeatherService {
        
    public func create(identifier: String) async throws -> WeatherReport {
        
        let jsonResponse = try await WeatherService.shared.getWeather(identifier: identifier)
        let weatherReport = Weather.fromJsonData(model: jsonResponse.report)
        
        let result = Future<WeatherReport, Error> { [weak self] promise in
            
            self?.operationQueue.addOperation {
                
                do {
                    guard let strongSelf = self else {
                        throw PersistenceError.nilWeakReference
                    }
                    
                    let report = try strongSelf.persistence.createWeatherConditions(from: weatherReport)
                    
                    promise(.success(report))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        
        return try await result.value
    }
    
    public func update(identifier: String) async throws -> WeatherReport {
        let jsonResponse = try await WeatherService.shared.getWeather(identifier: identifier)
        let weatherReport = Weather.fromJsonData(model: jsonResponse.report)
        
        let result = Future<WeatherReport, Error> { [weak self] promise in
            
            self?.operationQueue.addOperation {
                
                do {
                    guard let strongSelf = self else {
                        throw PersistenceError.nilWeakReference
                    }
                    
                    let report = try strongSelf.persistence.updateWeatherConditions(from: weatherReport)
                    
                    promise(.success(report))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        
        return try await result.value
    }
    
    public func fetchOne(identifier: String) async throws -> WeatherReport? {
        
        let result = Future<WeatherReport?, Error> { [weak self] promise in
            
            self?.operationQueue.addOperation {
                do {
                    let report = try self?.persistence.fetch(identifier: identifier)
                    promise(.success(report))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        
        return try await result.value
    }
    
    public func fetchAll() async throws -> [WeatherReport] {
        
        let result = Future<[WeatherReport], Error> { [weak self] promise in
            
            self?.operationQueue.addOperation {
                do {
                    let reports = try self?.persistence.fetchAll() ?? []
                    promise(.success(reports))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        
        return try await result.value
    }
    
    @discardableResult
    public func delete(identifier: String) async throws -> WeatherReport {
        
        let result = Future<WeatherReport, Error> { [weak self] promise in
            
            self?.operationQueue.addOperation {
                /*
                    We would Sync with Server here for deletion as the other
                    part of the operation, if that were a requirement
                 */
                do {
                    guard let strongSelf = self else {
                        throw PersistenceError.nilWeakReference
                    }
                    
                    let report = try strongSelf.persistence.delete(identifier: identifier)
                    promise(.success(report))
                    
                } catch {
                    promise(.failure(error))
                }
            }
        }
        
        return try await result.value
    }
    
    private let persistence: WeatherPersistenceAdapter
    
    public init(persistenceAdapter: WeatherPersistenceAdapter? = nil) {
        
        if let persistenceAdapter = persistenceAdapter {
            self.persistence = persistenceAdapter
        } else {
            self.persistence = CoreDataWeatherPersistence()
        }
    }

    public func saveContext() {
        persistence.saveContext()
    }
    
    private lazy var operationQueue: OperationQueue = {
        let queue = OperationQueue()
        let dispatchQueue = DispatchQueue(label: "PersistenceQueue")
        queue.name = "PersistenceQueue"
        queue.maxConcurrentOperationCount = 1
        queue.underlyingQueue = dispatchQueue
        return queue
    }()
}
