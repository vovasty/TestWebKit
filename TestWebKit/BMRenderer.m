//
//  BMRenderer.h
//  TestWebKit
//
//  Created by Vladimir Solomenchuk on 06.06.11.
//  Copyright 2011 none. All rights reserved.
//

#import "BMRenderer.h"

@implementation BMRenderer
@synthesize delegate, numberOfPages;
@dynamic currentPage;

- (void) loadFile:(NSString*) path
{
    NSAssert(NO, @"Not implemented");
}
- (BMLink*) linkAtPoint:(CGPoint) point
{
    NSAssert(NO, @"Not implemented");
    return nil;
}
@end


@implementation BMLink
@synthesize attributes, frame, text;

- (NSString *) description
{
	return [NSString stringWithFormat: @"frame:%@\ntext:%@\nattributes:%@", NSStringFromCGRect(self.frame), self.text, self.attributes];
}

- (void)dealloc 
{
    self.attributes = nil;
    self.text = nil;
    [super dealloc];
}
@end