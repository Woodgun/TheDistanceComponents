//
//  ListLoadingContainer.swift
//  ComponentLibrary
//
//  Created by Josh Campion on 19/04/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import Foundation

/// Protocol extending `ListLoadingModel` making adoption of `ListLoadingModel` easier for objects that have properties that already conform to `ListLoadingModel` such as Arrays. Default implementations are given for each method in `ListLoadingModel` using a public extension.
public protocol ListLoadingContainer:ListLoadingModel {
    
    /// The ModelType that this object references.
    associatedtype ModelType:ListLoadingModel
    
    /// The reference to the `ListLoadingModel`.
    var listLoadingModel:ModelType { get }
}

public extension ListLoadingContainer {
    
    /// A `ListLoadingContainer` contains the same type of object as the `ListLoadingModel` it references.
    public typealias ValueType = ModelType.ValueType
    
    /// - returns: `totalNumberOfEntities()` of the contained `ListLoadingModel`.
    public func totalNumberOfEntities() -> Int {
        return listLoadingModel.totalNumberOfEntities()
    }
    
    /// - returns: `numberOfSectionsInList()` for the contained `ListLoadingModel`.
    public func numberOfSectionsInList() -> Int {
        return listLoadingModel.numberOfSectionsInList()
    }
    
    /// - returns: `numberOfEntitiesInSection(_:)` for the contained `ListLoadingModel`.
    public func numberOfEntitiesInSection(section: Int) -> Int {
        return listLoadingModel.numberOfEntitiesInSection(section: section)
    }
    
    /// - returns: `entityForIndexPath(_:)` as given by the contained `ListLoadingModel`.
    public func entityForIndexPath(indexPath: NSIndexPath) -> ModelType.ValueType? {
        return listLoadingModel.entityForIndexPath(indexPath: indexPath)
    }
}
