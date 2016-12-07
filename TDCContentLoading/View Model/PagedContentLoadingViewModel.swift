//
//  PagedContentLoadingViewModel.swift
//  ComponentLibrary
//
//  Created by Josh Campion on 19/04/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import Foundation

import ReactiveSwift

/**
 Subclass of `ContentLoadingViewModel` for loading paged content. This class handles the aggregation of the loaded content allowing subclasses to provide only the content for a given page. The current page and whether there is more content available is handled automatically. 
 
 `InputType` is a `Bool` indicating whether the next page of content should be fetched (`true`), or whether the currently loaded content should be cleared and the first page of content requested again (`false`).
*/
public class PagingContentLoadingViewModel<ValueType>: ListLoadingViewModel<Bool, PagedOutput<ValueType>>, ChangesetLoadingModel {
    
    /// The number of objects that should be fetched per page. The default value is 25. Changing the value of this causes a refresh of the content as the current page number will be incorrect.
    public let pageCount = MutableProperty<UInt>(25)
    
    /// Default initialiser passing the parameters through to `super`.
    public override init(lifetimeTrigger: ViewLifetime? = .WillAppear, refreshFlattenStrategy: FlattenStrategy = .latest) {
        super.init(lifetimeTrigger: lifetimeTrigger, refreshFlattenStrategy: refreshFlattenStrategy)
        
        pageCount.producer.combinePrevious(25).filter { $0 != $1 }.startWithValues { _ in self.refreshObserver.send(value: false) }
    }
    
    /**
     
     Point of customisation for subclasses. The given page of content should be requested from an APIManager or other external source.
     
    */
    public func contentForPage(page: UInt) -> SignalProducer<[ValueType], NSError> {
        return SignalProducer.empty
    }
    
    /**
     
     Aggregate the results of `contentForPage(_:)` that have been loaded so far.
     
     - parameter nextPage: Flag for whether the next page of content is being loaded (`true`) or the content is being loaded again from scratch (`false`).
     
    */
    override public func loadingProducerWithInput(input nextPage: Bool?) -> SignalProducer<PagedOutput<ValueType>, NSError> {
        
        let page:UInt
        
        let currentContent:PagedOutput<ValueType>
        
        if nextPage ?? false {
            
            let currentCount = loadedContent?.currentContent.count ?? 0
            page = UInt(currentCount) / pageCount.value
            currentContent = loadedContent ?? PagedOutput(currentContent:[ValueType](), moreAvailable:true)
            
        } else {
            currentContent = PagedOutput(currentContent:[ValueType](), moreAvailable:true)
            page = 0
        }
        
        
        return contentForPage(page: page)
            .scan(currentContent) {
                
                let aggregatedContent = $0.currentContent + $1
                let moreAvailable = UInt($1.count) == self.pageCount.value
                
                return PagedOutput(currentContent: aggregatedContent, moreAvailable: moreAvailable )
        }
    }
    
    // MARK: Changeset Loading Model
    
    /// - returns: The currently loaded content from the `PagedOutput` or and empty array if nothing has been downloaded.
    public func currentItems() -> [ValueType] {
        return loadedContent?.currentContent ?? []
    }
}
