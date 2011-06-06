//
//  BMRenderer.h
//  TestWebKit
//
//  Created by Vladimir Solomenchuk on 06.06.11.
//  Copyright 2011 none. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BMRenderer;
@protocol BMRendererDelegate <NSObject>
- (void)renderer:(BMRenderer*)renderer contentDidRendered:(BOOL) flag;
@end

@interface BMRenderer:UIView
- (void) loadFile:(NSString*) path;
@property (nonatomic, assign) id<BMRendererDelegate> delegate;
@property (nonatomic) NSUInteger numberOfPages;
@end