//
//  AppDependenciesSingleton.h
//
//  Created by Josh Campion on 22/01/2016.
//

#import <Foundation/Foundation.h>

/// Class that offers a singleton property that initialises as a subclass' type. This cannot be acheived in Swift, but can in Objective-C.
@interface AppDependenciesSingleton : NSObject

/// The shared instance of an `AppDependenciesSingleton` or its subclass, whichever is referenced in execution first.
+(instancetype _Nonnull)sharedDependencies;

@end
