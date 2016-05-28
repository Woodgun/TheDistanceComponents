//
//  ContentLoadingState.swift
//  TheDistanceComponents
//
//  Created by Josh Campion on 24/05/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import Foundation

/// Enum encompassing the possible states for a 'load' to be in. An `Equtable` function is given for when `ValueType` is also `Equatable`.
public enum ContentLoadingState<ValueType> {
    
    /// No fetch has been initiated yet.
    case Unloaded
    
    /// Content has been requested successfully but nothing is found (such as no user favourites or an empty basket.
    case Empty
    
    /// A network request is currently in progress.
    case Loading
    
    /// A request has successfully completed with content.
    case Success(ValueType)
    
    /// A request has failed with the given error.
    case Error(NSError)
    
}

/// Equatable function for `ContentLoadingState` when `ValueType: Equatable`.
func ==<V:Equatable>(c1:ContentLoadingState<V>, c2:ContentLoadingState<V>) -> Bool {
    
    switch (c1, c2) {
    case (.Unloaded, .Unloaded), (.Empty, .Empty), (.Loading, .Loading):
        return true
    case (.Success(let e1), .Success(let e2)):
        return e1 == e2
    case (.Error(let e1), .Error(let e2)):
        return e1 == e2
    default:
        return false
    }
}
