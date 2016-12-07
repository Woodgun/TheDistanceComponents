//
//  PreferencesInteractor.swift
//
//  Created by Josh Campion on 21/01/2016.
//
//

import Foundation

/// Defines the requirements for getting the user's preferences from the Settings bundle for permission to send crash reports and analytics. There are default ipmlementations for all methods so this can be adopted by any singleton, typically the `AppDependencies`.
public protocol PreferencesInteractor {
    
    /// Should set the default preferences.
    func setDefaultPreferences()
    
    /// - returns: The user's permission to send crash reports.
    func canSendCrashReports() -> Bool
    
    /// - returns: The user's permission to send analytics, using `EnableAnalyticsPreferenceKey`,
    func canSendAnalytics() -> Bool
}

/// Key to store the user's crash reporting preference in.
public let EnableCrashReportingPreferenceKey = "EnableCrashReporting"

/// Key to store the user's analytics reporting preference in.
public let EnableAnalyticsPreferenceKey = "EnableAnalytics"

/// Default preferences interactor that stores the preferences in NSUserDefaults.
public extension PreferencesInteractor {
    
    /**
     
      Sets `true` for enabling both crash reporting and anlytics reporting.
     
     - seealso: `EnableCrashReportingPreferenceKey`, `EnableAnalyticsPreferenceKey`
    */
    public func setDefaultPreferences() {
        let prefs = [EnableCrashReportingPreferenceKey: true, EnableAnalyticsPreferenceKey: true]
        UserDefaults.standard.register(defaults: prefs)
    }
    
    /// Queries settings bundle with `EnableAnalyticsPreferenceKey`.
    public func canSendAnalytics() -> Bool {
        return UserDefaults.standard.bool(forKey: EnableAnalyticsPreferenceKey)
    }
    
    /// Queries settings bundle with `EnableCrashReportingPreferenceKey`.
    public func canSendCrashReports() -> Bool {
        return UserDefaults.standard.bool(forKey: EnableCrashReportingPreferenceKey)
    }
    
}
