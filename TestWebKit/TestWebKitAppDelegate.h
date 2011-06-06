//
//  TestWebKitAppDelegate.h
//  TestWebKit
//
//  Created by Vladimir Solomenchuk on 01.06.11.
//  Copyright 2011 none. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BMLibraryViewController;

@interface TestWebKitAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end
