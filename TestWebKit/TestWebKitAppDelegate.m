//
//  TestWebKitAppDelegate.m
//  TestWebKit
//
//  Created by Vladimir Solomenchuk on 01.06.11.
//  Copyright 2011 none. All rights reserved.
//

#import "TestWebKitAppDelegate.h"

#import "BMLibraryViewController.h"

@implementation TestWebKitAppDelegate

@synthesize window=_window;

@synthesize navigationController=_navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)dealloc
{
    [_window release];
    [_navigationController release];
    [super dealloc];
}

@end
