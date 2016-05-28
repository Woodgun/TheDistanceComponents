//
//  AppDependenciesSingleton.h
//
//  Created by Josh Campion on 22/01/2016.
//

#import "AppDependenciesSingleton.h"

@implementation AppDependenciesSingleton

+(instancetype)sharedDependencies
{
    static AppDependenciesSingleton *shared = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[[self class] alloc] init];
    });
    
    return shared;
}

@end
