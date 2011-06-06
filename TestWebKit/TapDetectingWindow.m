//
//  TapDetectingWindow.m
//  TestWebKit
//
//  Created by Vladimir Solomenchuk on 06.06.11.
//  Copyright 2011 none. All rights reserved.
//  http://three20.pypt.lt/uiwebview-tap-scroll-detection
//

#import "TapDetectingWindow.h"

@implementation TapDetectingWindow

@synthesize viewToObserve, controllerThatObserves;


- (id)initWithViewToObserver:(UIView *)view andDelegate:(id)delegate {
	if (self == [super init]) {
		self.viewToObserve = view;
		self.controllerThatObserves = delegate;
	}
    
	return self;
}

- (void)dealloc {
	[viewToObserve release];
    
	[super dealloc];
}

- (void)forwardTap:(id)touch {
	[controllerThatObserves userDidTapWebView:touch];
}

- (void)forwardScroll:(id)touch {
	[controllerThatObserves userDidScrollWebView:touch];
}

- (void)sendEvent:(UIEvent *)event {
    
	[super sendEvent:event];
    
	if (viewToObserve == nil || controllerThatObserves == nil) {
		return;
	}
    
	NSSet *touches = [event allTouches];
	if (touches.count != 1) {
		return;
	}
    
	UITouch *touch = touches.anyObject;
    
	if (touch.phase == UITouchPhaseBegan) {
		scroll = NO;	// default
	}
    
	if (touch.phase == UITouchPhaseMoved) {
		scroll = YES;
	}
    
	if (touch.phase != UITouchPhaseEnded) {
		return;
	}
    
	if ([touch.view isDescendantOfView:viewToObserve] == NO) {
		return;
	}
    
	CGPoint tapPoint = [touch locationInView:viewToObserve];
    
    NSValue* pointValue =[NSValue valueWithCGPoint:tapPoint];
    
	if (touch.tapCount == 1) {
        
		if (scroll) {
			[self performSelector:@selector(forwardScroll:)
                       withObject:pointValue
                       afterDelay:0.5];
		} else {
			[self performSelector:@selector(forwardTap:)
                       withObject:pointValue
                       afterDelay:0.5];
		}
        
	}
	else if (touch.tapCount > 1) {
        
		if (scroll) {
			[NSObject cancelPreviousPerformRequestsWithTarget:self
                                                     selector:@selector(forwardScroll:)
                                                       object:pointValue];
		} else {
			[NSObject cancelPreviousPerformRequestsWithTarget:self
                                                     selector:@selector(forwardTap:)
                                                       object:pointValue];			
		}
	}
}

@end