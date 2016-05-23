//
//  ReactiveAppearanceViewController.swift
//  AppCommerce
//
//  Created by Josh Campion on 03/03/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import Foundation
import ReactiveCocoa
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
public class ReactiveAppearanceViewController: UIViewController {
    
    /// Signal and Observer pair that send view lifecycle events for each value of `ViewLifetime`.
    public let (lifetimeSignal, lifetimeObserver) = Signal<ViewLifetime, NoError>.pipe()
    
    /// Standard initialiser sending the `.Init` lifetime event to `lifetimeObserver`.
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        lifetimeObserver.sendNext(.Init)
    }

    /// Standard initialiser sending the `.Init` lifetime event to `lifetimeObserver`.
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        lifetimeObserver.sendNext(.Init)
    }
    
    /// Sends `.DidLoad` lifetime event to `lifetimeObserver`.
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        lifetimeObserver.sendNext(.DidLoad)
    }
    
    /// Sends `.WillAppear` lifetime event to `lifetimeObserver`.
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        lifetimeObserver.sendNext(.WillAppear)
    }
    
    /// Sends `.DidAppear` lifetime event to `lifetimeObserver`.
    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        lifetimeObserver.sendNext(.DidAppear)
    }
    
    /// Sends `.WillDisappear` lifetime event to `lifetimeObserver`.
    public override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        lifetimeObserver.sendNext(.WillDisappear)
    }
    
    /// Sends `.DidDisappear` lifetime event to `lifetimeObserver`.
    public override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        lifetimeObserver.sendNext(.DidDisappear)
    }
    
    deinit {
        lifetimeObserver.sendCompleted()
    }
}