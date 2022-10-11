//
//  WeatherPersistence.swift
//  ProgrammingTest
//
//  Created by Matthew Faller on 10/10/22.
//

import Foundation
import CoreData

/**
 An implementation of our persistence adapter using CoreData
 */
internal class CoreDataWeatherPersistence: WeatherPersistenceAdapter {
    
    internal func createWeatherConditions(from conditions: WeatherReport) -> WeatherReport {
        
        return persistentContainer.viewContext.performAndWait {
            let weather = WeatherConditions(context: persistentContainer.viewContext)
            weather.ident = conditions.ident
            weather.dateIssued = conditions.dateIssued
            weather.densityAltitudeFt = conditions.densityAltitudeFt
            weather.flightRules = conditions.flightRules
            weather.elevationFt = conditions.elevationFt
            weather.lat = conditions.lat
            weather.lon = conditions.lon
            
            return WeatherConditionsModel.fromCoreData(object: weather)
        }
    }
    
    internal func fetchAll() throws -> [WeatherReport] {
        let results: [WeatherConditions] = try fetchAll()
        return results.map(WeatherConditionsModel.fromCoreData)
    }
    
    internal func fetch(identifier: String) throws -> WeatherReport? {
        let result: WeatherConditions? = try fetch(identifier: identifier)
        return result.map(WeatherConditionsModel.fromCoreData)
    }
    
    @discardableResult
    internal func delete(identifier: String) throws -> WeatherReport {
        
        guard let result: WeatherConditions = try fetch(identifier: identifier) else {
            throw PersistenceError.objectNotFound
        }
        
        let report = WeatherConditionsModel.fromCoreData(object: result)
        delete(object: result)
        return report
    }
    
    private func fetchAll() throws -> [WeatherConditions] {
        
        return try persistentContainer.viewContext.performAndWait {
            let request = NSFetchRequest<WeatherConditions>(entityName: "WeatherConditions")
            return try persistentContainer.viewContext.fetch(request)
        }
    }
    
    private func delete(object: WeatherConditions) {
        persistentContainer.viewContext.performAndWait {
            persistentContainer.viewContext.delete(object)
        }
    }
    
    private func fetch(identifier: String) throws -> WeatherConditions? {
        let request = WeatherConditions.fetchRequest()
        request.predicate = NSPredicate(format: "ident == %@", identifier)
        
        return try persistentContainer.viewContext.performAndWait {
            return try persistentContainer.viewContext.fetch(request).first
        }
    }
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ProgrammingTest")
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

fileprivate extension WeatherReport {
    static func fromCoreData(object: WeatherConditions) -> WeatherReport {
        
        return WeatherConditionsModel(
            text: "",
            ident: object.ident ?? "",
            dateIssued: object.dateIssued ?? "",
            lat: object.lat,
            lon: object.lon,
            elevationFt: object.elevationFt,
            tempC: 0.0, // TODO: Detail
            dewpointC: 0.0,
            pressureHg: 0.0,
            pressureHpa: 0.0,
            reportedAsHpa: false,
            densityAltitudeFt: object.densityAltitudeFt,
            relativeHumidity: 0.0,
            flightRules: object.flightRules ?? "")
    }
}
