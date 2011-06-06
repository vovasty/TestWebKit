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
@end