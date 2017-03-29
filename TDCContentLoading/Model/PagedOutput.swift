//
//  PagedOutput.swift
//  TheDistanceComponents
//
//  Created by Josh Campion on 24/05/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import Foundation

/// The `OutputType` for by a `PagingContentLoadingViewModel`. Contains all the content loaded so far and a flag for whether there is more content available. This has been extended to conform to `ListLoadingContainer` based on the currently loaded content.
public struct PagedOutput<OutputType> {
    
    /// An aggregated array of all the content loaded so far.
    public let currentContent:[OutputType]
    
    /// Flag for whether there are more pages to be loaded.
    public let moreAvailable:Bool
    
    /// Default initialiser
    public init(currentContent:[OutputType], moreAvailable:Bool) {
        self.currentContent = currentContent
        self.moreAvailable = moreAvailable
    }
}

// MARK: List Loading Model

extension PagedOutput: ChangesetLoadingModel {
    public typealias ValueType = OutputType
    
    /// - returns: 1. Paging sections is not yet implemented.
    public func numberOfSectionsInList() -> Int {
        return 1
    }
    
    /// - returns: The number of elements in the current content + 1 iff there is more content available, allowing the table to show a spinner cell.
    public func numberOfEntitiesInSection(section: Int) -> Int {
        return currentContent.count + (moreAvailable ? 1 : 0)
    }
    
    /// - returns: The number of objects in section 0. Paging sections is not yet implemented.
    public func totalNumberOfEntities() -> Int {
        return numberOfEntitiesInSection(section: 0)
    }
    
    /// - returns: The specific object for a given `NSIndexPath` from `currentContent`, or `nil` if the `indexPath.row` is above the count of objects in `currentContent`, this occurs if there is more content available.
    public func entityForIndexPath(indexPath: IndexPath) -> OutputType? {
        
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
