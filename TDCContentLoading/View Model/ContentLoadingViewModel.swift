//
//  ContentLoadingViewModel.swift
//  ComponentLibrary
//
//  Created by Josh Campion on 18/03/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

/**
 
 Abstract class which defines the standard way of loading content. It defines standard properties and chains together refresh inputs. This can be used in conjunction with `ContentLoadingNode` and its subclasses to provide default UI set up and changes for each `ContentLoadingState`.
 
 There are two generic parameters:
 
 * `InputType`: This represents a transient value that the loading request may depend on, such as in Paged Content.
 * `OutputType`: This should be the type of content that is being loading, typically a model object.
 
 - seealso: `ContentLoadingNode`
 - seealso: `TableLoadingNode`
 - seealso: `CollectionLoadingNode`
 
 */
public class ContentLoadingViewModel<InputType, OutputType> {
    
    // MARK: Input
    
    /// Property for the lifetime of the View this ViewModel is providing data for. This can be useful for triggering and cancelling refreshes on view lifetime events. This can be bound to the `lifetimeSignal` property of a `ReactiveAppearanceViewController`.
    public let viewLifetime = MutableProperty<ViewLifetime>(.Init)
    
    /// Triggers a content refresh through the `refreshSignal`.
    public let refreshObserver: Observer<InputType?, NoError>
    
    // MARK: Output
    
    /// Property to indicate that content is being fetched. This can be observed externally to show this progress to the user but `state` is the recommended property to observe.
    public let isLoading = MutableProperty<Bool>(false)
    
    /// The output for the fetched content. This can be observed externally to update the View  but `state` is the recommended property to observe.
    public let contentChangesSignal: Signal<OutputType, NoError>
    
    /// Property a View or other observer of this ViewModel can receive errors with. Errors should be sent internally using the `errorObserver`. `state` is the recommended property to observe for updating the UI.
    public let errorSignal: Signal<NSError, NoError>
    
    /// Property a View or other observer can recieve condensed updates between about the current loading process. This is a combination of `isLoading`, `contentChangesSignal`, `errorSignal` and `contentIsEmpty(_:)`.
    public var state = MutableProperty<ContentLoadingState<OutputType>>(.Unloaded)
    
    
    // MARK: Workings
    
    /// Internal property to send the results of loading to the `contentChangesSignal`.
    public let contentChangesObserver: Observer<OutputType, NoError>
    
    /// Internal property to send error messages to the View through the `errorSignal`.
    public let errorObserver: Observer<NSError, NoError>
    
    /// Responds to the `refreshObserver`, chaining to a new `loadingProducerWithInput(_:)`. `Next` events are forwarded to the `contentChangesSignal` whilst errors are flattened out and forwarded to the `errorSignal`.
    public let refreshSignal: Signal<InputType?, NoError>
    
    /// Assigned on `.Next` events of the `loadingProducerWithInput()`.
    public var loadedContent:OutputType?
    
    // MARK: Initializers
    
    /** 
     
     Initialises all properties and chains the refresh, loading, contentChanges, and error signals together. Observers the `viewLifetime` to chain to the `refreshObserver`. All the above are merge to create the `state` property which can be use to update UI.
     
     - seealso: `ContentLoadingNode`.
     
     - parameter lifetimeTrigger: The lifecycle event on which refresh will be triggered. Default value is `.WillAppear`. If `nil`, no automatic refresh is set up.
     - parameter refreshFlattenStrategy: The `FlattenStrategy` applied to the `SignalProducer` returned from `loadingProducerWithInput(_:)`.
     
     */
    public init(lifetimeTrigger:ViewLifetime? = .WillAppear, refreshFlattenStrategy:FlattenStrategy = .latest) {
        
        let (refreshSignal, refreshObserver) = Signal<InputType?, NoError>.pipe()
        let replayedProducer = SignalProducer(signal: refreshSignal).replayLazily(upTo: 2)
        replayedProducer.start()
        
        self.refreshSignal = refreshSignal
        self.refreshObserver = refreshObserver
        
        let (contentChangesSignal, contentChangesObserver) = Signal<OutputType, NoError>.pipe()
        self.contentChangesSignal = contentChangesSignal
        self.contentChangesObserver = contentChangesObserver
        
        let (errorSignal, errorObserver) = Signal<NSError, NoError>.pipe()
        self.errorSignal = errorSignal
        self.errorObserver = errorObserver
        
        if let trigger = lifetimeTrigger {
            viewLifetime.producer
                .filter { (lifetime:ViewLifetime) -> Bool in
                    return lifetime == trigger
                }.map { _ in nil }
                .start(refreshObserver)
        }

        _ = refreshSignal.flatMap(refreshFlattenStrategy) { (input) -> SignalProducer<OutputType, NoError> in
            
            let p = self.loadingProducerWithInput(input: input)
                .on(started: { self.isLoading.value = true }, terminated: { self.isLoading.value = false })
                .flatMapError({ (error) -> SignalProducer<OutputType, NoError> in
                    self.errorObserver.send(value: error)
                    return SignalProducer.empty
                })
            
            return p
        }
        _ = refreshSignal.observe(on: UIScheduler())
/*
        _ = refreshSignal.startWithNext { [weak self] (nextValue) in
                self?.loadedContent = nextValue
                if let obs = self?.contentChangesObserver {
                    obs.sendNext(nextValue)
                }
        }
        
        // merge the content change signals into a single signal for ContentLoadingState
        
        let successStateSignal = contentChangesSignal
            .map { ContentLoadingState<OutputType>.Success($0) }
        
        let emptyStateSignal = contentChangesSignal
            .filter { self.contentIsEmpty($0) }
            .map { _ in ContentLoadingState<OutputType>.Empty }
        
        let errorStateSignal = errorSignal
            .map { ContentLoadingState<OutputType>.Error($0) }
        
        let loadingStateSignal = isLoading.signal
            .filter { $0 }
            .map { _ in ContentLoadingState<OutputType>.Loading }
        
        let (stateSignal, stateObserver) = SignalProducer<Signal<ContentLoadingState<OutputType>, NoError>, NoError>.buffer(4)
        
        stateObserver.sendNext(emptyStateSignal)
        stateObserver.sendNext(loadingStateSignal)
        stateObserver.sendNext(successStateSignal)
        stateObserver.sendNext(errorStateSignal)
        
        stateObserver.sendCompleted()
        
        state <~ stateSignal.flatten(.Merge)
*/
    }
    
    // MARK: Content Loading
    
    /** 
     
     Trigged by the `refreshSignal`, subclasses should overide this to load the content.
     
     - returns: An empty `SignalProducer`.
     
    */
    public func loadingProducerWithInput(input:InputType?) -> SignalProducer<OutputType, NSError> {
        return SignalProducer.empty
    }
    
    /**
     
     Function used to differentiate the between the `.Empty` and `.Success(_)` cases for `ContentLoadingState`.
     
     - seealso: `ListLoadingViewModel`
     
     - returns: `false` by default. Subclasses can override this to provide further logic. 
     
     
     `true` if the content is deemed empty, false otherwise. If the out out is a `ListLoadingModel` the `totalNumberOfEntities()` method is used to determine if the content is empty.
    */
    public func contentIsEmpty(value:OutputType) -> Bool {
        return false
    }
}
