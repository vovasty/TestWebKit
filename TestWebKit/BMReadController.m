//
//  BMReadController.m
//  TestWebKit
//
//  Created by Vladimir Solomenchuk on 06.06.11.
//  Copyright 2011 none. All rights reserved.
//

#import "BMReadController.h"
#import "BMWebViewRenderer.h"
#import "BMEpub.h"

@implementation BMReadController
@synthesize book;

-(void) releaseTopLevelObjects
{
    [mRenderer release]; mRenderer = nil;
    [mPageInfo release]; mPageInfo = nil;
}

- (void)dealloc
{
    self.book = nil;
    [super dealloc];
}

-(void) setBook:(BMEpub *)aBook
{
    if ( book != aBook )
    {
        [book release];
        book = [aBook retain];
    }
    
    NSDictionary* firstItem = [book.spine objectAtIndex:0];
    [mRenderer loadFile:[firstItem objectForKey:@"path"]];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    BMWebViewRenderer* renderer = [[BMWebViewRenderer alloc] initWithFrame:self.view.bounds];
    renderer.autoresizingMask =  UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:renderer];
    mRenderer = renderer;
    mRenderer.delegate = self;
    [renderer release];
    
    mPageInfo = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds) - 40, CGRectGetWidth(self.view.bounds) - 20, 30.f)];
    mPageInfo.backgroundColor = [UIColor clearColor];
    mPageInfo.textAlignment = UITextAlignmentRight;
    mPageInfo.autoresizingMask =  UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:mPageInfo];
    [mPageInfo release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.toolbarHidden = NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark BMRendererDelegate
- (void)renderer:(BMRenderer*)renderer contentDidRendered:(BOOL) flag
{
    mPageInfo.text = [NSString stringWithFormat:@"%@ %d %@ %d", NSLocalizedString(@"page", nil), 1, NSLocalizedString(@"of", nil), renderer.numberOfPages];
}
@end
