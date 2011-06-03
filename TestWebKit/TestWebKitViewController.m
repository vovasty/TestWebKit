//
//  TestWebKitViewController.m
//  TestWebKit
//
//  Created by Vladimir Solomenchuk on 01.06.11.
//  Copyright 2011 none. All rights reserved.
//

#import "TestWebKitViewController.h"

@implementation TestWebKitViewController

- (void) releaseTopLevelObjects
{
    [mWebView release]; mWebView = nil;
    [mStatus release]; mStatus = nil;
    [mButtonUp release]; mButtonUp = nil;
    [mButtonDown release]; mButtonDown = nil;
    [mButtonPaginate release]; mButtonPaginate = nil;

}

- (void)dealloc
{
    [self releaseTopLevelObjects];
    [super dealloc];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self releaseTopLevelObjects];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


- (void) startTimer
{
    mTimerStart = CFAbsoluteTimeGetCurrent();
}

- (void) reportTimer:(NSString*) prefix
{
    mStatus.text = [NSString stringWithFormat:@"%@:%f", prefix, CFAbsoluteTimeGetCurrent() - mTimerStart];
}

- (void) nextPage:(int) direction
{
    mCurrentPage += direction;

    if ( mCurrentPage < 0 )
    {
        mCurrentPage = 1;
        return;
    }
    else if ( mCurrentPage > mNumberOfPages )
    {
//        mCurrentPage = mNumberOfPages;
//        return;
    }
    
    mCurrentOffset += direction * (NSUInteger)CGRectGetWidth(mWebView.frame);
    NSString *js = [NSString stringWithFormat:@"scrollToPosition(%d)", mCurrentOffset];
    NSString* result = [mWebView stringByEvaluatingJavaScriptFromString:js];
    if ( [result isEqualToString:@"true"] )
        mStatus.text = [NSString stringWithFormat:@"%d/%d", mCurrentPage, mNumberOfPages];
    else
    {
//        [mWebView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"2" ofType:@"html"] isDirectory:NO]]];
        mStatus.text = @"this is the end";
    }
}

- (IBAction) pgUp:(id)sender
{
    [self nextPage: -1];
}

- (IBAction) pgDown:(id)sender
{
    [self nextPage: 1];
}

- (IBAction) paginate:(id)sender
{
    [self startTimer];
    NSString *js = [NSString stringWithFormat:@"paginate(%d,%d);", (NSUInteger)CGRectGetWidth(mWebView.frame), (NSUInteger)CGRectGetHeight(mWebView.frame)-10];
    NSString* result = [mWebView stringByEvaluatingJavaScriptFromString:js];
    mNumberOfPages = [result intValue];
    mCurrentOffset = 0;
    mCurrentPage = 1;
    [self reportTimer:@"pagination"];
    
    mButtonDown.enabled = YES;
    mButtonUp.enabled = YES;
    mButtonPaginate.enabled = NO;
}

- (void) loadIt:(NSString*) str
{
    if ( str != mLoaded )
    {
        [mLoaded release];
        mLoaded = [str retain];
    }
    [mWebView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:mLoaded ofType:@"html"] isDirectory:NO]]];
}

- (IBAction) load:(id)sender
{
    UIButton* b = (UIButton*)sender;
    [self loadIt:b.titleLabel.text];
}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self loadIt:mLoaded];
}

#pragma UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self startTimer];
    mStatus.text = @"loading...";
    mButtonUp.enabled = NO;
    mButtonDown.enabled = NO;
    mButtonPaginate.enabled = NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *paginateFunctions = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"paginate" ofType:@"js"] encoding:NSUTF8StringEncoding error:NULL];
    [mWebView stringByEvaluatingJavaScriptFromString:paginateFunctions];
    
    NSString *loadCSS = [NSString stringWithFormat:@"loadResource('%@','css');", [[NSBundle mainBundle] pathForResource:@"paginate" ofType:@"css"]];

    [mWebView stringByEvaluatingJavaScriptFromString:loadCSS];
    [self reportTimer:@"loading"];
    mButtonPaginate.enabled = YES;
    [self paginate:nil];
}
@end
