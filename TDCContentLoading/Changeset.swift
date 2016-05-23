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
    @warn_unused_result
    func contentMatches(other:Self) -> Bool
}

/**
 
 Structure for representing a change in content between two arrays. The arrays are required to have matching types which are `ContentComparable`, allowing the two arrays to be separated into `deletions`, `modifications` and `insertions`. This can then be used to animate content changes in a `UITableView` or `UICollectionView`.
 
 Elements to be used in a Changeset should therefore ensure `==` and `=~=` are implemented to provide the desired animations.
 
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
        
        deletions = oldItems.difference(newItems).map { item in
            return Changeset.indexPathForIndex(oldItems.indexOf(item)!)
        }
        
        modifications = oldItems.intersection(newItems)
            .filter({ item in
                let newItem = newItems[newItems.indexOf(item)!]
                return item.contentMatches(newItem)
            })
            .map({ item in
                return Changeset.indexPathForIndex(oldItems.indexOf(item)!)
            })
        
        insertions = newItems.difference(oldItems).map { item in
            return NSIndexPath(forRow: newItems.indexOf(item)!, inSection: 0)
        }
    }
    
    private static func indexPathForIndex(index: Int) -> NSIndexPath {
        return NSIndexPath(forRow: index, inSection: 0)
    }
}

/// Extension methods for an `Array` to be used in a `Changeset`.
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
