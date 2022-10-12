//
//  PersistenceErrors.swift
//  ProgrammingTest
//
//  Created by Matthew Faller on 10/11/22.
//

import Foundation

/// A class for throwing Persistence Specific Errors
public struct PersistenceError: Error {
    let description: String
    let cause: Error?
    
    static let unknownError = PersistenceError(description: "Unknown Error", cause: nil)
    static let nilWeakReference = PersistenceError(description: "Unable to unwrap weak reference to self", cause: nil)
    static let objectNotFound = PersistenceError(description: "Object not found with matching identifier", cause: nil)
    static let repeatConfigurationError = PersistenceError(description: "This singleton may only be configured once", cause: nil)
}

