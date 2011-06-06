//
//  TapDetectingWindow.h
//  TestWebKit
//
//  Created by Vladimir Solomenchuk on 06.06.11.
//  Copyright 2011 none. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol TapDetectingWindowDelegate

- (void)userDidTapWebView:(NSValue *)tapPoint;
- (void)userDidScrollWebView:(NSValue *)tapPoint;

@end


@interface TapDetectingWindow : UIWindow {
    
	UIView *viewToObserve;
	id <TapDetectingWindowDelegate> controllerThatObserves;
	BOOL scroll;
}

@property (nonatomic, retain) UIView *viewToObserve;
@property (nonatomic, assign) id <TapDetectingWindowDelegate> controllerThatObserves;

@end