//
//  TestPreferences.swift
//
//  Created by Josh Campion on 30/03/2016.
//

import Foundation

/// PreferencesInteractor useful for testing. This always returns true and prevents tests from needing to configure NSUserDefaults.
final public class TestPreferences:PreferencesInteractor {
    
    /// Empty method for protocol conformance.
    static func setDefaultPreferences() { }
    
    /// - returns: true
    public func canSendAnalytics() -> Bool {
        return true
    }
    
    /// - returns: true
    public func canSendCrashReports() -> Bool {
        return true
    }
    
    public init() { }
    
}