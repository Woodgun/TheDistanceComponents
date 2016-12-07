//
//  Changeset.swift
//  SwiftGoal
//
//  Created by Martin Richter on 01/06/15.
//  Copyright (c) 2015 Martin Richter. All rights reserved.
//

import Foundation


/// Protocol used with `Changeset`s to determine items which may be equal in terms of the object they represent but have different content. This is useful for objects which may change, e.g. products with a new price, calendar appointments with a new time.
public protocol ContentEquatable: Equatable {
    
    /**
     
    `Equality` implies substitutability whereas `ContentEquatable` implies exact matches.
    `ContentEquatable` is an equivalence relation.
    
     - parameter other: The object to compare content against.
     - returns: `true` if the content of `other` is the same as the content of `self`, `false` otherwise.
    */
    
    func contentMatches(other:Self) -> Bool
}

/**
 
 Structure for representing a change in content between two arrays. The arrays are required to have matching types which are `ContentComparable`, allowing the two arrays to be separated into `deletions`, `modifications` and `insertions`. This can then be used to animate content changes in a `UITableView` or `UICollectionView`.
 
 - note: This struct is based on that used by [Martin Richter](http://www.martinrichter.net) in his blog post ["Animating table row changes using changesets with MVVM"](http://www.martinrichter.net/blog/2015/12/30/animating-table-row-changes-using-changesets-with-mvvm/)
 
 */
public struct Changeset<Element: ContentEquatable> {
    
    /// Index Paths for the items in `oldItems` that are no longer in `newItems`. Inclusion is determined by `Equatable`.
    public var deletions: [NSIndexPath]
    
    /// Index Paths for the items in both `oldItems` and `newItems`. Inclusion is determined by `Equatable`. Modification is determined by `ContentEquatable`.
    public var modifications: [NSIndexPath]
    
    /// Index Paths for the items in `newItems` that were not in `oldItems`. Inclusion is determined by `Equatable`.
    public var insertions: [NSIndexPath]
    
    /// The initial array to perform comparison of `newItems` to.
    public var oldItems:[Element]
    
    /// The final array to perform comparison of `oldItems` against.
    public var newItems:[Element]
    
    
    /// Defualt initialiser that calculates all properties.
    public init(oldItems: [Element], newItems: [Element]) {
        
        self.oldItems = oldItems
        self.newItems = newItems
        
        deletions = oldItems.difference(otherArray: newItems).map { item in
            return Changeset.indexPathForIndex(index: oldItems.index(of: item)!)
        }
        
        modifications = oldItems.intersection(otherArray: newItems)
            .filter({ item in
                let newItem = newItems[newItems.index(of: item)!]
                return item.contentMatches(other: newItem)
            })
            .map({ item in
                return Changeset.indexPathForIndex(index: oldItems.index(of: item)!)
            })
        
        insertions = newItems.difference(otherArray: oldItems).map { item in
            return NSIndexPath(row: newItems.index(of: item)!, section: 0)
        }
    }
    
    private static func indexPathForIndex(index: Int) -> NSIndexPath {
        return NSIndexPath(row: index, section: 0)
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
        return newItems.numberOfEntitiesInSection(section: section)
    }
    
    /// `ListLoadingModel` conformance using `newItems` as an Array conforming to `ListLoadingModel`.
    public func entityForIndexPath(indexPath:NSIndexPath) -> ValueType? {
        return newItems.entityForIndexPath(indexPath: indexPath)
    }
    
    /// - returns: The `newItems` as this represents the current content of this change.
    public func currentItems() -> [Element] {
        return newItems
    }
}

