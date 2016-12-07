//
//  TDCContentLoadingTests.swift
//  TDCContentLoadingTests
//
//  Created by Josh Campion on 23/05/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import XCTest

import ReactiveSwift
import Result

import Nimble

@testable import TDCContentLoading

extension XCTestCase {
    
    /**
     
     Creates an `XCTExpectation` which fulfils after a given time interval and waits for it.
     
     - parameter time: The time to wait for. Default value is 0.25.
     - parameter withDescription: The description for the `XCTExpectation`.
     
     */
    public func waitForTime(time:NSTimeInterval = 0.25, withDescription description:String) {
        
        // wait to see if there are no events sent after a possible refresh
        let waitExpectation = expectationWithDescription(description)
        waitExpectation.performSelector(#selector(XCTestExpectation.fulfill), withObject: nil, afterDelay: time)
        waitForExpectationsWithTimeout(time + 0.15, handler: nil)
        
    }
}

class TDCContentLoadingTests: XCTestCase {
    
    let expectationTimeout:NSTimeInterval = 5
    
    let model = TestContentLoadingViewModel()
    
    let output = MutableProperty<Int?>(nil)
    let errors = MutableProperty<NSError?>(nil)
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        output <~ model.contentChangesSignal.map { $0 as Int? }
        errors <~ model.errorSignal.map { $0 as NSError? }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testWillAppearNilInput() {
        
        model.viewLifetime.value = .WillAppear
        
        expect(self.output.value).toEventually(equal(1))
        
        waitForTime(withDescription: #function)
        expect(self.errors.value).to(beNil())
    }
    
    func testInput() {
        
        model.refreshObserver.sendNext(15)
        
        expect(self.output.value).toEventually(equal(16))
        
        waitForTime(withDescription: #function)
        expect(self.errors.value).to(beNil())
    }
    
    func testError() {
        
        model.refreshObserver.sendNext(-1)
        
        expect(self.errors.value).toEventually(equal(TestContentLoadingViewModel.NegativeInputError))
        
        waitForTime(withDescription: #function)
        expect(self.output.value).to(beNil())
    }
    
    func testIsLoadingSuccess() {
        
        let aggregatedOutput = MutableProperty<[Bool]>([])
        
        aggregatedOutput <~ model.isLoading.producer
            .scan([Bool]()) { $0 + [$1] }
        
        let expectedValues = [
            ([false], "isLoading should start false"),
            ([false, true], "isLoading should start false, then become true."),
            ([false, true, false], "isLoading should start false, then become true, then end as false.")
        ]
        
        var v = 0
        aggregatedOutput.producer
            .observeOn(UIScheduler())
            .startWithNext { (values) -> () in
                expect(values).to(equal(expectedValues[v].0), description: expectedValues[v].1)
                v += 1
        }
        
        model.refreshObserver.sendNext(0)
        
        expect(self.output.value).toEventually(equal(1))
        
        waitForTime(withDescription: #function)
        expect(self.errors.value).to(beNil())
    }
    
    func testIsLoadingFailure() {
        
        let aggregatedOutput = MutableProperty<[Bool]>([])
        
        aggregatedOutput <~ model.isLoading.producer
            .scan([Bool]()) { $0 + [$1] }
        
        let expectedValues = [
            ([false], "isLoading should start false"),
            ([false, true], "isLoading should start false, then become true."),
            ([false, true, false], "isLoading should start false, then become true, then end as false.")
        ]
        
        var v = 0
        aggregatedOutput.producer
            .observeOn(UIScheduler())
            .startWithNext { (values) -> () in
                expect(values).to(equal(expectedValues[v].0), description: expectedValues[v].1)
                v += 1
        }
        
        model.refreshObserver.sendNext(-1)
        
        expect(self.errors.value).toEventually(equal(TestContentLoadingViewModel.NegativeInputError))
        
        waitForTime(withDescription: #function)
        expect(self.output.value).to(beNil())
    }
    
    func testStateChange() {
    
        let state = MutableProperty<ContentLoadingState<Int>?>(nil)
        
        state <~ model.state.producer.map { $0 as ContentLoadingState<Int>? }
        
        let expectedValues:[ContentLoadingState<Int>] = [.Unloaded, .Loading, .Success(1)]
        
        var v = 0
        state.producer
            .observeOn(UIScheduler())
        .startWithNext { (newState) in
            
            guard let s = newState else {
                XCTFail("No state given")
                return
            }
            
            let equal = s == expectedValues[v]
            expect(equal).to(beTrue())
            v += 1
        }
        
        model.refreshObserver.sendNext(0)
        
        expect(self.output.value).toEventually(equal(1))
        
        waitForTime(withDescription: #function)
        expect(self.errors.value).to(beNil())
    }
    
    func testErrorStateChange() {
        
        let state = MutableProperty<ContentLoadingState<Int>?>(nil)
        
        state <~ model.state.producer.map { $0 as ContentLoadingState<Int>? }
        
        let expectedValues:[ContentLoadingState<Int>] = [.Unloaded, .Loading, .Error(TestContentLoadingViewModel.NegativeInputError)]
        
        var v = 0
        state.producer
            .observeOn(UIScheduler())
            .startWithNext { (newState) in
                
                guard let s = newState else {
                    XCTFail("No state given")
                    return
                }
                
                let equal = s == expectedValues[v]
                expect(equal).to(beTrue())
                v += 1
        }
        
        model.refreshObserver.sendNext(-1)
        
        expect(self.errors.value).toEventually(equal(TestContentLoadingViewModel.NegativeInputError))
        
        waitForTime(withDescription: #function)
        expect(self.output.value).to(beNil())
    }
}
