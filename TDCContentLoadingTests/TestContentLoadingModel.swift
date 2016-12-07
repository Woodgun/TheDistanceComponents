//
//  TestContentLoadingModel.swift
//  TheDistanceComponents
//
//  Created by Josh Campion on 23/05/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import Foundation
import ReactiveSwift

import TDCContentLoading

/// Test loader that returns the input + 1 if the input is `>= 0 || nil`, and errors for inputs `<= -1`.
class TestContentLoadingViewModel: ContentLoadingViewModel<Int, Int> {
    
    static let NegativeInputError = NSError(domain: "LoadingTest", code: 0, userInfo: nil)
    
    override init(lifetimeTrigger: ViewLifetime? = .WillAppear, refreshFlattenStrategy: FlattenStrategy = .Latest) {
        super.init(lifetimeTrigger: lifetimeTrigger, refreshFlattenStrategy: refreshFlattenStrategy)
    }
    
    override func loadingProducerWithInput(input: Int?) -> SignalProducer<Int, NSError> {
        
        // return the signal then the categories after a delay to mimic network delay
        let (producer, observer) = SignalProducer<Int, NSError>.buffer(2)
        
        return producer.on(started: { () -> () in
            
            let queue = dispatch_queue_create("test_loading", nil)
            
            let delayTime = dispatch_time(DISPATCH_TIME_NOW,
                Int64(0.25 * Double(NSEC_PER_SEC)))
            
            dispatch_after(delayTime, queue, { () -> Void in
                let v = input ?? 0
                if v >= 0 {
                    observer.sendNext((input ?? 0) + 1)
                    observer.sendCompleted()
                } else {
                    observer.sendFailed(TestContentLoadingViewModel.NegativeInputError)
                }
            })
        })
    }
}
