//
//  ListLoadingViewModel.swift
//  TheDistanceComponents
//
//  Created by Josh Campion on 24/05/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import Foundation
import ReactiveSwift

/// Convenience subclass of `ContentLoadingViewModel` for `OutputType`s that conform to `ListLoadingModel`. This allows this class itself to conform to `ListLoadingModel`.
open class ListLoadingViewModel<InputType, ListType:ListLoadingModel>: ContentLoadingViewModel<InputType, ListType>, ListLoadingModel {
    
    public override init(lifetimeTrigger: ViewLifetime?, refreshFlattenStrategy: FlattenStrategy) {
        super.init(lifetimeTrigger: lifetimeTrigger, refreshFlattenStrategy: refreshFlattenStrategy)
    }
    
    /**
     
     Differentiates between the `.Empty` and `.Success(_)` cases for `ContentLoadingState`.
     
     - returns: `value.totalNumberOfEntities()` method is used to determine if the content is empty.
     */
    public override func contentIsEmpty(value:ListType) -> Bool {
        return value.totalNumberOfEntities() == 0
    }
    
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
        return loadedContent?.numberOfEntitiesInSection(section: section) ?? 0
    }
    
    /// - returns: The specific object for a given `NSIndexPath` from `loadedContent`.
    public func entityForIndexPath(indexPath: IndexPath) -> ListType.ValueType? {
        return loadedContent?.entityForIndexPath(indexPath: indexPath)
    }
    
    
}
