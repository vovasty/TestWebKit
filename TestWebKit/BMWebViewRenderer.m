//
//  BMWebViewRenderer.m
//  TestWebKit
//
//  Created by Vladimir Solomenchuk on 06.06.11.
//  Copyright 2011 none. All rights reserved.
//

#import "BMWebViewRenderer.h"
#import "TapDetectingWindow.h"

@interface BMWebViewRenderer (Private) 
- (void) paginate;
@end

@implementation BMWebViewRenderer
@synthesize numberOfPages;


- (void) setup
{
    mWebView = [[UIWebView alloc] initWithFrame:self.bounds];
    mWebView.autoresizingMask =  UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    mWebView.delegate = self;
    [self addSubview:mWebView];
    [mWebView release];
    
    mWindow = (TapDetectingWindow *)[[UIApplication sharedApplication].windows objectAtIndex:0];
	mWindow.viewToObserve = mWebView;
	mWindow.controllerThatObserves = self;
}

- (id) initWithCoder: (NSCoder *) coder
{
	if ( (self = [super initWithCoder: coder]) ) 
    {
		[self setup];
	}
	
	return self;
}


- (id)initWithFrame:(CGRect)frame 
{
    if ( (self = [super initWithFrame:frame]) ) 
    {
        [self setup];
    }
    return self;
}

#pragma mark BMRenderer;
- (void) loadFile:(NSString*) path
{
    [mWebView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path isDirectory:NO]]];
}

- (void)dealloc
{
    mWindow = (TapDetectingWindow *)[[UIApplication sharedApplication].windows objectAtIndex:0];
	mWindow.viewToObserve = nil;
	mWindow.controllerThatObserves = nil;
    [super dealloc];
}

#pragma UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
//    mWebView.hidden = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *paginateFunctions = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"paginate" ofType:@"js"] encoding:NSUTF8StringEncoding error:NULL];
    [mWebView stringByEvaluatingJavaScriptFromString:paginateFunctions];
    
    NSString *loadCSS = [NSString stringWithFormat:@"loadResource('%@','css');", [[NSBundle mainBundle] pathForResource:@"paginate" ofType:@"css"]];
    
    [mWebView stringByEvaluatingJavaScriptFromString:loadCSS];
    [self paginate];
    [self.delegate renderer:self contentDidRendered:YES];
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request 
 navigationType:(UIWebViewNavigationType)navigationType { 
    return YES; 
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error { 
}

#pragma mark -
#pragma mark TapDetectingWindowDelegate methods

- (void)userDidTapWebView:(NSArray *)tapPoint {
	// x and y points are NSStrings
	NSLog(@"tap at x = %@, y = %@", [tapPoint objectAtIndex:0], [tapPoint objectAtIndex:1]);
}

- (void)userDidScrollWebView:(NSArray *)tapPoint {
	// x and y points are NSStrings
	NSLog(@"scroll at x = %@, y = %@", [tapPoint objectAtIndex:0], [tapPoint objectAtIndex:1]);
}


- (void) layoutSubviews
{
	[super layoutSubviews];
	
    [self paginate];
}


#pragma mark Private
- (void) paginate;
{
    NSString *js = [NSString stringWithFormat:@"paginate(%d,%d,%d);", (NSUInteger)CGRectGetWidth(mWebView.frame), (NSUInteger)CGRectGetHeight(mWebView.frame)-10, UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)?1:2];
    NSString* result = [mWebView stringByEvaluatingJavaScriptFromString:js];
    self.numberOfPages = [result intValue];
//    mCurrentOffset = 0;
//    mCurrentPage = 1;
//    
//    mButtonDown.enabled = YES;
//    mButtonUp.enabled = YES;
//    mButtonPaginate.enabled = NO;
//    mWebView.hidden = NO;
}
@end
