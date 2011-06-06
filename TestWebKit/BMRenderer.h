//
//  BMRenderer.h
//  TestWebKit
//
//  Created by Vladimir Solomenchuk on 06.06.11.
//  Copyright 2011 none. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol BMRenderer <NSObject>
- (void) loadFile:(NSString*) path;
@end
