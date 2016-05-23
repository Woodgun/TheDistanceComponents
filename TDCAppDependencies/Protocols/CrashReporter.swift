//
//  CrashReporter.swift
//
//  Created by Josh Campion on 21/01/2016.
//

import Foundation

/// Defines the requirements for setting up crash reporting, appending to crash logs and other actions related to crash reporting.
public protocol CrashReporter {
    
    /// Crash reporting should be enabled if allowed by the user. This should typically be initiated from `application(_:didFinishLaunchingWithOptions:)`.
    func setupCrashReporting()
    
    /// This should be used to cause a crash that will get reported.
    func simulateCrash()
    
    /**
     
     Should append a message to any potential upcoming crash reports.
     
     - parameter message: The message to be appended to the crash report.
     
    */
    func logToCrashReport(message:String)
    
    /**
     
     Should report a non-fatal error to the crash reporting system.
     
     - parameter error: The error to report.
    */
    func logNonFatalError(error: NSError)
    
}