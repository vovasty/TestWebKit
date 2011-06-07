//
//  BMAnnotationController.m
//  TestWebKit
//
//  Created by Vladimir Solomenchuk on 07.06.11.
//  Copyright 2011 none. All rights reserved.
//

#import "BMAnnotationController.h"
#import "BMRenderer.h"

@implementation BMAnnotationController
@synthesize link;

-(void) releaseTopLevelObjects
{
    [mTextView release]; mTextView = nil;
}

- (void)dealloc
{
    [self releaseTopLevelObjects];
    self.link = nil;
    [super dealloc];
}

- (void) setLink:(BMLink*)aLink
{
    if ( aLink != link )
    {
        [link release];
        link = [aLink retain];
    }
    
    mTextView.text = [link.attributes objectForKey:@"title"];
    self.title = link.text;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
