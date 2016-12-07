//
//  AnalyticsReporter.swift
//
//  Created by Josh Campion on 21/01/2016.
//

import Foundation

/// Protocol defining session wide properties used for tracking groups of `AnalyticEvent`s.
public protocol AnalyticSession {
    
    /// A human readable device name that can be used to identify device type for more detailed segmentation.
    var deviceName:String { get }
    
    /// A dictionary of the custom dimensions to apply to the events in this session.
    var customDimensions:[UInt:String] { get }
}

/// Defines the requirements of an object that sends Analytics.
public protocol AnalyticsReporter {
    
    /// Should enable / disable further analytics from be sent.
    func enableAnalytics(_ enable:Bool)
    
    /// Should be called before any other analytics methods to set the default properties, such as tracking ids.
    func setupAnalytics()
    
    /**

    Should record the given analytic event, optionally starting a new session.
    
    - parameter event: The event to send.
    - parameter session: If this value is not nil, this should begin a new analytics session with the given configuration, closing a previously opened session. This should be called whenever anyhting in the session configuration changes, e.g. user logs out / in.
    */
    func sendAnalytic(_ event:AnalyticEvent, asNewSession session:AnalyticSession?)
    
    /**
    
    Should record the given analytic event. A default implementation is given which calls `sendAnalytic(_:asNewSession:)` without starting a new session.
    
    - parameter event: The event to send.
    */
    func sendAnalytic(_ event:AnalyticEvent)
}

public extension AnalyticsReporter {
    
    /// Calls `sendAnalytic(_:asNewSession:)` without starting a new session.
    public func sendAnalytic(_ event:AnalyticEvent){
        sendAnalytic(event, asNewSession: nil)
    }
    
}
