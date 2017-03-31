//
//  ReactiveAppearanceViewController.swift
//  AppCommerce
//
//  Created by Josh Campion on 03/03/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

/// Enum sent from a `ReactiveAppearanceViewController` on view lifetime methods. This allows listening to when appearance events occur to allow for deep linking.
public enum ViewLifetime {
    
    /// Sent from `init(coder:)` and `init(nibNameOrNil:bundle:)`.
    case Init
    
    /// Sent from `viewDidLoad()`.
    case DidLoad
    
    /// Sent from `viewWillAppear(_:)`.
    case WillAppear
    
    /// Sent from `viewDidAppear(_:)`.
    case DidAppear
    
    /// Sent from `viewWillDisappear(_:)`.
    case WillDisappear
    
    /// Sent from `viewDidDisappear(_:)`.
    case DidDisappear
}

/// `UIViewController` subclass for that sends its lifecycle events (`viewDidLoad()`, `viewWillAppear(_:)` etc.) via a Signal.
open class ReactiveAppearanceViewController: UIViewController {
    
    /// Signal and Observer pair that send view lifecycle events for each value of `ViewLifetime`.
    public let (lifetimeSignal, lifetimeObserver) = Signal<ViewLifetime, NoError>.pipe()
    
    /// Standard initialiser sending the `.Init` lifetime event to `lifetimeObserver`.
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        lifetimeObserver.send(value: .Init)
    }
    
    /// Standard initialiser sending the `.Init` lifetime event to `lifetimeObserver`.
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        lifetimeObserver.send(value: .Init)
    }
    
    /// Sends `.DidLoad` lifetime event to `lifetimeObserver`.
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        lifetimeObserver.send(value: .DidLoad)
    }
    
    /// Sends `.WillAppear` lifetime event to `lifetimeObserver`.
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        lifetimeObserver.send(value: .WillAppear)
    }
    
    /// Sends `.DidAppear` lifetime event to `lifetimeObserver`.
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        lifetimeObserver.send(value: .DidAppear)
    }
    
    /// Sends `.WillDisappear` lifetime event to `lifetimeObserver`.
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        lifetimeObserver.send(value: .WillDisappear)
    }
    
    /// Sends `.DidDisappear` lifetime event to `lifetimeObserver`.
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        lifetimeObserver.send(value: .DidDisappear)
    }
    
    deinit {
        lifetimeObserver.sendCompleted()
    }
}
