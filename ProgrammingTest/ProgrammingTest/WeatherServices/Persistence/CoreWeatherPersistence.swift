//
//  WeatherPersistence.swift
//  ProgrammingTest
//
//  Created by Matthew Faller on 10/10/22.
//

import Foundation
import CoreData

/*
 
 Many of these classes and structs would either be internal to the Library or completely private
 */

/**
 An implementation of our persistence adapter using CoreData
 */
internal class CoreDataWeatherPersistence: WeatherPersistenceAdapter {
    
    internal func createWeatherConditions(from conditions: WeatherReport) throws -> WeatherReport {
        
        return try persistentContainer.viewContext.performAndWait {
            let weather = WeatherConditions(context: persistentContainer.viewContext)
            weather.ident = conditions.ident
            weather.update(from: conditions)
            
            try persistentContainer.viewContext.save()
            
            return Weather.fromCoreData(object: weather)
        }
    }
    
    internal func updateWeatherConditions(from conditions: WeatherReport) throws -> WeatherReport {
        
        return try persistentContainer.viewContext.performAndWait {
            
            guard let result: WeatherConditions = try fetch(identifier: conditions.ident) else {
                throw PersistenceError.objectNotFound
            }
            result.update(from: conditions)
            try persistentContainer.viewContext.save()
            return Weather.fromCoreData(object: result)
        }
    }

    
    internal func fetchAll() throws -> [WeatherReport] {
        let results: [WeatherConditions] = try fetchAll()
        return results.map(Weather.fromCoreData)
    }
    
    internal func fetch(identifier: String) throws -> WeatherReport? {
        let result: WeatherConditions? = try fetch(identifier: identifier)
        return result.map(Weather.fromCoreData)
    }
    
    @discardableResult
    internal func delete(identifier: String) throws -> WeatherReport {
        
        guard let result: WeatherConditions = try fetch(identifier: identifier) else {
            throw PersistenceError.objectNotFound
        }
        
        let report = Weather.fromCoreData(object: result)
        try delete(object: result)
        return report
    }
    
    private func fetchAll() throws -> [WeatherConditions] {
        
        return try persistentContainer.viewContext.performAndWait {
            let request = NSFetchRequest<WeatherConditions>(entityName: "WeatherConditions")
            return try persistentContainer.viewContext.fetch(request)
        }
    }
    
    private func delete(object: WeatherConditions) throws {
        try persistentContainer.viewContext.performAndWait {
            persistentContainer.viewContext.delete(object)
            try persistentContainer.viewContext.save()
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
        let container = NSPersistentContainer(name: "WeatherPersistence")
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
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

// MARK: Glue Code - I've left these here since they only really have context in this file

fileprivate extension WeatherConditions {
    func update(from object: WeatherReport) {
        dateIssued = object.dateIssued
        elevationFt = object.elevationFt
        flightRules = object.flightRules
        visibility = object.visibility
        prevailingVisibility = object.prevailingVisibility
        windSpeed = object.windSpeed
        windDirection = object.windDirection
        windFrom = object.windFrom
        windVariable = object.windVariable
        forecastDateFrom = object.forecastDateFrom
        forecastDateTo = object.forecastDateTo
        forecastElevationFt = object.forecastElevationFt
        forecastFlightRules = object.forecastFlightRules
        forecastVisibility = object.forecastVisibility
        forecastPrevailingVisibility = object.forecastPrevailingVisibility
        forecastWindSpeed = object.forecastWindSpeed
        forecastWindDirection = object.forecastWindDirection
        forecastWindFrom = object.forecastWindFrom
        forecastWindVariable = object.forecastWindVariable
    }
}

fileprivate extension WeatherReport {
    static func fromCoreData(object: WeatherConditions) -> WeatherReport {
        let defaultValue = "-"
        let result = object.managedObjectContext?.performAndWait {
            
            return Weather(
                ident: object.ident ?? defaultValue,
                dateIssued: object.dateIssued ?? defaultValue,
                elevationFt: object.elevationFt,
                flightRules: object.flightRules ?? defaultValue,
                visibility: object.visibility ?? defaultValue,
                prevailingVisibility: object.prevailingVisibility ?? defaultValue,
                windSpeed: object.windSpeed,
                windDirection: object.windDirection,
                windFrom: object.windFrom,
                windVariable: object.windVariable,
                forecastDateFrom: object.forecastDateFrom ?? defaultValue,
                forecastDateTo: object.forecastDateTo ?? defaultValue,
                forecastElevationFt: object.forecastElevationFt,
                forecastFlightRules: object.forecastFlightRules ?? defaultValue,
                forecastVisibility: object.forecastVisibility ?? defaultValue,
                forecastPrevailingVisibility: object.forecastPrevailingVisibility ?? defaultValue,
                forecastWindSpeed: object.forecastWindSpeed,
                forecastWindDirection: object.forecastWindDirection,
                forecastWindFrom: object.forecastWindFrom,
                forecastWindVariable: object.forecastWindVariable)
        }
        
        return result!
    }
}

internal extension Weather {
    static func fromJsonData(model: WeatherReportModel) -> WeatherReport {
        let conditions = model.conditions
        let forecast = model.forecast
        let forecastConditions = forecast.conditions.first!
        
        let weather = Weather.init(
            ident: conditions.ident,
            dateIssued: conditions.dateIssued,
            elevationFt: conditions.elevationFt,
            flightRules: conditions.flightRules,
            visibility: "\(conditions.visibility.distanceSm) sm",
            prevailingVisibility: "\(conditions.visibility.prevailingVisSm) sm",
            windSpeed: conditions.wind.speedKts,
            windDirection: conditions.wind.direction ?? 0,
            windFrom: conditions.wind.direction ?? 0,
            windVariable: conditions.wind.variable,
            forecastDateFrom: forecast.period.dateStart,
            forecastDateTo: forecast.period.dateEnd,
            forecastElevationFt: forecastConditions.elevationFt,
            forecastFlightRules: forecastConditions.flightRules,
            forecastVisibility: "\(forecastConditions.visibility.distanceSm) sm",
            forecastPrevailingVisibility: "\(forecastConditions.visibility.prevailingVisSm) sm",
            forecastWindSpeed: forecastConditions.wind.speedKts,
            forecastWindDirection: forecastConditions.wind.direction ?? 0,
            forecastWindFrom: forecastConditions.wind.from ?? 0,
            forecastWindVariable: forecastConditions.wind.variable)
        
        return weather
    }
}

