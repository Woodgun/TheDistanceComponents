//
//  AnalyticEntities.swift
//  ViperKit
//
//  Copyright © 2016 The Distance. All rights reserved.
//

import Foundation

/// Simple struct to define an Analytic Event. This is a value type to ensure clear mutabililty implications.
public struct AnalyticEvent: CustomStringConvertible, Equatable {
    
    /// The category for this event. This should be high level for filtering the events. This is defined as an enum for String safety.
    public let category:String
    
    /// The action for this event. This should be mid level for filtering the events within a given category. This is defined as an enum for String safety.
    public let action:String
    
    /// The label for this event. This should be low level identifying a specific event.
    public let label:String?
    
    /// Internal variable used to highlight the mutability implications of the addInfo(_:value:) and setUserInfo(_:) methods.
    private var _userInfo = [String:Any]()
    
    /// Extra info specifc to this analytic event.
    public var userInfo:[String:Any] {
        get {
            return _userInfo
        }
    }
    
    /**
    
    Designated initialiser for a general event. 
    It is **strongly recommended** that event Category, Actions and Lables are defined using enums and this struct is extended with a convenience initialiser specific to the application being developed.
    
    - parameter category: The category for this event.
    - parameter action: The action for this event.
    - parameter label: The label for this event.
    - parameter userInfo: Extra info specifc to this event.
    
    */
    public init(category:String, action:String, label:String?, userInfo:[String:Any]? = nil) {
        self.category = category
        self.action = action
        self.label = label
        
        if let info = userInfo {
            setUserInfo(info)
        }
    }
    
    /**
    
    Appends a new value to the userInfo.
    
    - parameter key: The key to which the value will be assigned.
    - parameter value: The value to be stored.
    */
    public mutating func addInfo(key:String, value:Any) {
        _userInfo[key] = value
    }
    
    /**
    
    Assigns a new userInfo dictionary to this event.
    
    - parameter info: The info to be set.
    
    */
    public mutating func setUserInfo(info:[String:Any]) {
        _userInfo = info
    }
    
    /// `CustomStringConvertible` variable.
    public var description:String {
        get {
            return "<Analytic: \(category) - \(action) - \(label), UserInfo: \(userInfo)>"
        }
    }
}

/// An `AnalyticEvent` is `Equatable` if its `category`, `action` and `label` are all equal.
public func ==(a1:AnalyticEvent, a2:AnalyticEvent) -> Bool {
    
    return a1.category == a2.category &&
        a1.action == a2.action &&
        a1.label == a2.label
}
