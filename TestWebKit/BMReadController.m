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
#import "BMAnnotationController.h"
#import "Compatibility.h"

#define kTapMargin 25.f
#define kTopPadding 25.f
#define kBottomPadding 25.f
#define kLeftPadding 25.f
#define kRightPadding 25.f

#define kIPadTapMargin 50.f
#define kIPadTopPadding 50.f
#define kIPadBottomPadding 50.f
#define kIPadLeftPadding 50.f
#define kIPadRightPadding 50.f


@implementation BMReadController
@synthesize book, currentItemIndex;

-(void) releaseTopLevelObjects
{
    [mRenderer release]; mRenderer = nil;
    [mPageInfo release]; mPageInfo = nil;
    [mAnnotationPopover dismissPopoverAnimated:NO];
    [mAnnotationPopover release]; mAnnotationPopover = nil;
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
    
    CGRect rendererFrame;
    if ( KADeviceIsIPad() )
        rendererFrame = CGRectMake(kIPadLeftPadding, kIPadTopPadding, CGRectGetWidth(self.view.bounds) - kIPadLeftPadding - kIPadRightPadding, CGRectGetHeight(self.view.bounds) - kIPadBottomPadding - kIPadTopPadding);
    else
        rendererFrame = CGRectMake(kLeftPadding, kTopPadding, CGRectGetWidth(self.view.bounds) - kLeftPadding - kRightPadding, CGRectGetHeight(self.view.bounds) - kBottomPadding - kTopPadding);
        
    BMWebViewRenderer* renderer = [[BMWebViewRenderer alloc] initWithFrame:rendererFrame];
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
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapped:)];
    tapRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapRecognizer];
    [tapRecognizer release];
    
//    self.view.backgroundColor = [UIColor blackColor];
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

- (void)viewWillDisappear:(BOOL)animated
{
    [mAnnotationPopover dismissPopoverAnimated:NO];
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

- (void) updatePageInfo
{
    mPageInfo.text = [NSString stringWithFormat:@"%d/%d %@", mRenderer.currentPage+1, mRenderer.numberOfPages, [[[book.spine objectAtIndex:self.currentItemIndex] valueForKey:@"path"] lastPathComponent]];
}

- (void) didTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    CGPoint point = [gestureRecognizer locationInView: self.view];
    
    if ( point.x < kTapMargin )
    {
        if ( mRenderer.currentPage )
        {
            mRenderer.currentPage = mRenderer.currentPage - 1;
            [self updatePageInfo];
        }
        else if ( self.currentItemIndex )
            self.currentItemIndex = self.currentItemIndex - 1;
    }
    else if ( (CGRectGetWidth(self.view.bounds) - point.x) < kTapMargin )
    {
        if ( (mRenderer.currentPage + 1) < mRenderer.numberOfPages )
        {
            mRenderer.currentPage = mRenderer.currentPage + 1;
            [self updatePageInfo];
        }
        else if ( self.currentItemIndex < [book.spine count] )
            self.currentItemIndex = self.currentItemIndex + 1;
    }
}


#pragma mark BMRendererDelegate
- (void)renderer:(BMRenderer*)renderer didTappedAtPoint:(CGPoint) point
{
    BMLink *link = [mRenderer linkAtPoint:point];
    if ( link )
    {
        if ( !mAnnotationPopover )
        {
            BMAnnotationController* controller = [[BMAnnotationController alloc] initWithNibName:@"BMAnnotationController" bundle:nil];
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
            mAnnotationPopover = [[UIPopoverController alloc] initWithContentViewController:navController];
            mAnnotationPopover.popoverContentSize = controller.view.bounds.size;
            [controller release];
            [navController release];
        }
        
        ((BMAnnotationController*)((UINavigationController*)mAnnotationPopover.contentViewController).topViewController).link = link;
        
        [mAnnotationPopover presentPopoverFromRect: link.frame inView:mRenderer permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    else
    {
        [self.navigationController setNavigationBarHidden:!self.navigationController.navigationBarHidden animated:YES];
        [self.navigationController setToolbarHidden:self.navigationController.navigationBarHidden animated:YES];
    }
}

- (void)renderer:(BMRenderer*)renderer willStartRender:(BOOL) flag
{
    self.view.hidden = YES;
}

- (void)renderer:(BMRenderer*)renderer didFinishRender:(BOOL) flag
{
    [self updatePageInfo];
    self.view.hidden = NO;
}

@end
