//
//  ListLoadingModel.swift
//  ComponentLibrary
//
//  Created by Josh Campion on 18/03/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import Foundation
import ReactiveCocoa
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

extension Array: ChangesetLoadingModel {

    // MARK: ListLoadingModel
    
    /**

    `ListLoadingModel` conformance for `Array`.
    
    The `Element` contained in this array.
    
    */
    public typealias ValueType = Element
    
    /**
     
     `ListLoadingModel` conformance.
     
     A single array as a `ListLoadingModel` represents the whole content of a list so all elements in `self` are all the elements in the list.
     
     - returns: The count of the elements in self.
     */
    public func totalNumberOfEntities() -> Int {
        return count
    }
    
    /**
     
     `ListLoadingModel` conformance.
     
     A single array as a `ListLoadingModel` represents the whole content of a list so there is only 1 section.
     
     - returns: 1
     
     */
    public func numberOfSectionsInList() -> Int {
        return 1
    }
    
    /**
     
     `ListLoadingModel` conformance.
     
     A single array as a `ListLoadingModel` represents the whole content of a list so the only section count is the count of self.
     
     - returns: The count of the elements in self.
     */
    public func numberOfEntitiesInSection(section:Int) -> Int {
        return count
    }
    
    /**
     
     `ListLoadingModel` conformance.
     
     - returns: The item at index `indexPath.item`.
     */
    public func entityForIndexPath(indexPath:NSIndexPath) -> ValueType? {
        return self[indexPath.item]
    }

    
    /// - returns: `self`.
    public func currentItems() -> [Element] {
        return self
    }
    
}


/// A `Changeset` representing a list uses `newItems` to populate the list as an Array would.
extension Changeset: ChangesetLoadingModel {
    
    // MARK: ListLoadingModel
    
    /// `ListLoadingModel` conformance for `Changeset`. The `Element` contained in this `Changeset`.
    public typealias ValueType = Element
    
    
    /// `ListLoadingModel` conformance using `newItems` as an Array conforming to `ListLoadingModel`.
    public func totalNumberOfEntities() -> Int {
        return newItems.totalNumberOfEntities()
    }
    
    /// `ListLoadingModel` conformance using `newItems` as an Array conforming to `ListLoadingModel`.
    public func numberOfSectionsInList() -> Int {
        return newItems.numberOfSectionsInList()
    }
    
    /// `ListLoadingModel` conformance using `newItems` as an Array conforming to `ListLoadingModel`.
    public func numberOfEntitiesInSection(section:Int) -> Int {
        return newItems.numberOfEntitiesInSection(section)
    }
    
    /// `ListLoadingModel` conformance using `newItems` as an Array conforming to `ListLoadingModel`.
    public func entityForIndexPath(indexPath:NSIndexPath) -> ValueType? {
        return newItems.entityForIndexPath(indexPath)
    }
    
    /// - returns: The `newItems` as this represents the current content of this change.
    public func currentItems() -> [Element] {
        return newItems
    }
}


extension ListLoadingViewModel: ListLoadingModel {

    // MARK: ListLoadingModel
    
    /// - returns: The number of sections in `loadedContent` or zero if `loadedContent` is `nil`.
    public func numberOfSectionsInList() -> Int {
        return loadedContent?.numberOfSectionsInList() ?? 0
    }
    
    /// - returns: The total number of objects in `loadedContent` or zero if `loadedContent` is `nil`.
    public func totalNumberOfEntities() -> Int {
        return loadedContent?.totalNumberOfEntities() ?? 0
    }
    
    /// - returns: The number of objects in a given section from `loadedContent` or zero if `loadedContent` is `nil`.
    public func numberOfEntitiesInSection(section:Int) -> Int {
        return loadedContent?.numberOfEntitiesInSection(section) ?? 0
    }
    
    /// - returns: The specific object for a given `NSIndexPath` from `loadedContent`.
    public func entityForIndexPath(indexPath:NSIndexPath) -> ListType.ValueType? {
        return loadedContent?.entityForIndexPath(indexPath)
    }
}

extension PagedOutput: ChangesetLoadingModel {
    
    // MARK: ListLoadingModel
    
    /// - returns: 1
    public func numberOfSectionsInList() -> Int {
        return 1
    }
    
    /// - returns: The number of elements in the current content + 1 iff there is more content available, allowing the table to show a spinner cell.
    public func numberOfEntitiesInSection(section: Int) -> Int {
        return currentContent.count + (moreAvailable ? 1 : 0)
    }
    
    /// - returns: The number of objects in section 0.
    public func totalNumberOfEntities() -> Int {
        return numberOfEntitiesInSection(0)
    }
    
    /// - returns: The specific object for a given `NSIndexPath` from `currentContent`, or `nil` if the `indexPath.row` is above the count of objects in `currentContent`, this occurs if there is more content available.
    public func entityForIndexPath(indexPath: NSIndexPath) -> OutputType? {
        
        if indexPath.row >= currentContent.count {
            return nil
        } else {
            return currentContent[indexPath.row]
        }
    }
    
    /// - returns: The `currentContent` to make a `Changeset` from.
    public func currentItems() -> [OutputType] {
        return currentContent
    }
}
