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
    [renderer release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.toolbarHidden = YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
