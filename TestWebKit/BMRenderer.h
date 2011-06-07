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
- (void)renderer:(BMRenderer*)renderer didTappedAtPoint:(CGPoint) point;
- (void)renderer:(BMRenderer*)renderer willStartRender:(BOOL) flag;
- (void)renderer:(BMRenderer*)renderer didFinishRender:(BOOL) flag;
@end

@interface BMLink:NSObject
@property (nonatomic, retain) NSDictionary* attributes;
@property (nonatomic, retain) NSString* text;
@property (nonatomic) CGRect frame;
@end

@interface BMRenderer:UIView
- (void) loadFile:(NSString*) path;
@property (nonatomic, assign) id<BMRendererDelegate> delegate;
@property (nonatomic) NSUInteger numberOfPages;
@property (nonatomic) NSUInteger currentPage;
- (BMLink*) linkAtPoint:(CGPoint) point;
@end
