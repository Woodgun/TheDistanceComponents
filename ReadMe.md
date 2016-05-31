# TheDistanceComponents

[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
![MIT license](https://img.shields.io/badge/license-MIT-lightgrey.svg)

Building Blocks for Great iOS Apps

## Motivation

This project had two key goals:

0. Increased reusability of code to reduce boilerplate and development time whilst increasing stability and consistency.
1. Increased testability of code whilst reducing the amount of boilerplate tests to be written and maintained.

The direction taken to acheive these goal is to create base implementations of default functionality, called Components, that can be reused and customised throughout multiple apps. The 'Model-View-ViewModel' (MVVM) architecture and [ReactiveCocoa], described in detail in here and throughout the code, is was determined to be the best fit for this as it is more flexible and testable that MVC, and less verbose and opaque than [Viper]. 

This project will typically contain few `UIViewController`s, with the emphasis on creating reusable ViewModel components. Reusable UI is created using [AsyncDisplayKit] an excellent library for creating UI, and `ASDisplayNode`s will be used to provide customisable building blocks of UI.

## Components

To reduce the dependencies on projects using TheDistanceComponents, each piece of functionality has been separated into its own framework.

* [TDCAppDependencies]: 
  * Singleton and related classes to achieve a standardised MVVM architecture
  * Protocol for standard Analytic & Crash Reporting interface
  * Protocol for standard View Loading
* [TDCContentLoading]:
  * Standard StateModel & ViewModel for handling network requests in MVVM
  * View Lifetime properties delivered using ReactiveCocoa
  * Standardised cases for List Loading including paging content

See each section for more details.

## Installation

ReactiveCocoaConvenience is [Carthage] compatible. Add

	github "thedistance/TheDistanceComponents"

and following the [Carthage] installation instructions. Add the frameworks you will be using and their dependencies, then checkout the documentation for each to get started.

As there is no official [Cocoapods] support for ReactiveCocoa, Cocoapods is not officially supported for TheDistanceComponents either.

## MVVM & Components: A Brief Introduction

### Model

Anything in an app that represents data is thought of as a model object. These might be simple Swift structs or `NSManagedObject`s. We will try to avoid defining model objects in Components. If necessary, protocols will be used allowing applications to define their own models with as few restrictions as possible.

### Views

Each view in an app is split into a 'View' and 'ViewModel'. The ViewModel is responsible for all logic whilst the View is responsible for updating what is displayed on the screen based on the Model objects given to it from the ViewModel. This allows for a clean separation of responsibility and increased testability without increasing complexity unnecessarily. Views could be a `UIView` subclass or `ASDisplayNode`. Given the extra performance and flexibility, `ASDisplayNode`s will be used to define default View components.

In order to communicate view lifecycle events to 'ViewModel' objects, the `ReactiveAppearanceViewController` should be subclassed over `UIViewController`. This provides a signal of `ViewLifetime` events that can be bound to a `MutableProperty<ViewLifetime>` on ViewModels.

Views should only be created by the ViewLoader on the AppDependencies singleton, as defined in [TDCAppDependencies]. This allows for frameworks to be developed providing default behaviour that can be specialised by applications through dependency injection. Components provides some standard UI using [AsyncDisplayKit], where the `UIViewController` subclasses are created programmatically to allow greater flexibility of customisation compared to using Storyboards. If you are using Storyboards to load your views, the [`StoryboardLoader`](http://thedistance.github.io/TheDistanceCore/Protocols/StoryboardLoader.html) protocol from [TheDistanceCore] is recommended. 

Complex views can be constructed using `UIViewController`s holding multiple `ViewModel` objects.

### ViewModels

ViewModels perform logic. They use [ReactiveCocoa] signals to imply their inputs and outputs without the need to specify parameters if a closure based syntax was used, as is typical in an MVC architecture. It is also a much less verbose and more transparent set up than the [Viper](https://www.objc.io/issues/13-architecture/viper/) architecture.

ViewModels that provide content asynchronously should subclass `ContentLoadingViewModel` from [TDCContentLoading]. This sets up the signals for observing `ViewLifetime` events and sending loading and error events back to the Views. It is all wrapped up in a convenient . The content can be asynchronously loaded by overriding the `loadingProducerWithInput(_:)` method. For networking requests using [ReactiveCocoa] we strongly recommend [ReactiveCocoaConvenience].

### Testability

Alongside modularity ViewModels provide easy testability. An `XCTestCase` class can bind the results of signals to properties and send the signal inputs in place of UI interactions. Asynchronous testing can be implemented simply using the [Nimble] framework. We will endeavour to have tests for all pieces of functionality.

Component ViewModel Tests should not query the network (although app 
tests that validate the server responses may be beneficial). Instead, expected responses can be saved to local json files. [TDCContentLoading] has furter details on how to mock API responses for ViewModels.

`UIViewController`s will typically communicate with ViewModels by binding UI Signals to the ViewModel Signals. Providing your `UIViewController` subclass uses dependency injection, you can create UI Testing targets in Xcode which inject the `UIViewController`s with ViewModels that return static content instantly. This will allow you to test user workflows throughout your app.

### Modularity

*[TDCAppDependencies] for consistent singleton structure and dependency injection.*

### Further Reading

The above is a very brief overview of the key points of the MVVM architecture. Each section has its own in depth ReadMe and documentation. For more information on the topics cover here, try the following:

* Protocols vs Subclasses: [WWDC Video](https://developer.apple.com/videos/play/wwdc2015/408/), [Ray Wenderlich Tutorial](https://www.raywenderlich.com/109156/introducing-protocol-oriented-programming-in-swift-2)
* Martin Richter's excellent blog series about MVVM in iOS using ReactiveCocoa: [Blog about MVVM with ReactiveCocoa](http://www.martinrichter.net/)
* The [ReactiveCocoa] GitHub page.

## Communication

If you have any queries / suggestions we'd love you to get in touch.

- If you have **found a bug**, open an issue.
- If you have **a feature request**, open an issue.
- If you **want to contribute**, submit a pull request.
- If you'd like to **ask a general question**, email us on <hello+thedistancecomponents@thedistance.co.uk>.

[Viper]: https://www.objc.io/issues/13-architecture/viper/

[TDCAppDependencies]: ReadMe-TDCAppDependencies.md
[TDCContentLoading]: ReadMe-TDCContentLoading.md

[TheDistanceCore]: https://github.com/thedistance/TheDistanceComponents

[Carthage]: https://github.com/Carthage/Carthage
[Cocoapods]: https://cocoapods.org

[Nimble]: https://github.com/Quick/Nimble
[AsyncDisplayKit]: https://github.com/Facebook/AsyncDisplayKit

[ReactiveCocoa]: https://github.com/ReactiveCocoa/ReactiveCocoa
[ReactiveCocoaConvenience]: https://github.com/joshc89/ReactiveCocoaConvenience
[Alamofire]: https://github.com/Alamofire/Alamofire
