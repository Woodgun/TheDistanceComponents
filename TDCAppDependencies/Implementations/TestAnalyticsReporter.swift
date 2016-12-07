//
//  TestAnalyticsReporter.swift
//
//  Created by Josh Campion on 30/03/2016.
//

import Foundation

/// Logs events into an internal array so the sending of analytic events can be tested.
final public class TestAnalyticsReporter:AnalyticsReporter {
    
    /// Internal variable for saving the events that are sent.
    public fileprivate(set) var trackedEvents = [AnalyticEvent]()
    
    /// Empty method for protocol conformance.
    public func enableAnalytics(_ enable: Bool) { }
    
    /// Resets `tackedEvents` to an empty array. This can be called on `setup()` for any testing classes.
    public func setupAnalytics() {
        trackedEvents = [AnalyticEvent]()
    }
    
    /// Appends the new `event` to `trackedEvents. If `asNewSession` is not `nil`, `trackedEvents` is cleared before the event is append to the array. The event has the session added as an info element with key `session`.
    public func sendAnalytic(_ event: AnalyticEvent, asNewSession session: AnalyticSession? = nil) {
        
        // append the with new events.
        var toRecord = event
        if let s = session {
            toRecord.addInfo("session", value: s)
            
            trackedEvents = [AnalyticEvent]()
        }
        
        trackedEvents.append(toRecord)
    }
    
    public init() { }
}
