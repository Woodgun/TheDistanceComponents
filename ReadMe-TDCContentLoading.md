# TDCContentLoading

Consistent Asynchronous Loading

This is a sub-framework of a [TheDistanceComponents].  There are more sub-frameworks adding extra functionality and a whole lot more planned, including UI for Content Loaders.

## Features

* [x] Standard StateModel & ViewModel for handling network requests in MVVM
* [x] View Lifetime properties delivered using ReactiveCocoa
* [x] Standardised cases for List Loading including paging content
* [x] [Documentation](http://thedistance.github.io/TheDistanceComponents/TDCContentLoading/index.html)

## Dependencies

* [ReactiveCocoa]

## Getting Started

*This set up was inspired by [Martin Richter's excellent blog series about MVVM in iOS using ReactiveCocoa](http://www.martinrichter.net/)*

TDCContentLoading is based around a ViewModel object: [`ContentLoadingViewModel`](http://thedistance.github.io/TheDistanceComponents/TDCContentLoading/Classes/ContentLoadingViewModel.html). The definition might appear convoluted at first glance, however asynchronous loading becomes very trivial if you just subclasses the necesseary methods:

0. Define the type of content you will be loading:
	
		class MyModel { ... }

0. Create a subclass of `ContentLoadingViewModel` typed to your output and override `loadingProducerWithInput(_:)` to return a [ReactiveCocoa] SignalProducer that loads your content ([ReactiveCocoaConvenience] provides simple APIs for this):

		class MyContentLoader : ContentLoadingViewModel<Void, MyModel> { 

			func loadingProducerWithInput(input: Void?) -> SignalProducer<MyModel, NSError> {
				return Alamofire.Get("https://api.mysite/get/my/model")
					.validate()
					.rac_responseSwiftyJSONCreated()
			}
		}
	   
0. Bind any UI properties in your `UIViewController` (or other View object) to the Output Properties of your `ContentLoadingViewModel`:
	
		let viewModel = MyContentLoader()
	   
		override func viewDidLoad(animated:Bool)  {
			super.viewDidLoad(animated)
	   
			errorLabel.rac_text <~ viewModel.errorSignal.map { $0.localizedDescription }
			loadingView.rac_hidden <~ viewModel.isLoading.signal.map { !$0 }
	     
			viewModel.contentChangesSignal.observeNext { newValue in
	           // Update the UI
	           ...
			}
		}

0. Trigger loading by sending `.Next(_)` events:

		func buttonTapped() {
			viewModel.refreshObsever.sendNext(_)
		}
	
   
For a simple ViewModel example see [TDCContentLoadingTests.swift](https://github.com/thedistance/TheDistanceComponents/blob/master/TDCContentLoadingTests/TDCContentLoadingTests.swift).
A consistent structure for UI based on `ContentLoadingViewModel` is coming soon. An indepth look at how `ContentLoadingViewModel` works is given below.

### Lists & Paging

*More detail to come soon...*

## ContentLoadingView Model In Depth

### Content Loading

This component is for fetching and serialising content asynchronously and reporting the progress in a standard way. Rather than considering fetching data from a network, think instead of the entire process from user interaction to beginning the request, showing loading is ongoing, and reporting a successful serialized Model object or a failure. 

#### State Changes

The loading process is represented by the [`ContentLoadingState`](http://thedistance.github.io/TheDistanceComponents/TDCContentLoading/Enums/ContentLoadingState.html) enum.

	public enum ContentLoadingState<ValueType> {
    
    	/// No fetch has been initiated yet.
    	case Unloaded
    
    	/// Content has been requested successfully but nothing is found
    	case Empty
    
    	/// A network request is currently in progress.
    	case Loading
    
    	/// A request has successfully completed with content.
    	case Success(ValueType)
    
    	/// A request has failed with the given error.
    	case Error(NSError)
	}

The `ContentLoadingViewModel` is the ViewModel object used to manage asynchronous loading, typically started as a result of user interaction in a View. It sends `ContentLoadingState` updates through [ReactiveCocoa] signals on the `state` property. If elements of the View are only interested in a single state, they can observe the individual properties:

* `isLoading`
* `contentChangesSignal`
* `errorSignal`

The request is triggered by sending an event to the `refreshObserver` which starts the SignalProducer returned from `loadingProducerWithInput(_:)`, which subclasses should override. This sets:

* `isLoading -> true`
* `state -> .Loading`

The SignalProducer returned from `loadingProducerWithInput(_:)` could initiate a network request ([ReactiveCocoaConvenience] provides simple APIs for this) or other form of loading.

If that SignalProducer fails, the error is sent through the `errorSignal` property on the `ContentLoadingViewModel` and

* `isLoading -> false`
* `state -> .Error(_)`

The networking error as is the state's associated value.

If the request succeeds, the new value is sent through the `contentChangesSignal`. The result is tested for being 'empty' using `contentIsEmpty(_:)`, which subclasses should override. The `.Empty` state is explicitly defined as UI will often differ to show the user that there is nothing there, rather than a blank list with no context.

If `contentIsEmpty(_:) == true`:

* `isLoading -> false`
* `state -> .Empty`

else 

* `isLoading -> false`
* `state -> .Success(_)`

The associated value of the `.Success(_)` state is the associated value of the `.Next(_)` event of the `SignalProducer` from returned from `loadingProducerWithInput(_:)`.

#### View Lifetime Events

`ContentLoadingViewModel` has a property that can be bound to the `ViewLifetimeSignal` of a `ReactiveAppearanceViewController`:

	let viewLifetime = MutableProperty<ViewLifetime>(.Init)
	
This is used to observer changes on the View object this ViewModel is providing logic for. It is also initialised with an optional `ViewLifetime` parameter. When the values of the `viewLifetime` property changes, if it equals this parameter a refresh is triggered. This is useful for triggering or cancelling requests on view lifecycle events such as `viewWillAppear(_:)` and `viewDidDisappear(_:)`.

### Testing Content Loaders

A major goal for [TheDistanceComponents] is to increase testability, part of which is testing Model objects are initialised correctly from the data fetched. 

To provide the flexibility to mock API responses, first define a `URLStore` - a uniqure-per-app protocol defining all the required URLs. 

	protocol URLStore {
		var eventListURL: NSURL { get }
	}

An `APIManager` should then have an `init(urlStore:URLStore)` initialiser so the endpoints aren't hard-coded in the `APIManager`, this is known as Dependency Injection.

	class APIManager {
	
		let urlStore:URLStore
	
		init(urlStore:URLStore) {
			self.urlStore = urlStore
		}
	
		...
	}
	
You can then define a `URLStore` that provides URLs for local resources, and one that provides network URLs:

	class LiveURLStore {
		let eventListURL = NSURL(string: "https://api.myevents.com/all")
	}
	
	class TestURLStore {
		let eventListURL = NSBundle(forClass: TestURLStore.self).URLForResource("TestEventsList", withExtension: "json")!
	}
	
The `APIManager` can then define methods to fetch and serialize content independent of whether it is a live or local resource:

	class APIManager {
		
		...
		
		func getAllEvents() -> SignalProducer<(JSON, [Event]), NSError> {
			
			return Alamofire.GET(urlStore.eventListURL)
			  .validate()
			  .rac_responseArraySwiftyJSONCreated()
		}
	}
	
---	
*`rac_responseArraySwiftyJSONCreated()` is a convenience method from [ReactiveCocoaConvenience], which includes simple methods for using [Alamofire] and [ReactiveCocoa] to serialise network responses into Model objects.*

---

Depedency Injection is used again in your ViewModel to specify the APIManager that should be used:

	class MyViewModel: ContentLoadingViewModel<Void, [Event]> {
	
		let apiManager: APIManager
	
		init(apiManager: APIManager) {
			self.apiManager = APIManager
			...
		}
		
		override func loadingProducerWithInput(input: Void?) -> SignalProducer<[Event], NSError> {
			return apiManager.getAllEvents.map { $0.1 }
		}
	}

Finally, in your `XCTestCase` you will create your `APIManager` with your test URLs, and `MyViewModel` with that `APIManager`:

	class MyTests: XCTestCase {
	
		let testAPIManager = APIManager(urlStore: TestURLStore() )
		let viewModel: MyViewModel!
		
		func setUp() {
			
			// create a new ViewModel for each test so no state is preseverd between tests
			viewModel = MyViewModel(apiManager: testAPIManager)
		}
		

To add further flexibility, you can define `APIManager` as a protocol:

	protocol APIManager {
		
		init(urlStore: URLStore)
		
		func getAllEvents() -> SignalProducer<(JSON, [Event]), NSError>
	}

This would allow different implementations of APIManagers, perhaps if different libraries are available on different platforms. 

## Communication

If you have any queries / suggestions we'd love you to get in touch.

- If you have **found a bug**, open an issue.
- If you have **a feature request**, open an issue.
- If you **want to contribute**, submit a pull request.
- If you'd like to **ask a general question**, email us on <hello+thedistancecomponents@thedistance.co.uk>.


[ReactiveCocoa]: https://github.com/ReactiveCocoa/ReactiveCocoa
[ReactiveCocoaConvenience]: https://github.com/joshc89/ReactiveCocoaConvenience
[Alamofire]: https://github.com/Alamofire/Alamofire
[TheDistanceComponents]: https://github.com/thedistance/thedistancecomponents
