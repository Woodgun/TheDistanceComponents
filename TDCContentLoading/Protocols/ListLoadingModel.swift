//
//  ListLoadingModel.swift
//  ComponentLibrary
//
//  Created by Josh Campion on 18/03/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

/**

 Protocol defining a type that can represent a list.
 
 Extensions for conformance are given for
 
 - `Array`
 - `Changeset`
 - `ListLoadingViewModel`
 - `PagedOutput`
 
*/
public protocol ListLoadingModel {
    
    /// The type of object in the list.
    associatedtype ValueType
    
    /// - returns: The total number of entities in all sections of the list.
    func totalNumberOfEntities() -> Int
    
    /// - returns: The number of sections in the list.
    func numberOfSectionsInList() -> Int
    
    /// - returns: The number of entities for a given section of the list.
    func numberOfEntitiesInSection(section:Int) -> Int
    
    /// - returns: The specfic entity for a given index path.
    func entityForIndexPath(indexPath:NSIndexPath) -> ValueType?
}

/**
 
 Extension of the `ListLoadingModel` from which a `Changeset` can be created.
 
*/
public protocol ChangesetLoadingModel: ListLoadingModel {
    
    /// Should return the current array of items that can populate the `Changeset`.
    func currentItems() -> [ValueType]
}
