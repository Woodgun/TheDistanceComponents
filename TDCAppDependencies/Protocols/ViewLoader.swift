//
//  ViewLoader.swift
//  TheDistanceComponents
//
//  Created by Josh Campion on 23/05/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import UIKit

/// Defines the functions of an object that creates and configures the new views for navigation. Other components define extensions to this protocol that add extra functionality.
public protocol ViewLoader {
    
    func configuredRootViewController() -> UIViewController
    
}