//
//  Array+Changeset.swift
//  TheDistanceComponents
//
//  Created by Josh Campion on 24/05/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import Foundation

/// Extension methods for an `Array` to be used in a `Changeset` and conform to `ChangesetLoadingModel` to be used in lists.
extension Array {
    
    /**
     
     Convenience method to find the unique items in an array. This maintains the order of the items, whereas `Set` methods do not.
     
     - parameter otherArray: Array to perform the comparison on.
     
     - returns: An array of those elements which appear in `self`, but not `otherArray`.
     */
    func difference<T: Equatable>(otherArray: [T]) -> [T] {
        var result = [T]()
        
        for e in self {
            if let element = e as? T {
                if !otherArray.contains(element) {
                    result.append(element)
                }
            }
        }
        
        return result
    }
    
    /**
     
     Convenience method to find the common items between two arrays. This maintains the order of the items, whereas `Set` methods do not.
     
     - parameter otherArray: Array to perform the comparison on.
     
     - returns: An array of those elements which appear in `self`, but not `otherArray`.
     */
    func intersection<T: Equatable>(otherArray: [T]) -> [T] {
        var result = [T]()
        
        for e in self {
            if let element = e as? T {
                if otherArray.contains(element) {
                    result.append(element)
                }
            }
        }
        
        return result
    }
}

// MARK: ListLoadingModel
extension Array: ChangesetLoadingModel {
    
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
    
    
    /**
     
     `ChangesetLoadingModel` conformance.
     
     - returns: `self`
    */
    public func currentItems() -> [Element] {
        return self
    }
    
}
