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

#define kTapMargin 50.f

@implementation BMReadController
@synthesize book, currentItemIndex;

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
    self.currentItemIndex = 0;
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

#pragma mark Private
- (void) setCurrentItemIndex:(NSUInteger)index
{
    NSDictionary* item = [book.spine objectAtIndex:index];
    NSString *path = [item objectForKey:@"path"];
    if ( path )
        [mRenderer loadFile:path];
    currentItemIndex = index;
}

#pragma mark BMRendererDelegate
- (void)renderer:(BMRenderer*)renderer contentDidRendered:(BOOL) flag
{
    mPageInfo.text = [NSString stringWithFormat:@"%d/%d %@", 1, renderer.numberOfPages, [[[book.spine objectAtIndex:self.currentItemIndex] valueForKey:@"path"] lastPathComponent]];
}

- (void)renderer:(BMRenderer*)renderer didTappedAtPoint:(CGPoint) point
{
    if ( point.x < kTapMargin )
    {
        if ( mRenderer.currentPage )
            mRenderer.currentPage = mRenderer.currentPage - 1;
        else if ( self.currentItemIndex )
            self.currentItemIndex = self.currentItemIndex - 1;
    }
    else if ( (CGRectGetWidth(self.view.bounds) - point.x) < kTapMargin )
    {
        if ( (mRenderer.currentPage + 1) < mRenderer.numberOfPages )
            mRenderer.currentPage = mRenderer.currentPage + 1;
        else if ( self.currentItemIndex < [book.spine count] )
            self.currentItemIndex = self.currentItemIndex + 1;
    }
    else
    {
        [self.navigationController setNavigationBarHidden:!self.navigationController.navigationBarHidden animated:YES];
        [self.navigationController setToolbarHidden:self.navigationController.navigationBarHidden animated:YES];
    }
}
@end
