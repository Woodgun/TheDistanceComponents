//
//  TestCrashReporter.swift
//
//  Created by Josh Campion on 30/03/2016.
//

import Foundation

/// CrashReporter useful for testing. Logs crash messages and no to and internal array of strings so it can be tested.
final public class TestCrashReporter: CrashReporter {
    
    /// Internal variable for saving the log messages.
    public fileprivate(set) var messages = [String]()
    
    /// Internal variable for saving non-fatal errors.
    public fileprivate(set) var nonFatals = [NSError]()
    
    /// Resets `messages` and `nonFatals` to empty arrays. This can be called on `setup()` for any testing classes.
    public func setupCrashReporting() {
        // reset the messages store
        messages = [String]()
    }
    
    /// Appends `message` to the `messages` array.
    public func logToCrashReport(_ message: String) {
        messages.append(message)
    }
    
    /// Calls an `assertionFailure()`. This can be caught as an exception using [Nimble](https://github.com/quick/nimble).
    public func simulateCrash() {
        assertionFailure("Simulated Crash!")
    }
    
    /// Appends `error` to the `nonFatals` array.
    public func logNonFatalError(_ error: NSError) {
        nonFatals.append(error)
    }
    
    public init() { }
}
