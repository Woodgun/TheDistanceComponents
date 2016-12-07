//
//  AppDependencies.swift
//
//  Created by Josh Campion on 21/01/2016.
//

import UIKit

/// Protocol that `AppDependencies` subclasses should conform to prescribing standard method implementations.
public protocol _AppDependencies {
    
    /// The singleton representing the global `AppDependencies`.
    static func sharedDependencies() -> Self
    
    /// Handles crash and error reporting. The setter for this should call `setUpCrashReporting()`.
    var crashReporter:CrashReporter? { get set }
    
    /// Handles tracking analytics. The setter for this should call `setupAnalytics()`.
    var analyticsReporter:AnalyticsReporter? { get set }
    
    /// Handles the user's preferences. The setter for this should calls `setDefaultPreferences()`.
    var preferencesInteractor:PreferencesInteractor? { get set }
    
    /// Handles view and view model creation for navigation.
    var viewLoader:ViewLoader? { get set }
    
    /**
     
     Should be called by the AppDelegate to create a `UIViewController` to be root and add it as the root of the given window.
     
     - parameter window: The window to add the root `UIViewController` to.
    */
    func installRootViewControllerIntoWindow(_ window:UIWindow)
}
