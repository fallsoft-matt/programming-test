//
//  WeatherAccessManager.swift
//  ProgrammingTest
//
//  Created by Matthew Faller on 10/10/22.
//

import Foundation
import Combine

public class TerminalWeatherService: AsyncWeatherService {
    
    public func create(identifier: String) async throws -> WeatherReport {
        
        let jsonResponse = try await WeatherService.shared.getWeather(identifier: identifier)
        
        let result = Future<WeatherReport, Error> { [weak self] promise in
            
            self?.operationQueue.addOperation {
                
                guard let strongSelf = self else {
                    promise(.failure(PersistenceError.nilWeakReference))
                    return
                }
                
                let report = strongSelf.persistence.createWeatherConditions(from: jsonResponse.report.conditions)
                
                promise(.success(report))
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

    
    private lazy var operationQueue: OperationQueue = {
        let queue = OperationQueue()
        let dispatchQueue = DispatchQueue(label: "PersistenceQueue")
        queue.name = "PersistenceQueue"
        queue.maxConcurrentOperationCount = 1
        queue.underlyingQueue = dispatchQueue
        return queue
    }()
}
