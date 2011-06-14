//
//  BMWebViewRenderer.m
//  TestWebKit
//
//  Created by Vladimir Solomenchuk on 06.06.11.
//  Copyright 2011 none. All rights reserved.
//

#import "BMWebViewRenderer.h"
#import "TapDetectingWindow.h"
#import "Compatibility.h"
#import "JSONKit.h"

@interface BMWebViewRenderer (Private) 
- (void) paginate;
- (void) sendTapEvent:(NSValue*) point;
@end

@implementation BMWebViewRenderer
@synthesize numberOfPages;


- (void) setup
{
    mWebView = [[UIWebView alloc] initWithFrame:self.bounds];
    mWebView.autoresizingMask =  UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    mWebView.delegate = self;
    mWebView.dataDetectorTypes = UIDataDetectorTypeNone;
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


- (void) setCurrentPage:(NSUInteger) page
{
    NSString *js = [NSString stringWithFormat:@"__bm.setPage(%u)", page];
    NSString* result = [mWebView stringByEvaluatingJavaScriptFromString:js];
    mCurrentPage = page;
}

- (NSUInteger) currentPage
{
    return mCurrentPage;
}

- (BMLink*) linkAtPoint:(CGPoint) point
{
    NSString* js = [NSString stringWithFormat:@"__bm.linkAtCGPoint(%d,%d)", (int)point.x, (int)point.y];
    NSString *res = [mWebView stringByEvaluatingJavaScriptFromString:js];
    
    if ( [@"" isEqualToString:res] )
        return nil;

    NSDictionary* linkDict = [res objectFromJSONString];
    BMLink* link = [[BMLink alloc] init];
    NSDictionary* linkFrame = [linkDict objectForKey:@"frame"];
    link.frame = CGRectMake([[linkFrame objectForKey:@"x"] floatValue], [[linkFrame objectForKey:@"y"] floatValue], [[linkFrame objectForKey:@"width"] floatValue], [[linkFrame objectForKey:@"height"] floatValue]);
    link.text = [linkDict objectForKey:@"text"];
    link.attributes = [linkDict objectForKey:@"attributes"];
    return [link autorelease];
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
    [self.delegate renderer:self willStartRender:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *paginateFunctions = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"paginate" ofType:@"js"] encoding:NSUTF8StringEncoding error:NULL];
    [mWebView stringByEvaluatingJavaScriptFromString:paginateFunctions];
    
    NSString *loadCSS = [NSString stringWithFormat:@"__bm.loadResource('%@','css');", [[NSBundle mainBundle] pathForResource:@"paginate" ofType:@"css"]];
    
    [mWebView stringByEvaluatingJavaScriptFromString:loadCSS];
    [self paginate];
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request 
 navigationType:(UIWebViewNavigationType)navigationType { 
    NSURL* url  = [request URL];
    return url.isFileURL && !url.fragment; 
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error { 
}

#pragma mark -
#pragma mark TapDetectingWindowDelegate methods

- (void)userDidTapWebView:(NSValue *)tapPoint 
{
    [NSTimer cancelPreviousPerformRequestsWithTarget:self];
//    [self performSelector:@selector(sendTapEvent:) withObject:tapPoint afterDelay:.5f];
    [self sendTapEvent:tapPoint];
}

- (void)userDidScrollWebView:(NSValue *)tapPoint {
}


- (void) layoutSubviews
{
	[super layoutSubviews];
	
    [self paginate];
}


#pragma mark Private
- (void) paginate;
{
    NSString *js = [NSString stringWithFormat:@"__bm.paginate(%d);", (KADeviceIsIPad() && UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation))?2:1];
    NSString* result = [mWebView stringByEvaluatingJavaScriptFromString:js];
    self.numberOfPages = [result intValue];
    self.currentPage = 0;
    [self.delegate renderer:self didFinishRender:YES];
}

- (void) sendTapEvent:(NSValue*) point
{
    [self.delegate renderer:self didTappedAtPoint:[point CGPointValue]];
}
@end
