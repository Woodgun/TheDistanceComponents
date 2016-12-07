//
//  AppDependencies.swift
//  Pods
//
//  Created by Josh Campion on 22/01/2016.
//
//

import Foundation

/// Class that can be overriden that implements the properties required for the `_AppDependencies` protocol. Adopts `PreferencesInteractor` and all of its default ipmlementations.
open class AppDependencies: AppDependenciesSingleton, PreferencesInteractor {
    
    /// The shared instance of an `AppDependenciesSingleton` or its subclass, whichever is referenced in execution first. This is achieved using `AppDependenciesSingleton`: a class that offers a singleton property that initialises as a subclass' type. This cannot be acheived in Swift, but can in Objective-C.
    static func shared() -> Self {
        return sharedDependencies()
    }
    
    /// Default initialiser which should only be called from `sharedDependencies()`. Assigns `self` as the `PreferencesInteractor`.
    public override init() {
        
        super.init()
        
        preferencesInteractor = self
        preferencesInteractor?.setDefaultPreferences()
    }
    
    /// The class that creates and returns `UIViewController`s for navigation.
    open var viewLoader:ViewLoader?
    
    /// Global variable for reporting crash related information.
    open var crashReporter:CrashReporter? {
        didSet {
            crashReporter?.setupCrashReporting()
        }
    }
    
    /// Global variable for reporting analytics.
    open var analyticsReporter:AnalyticsReporter? {
        didSet {
            analyticsReporter?.setupAnalytics()
        }
    }
    
    /// Global variable for querying the user's preferences for crash reporting and analytics.
    open var preferencesInteractor:PreferencesInteractor? {
        didSet {
            preferencesInteractor?.setDefaultPreferences()
        }
    }
}
