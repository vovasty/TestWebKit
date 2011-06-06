//
//  BMWebViewRenderer.h
//  TestWebKit
//
//  Created by Vladimir Solomenchuk on 06.06.11.
//  Copyright 2011 none. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BMWebViewRenderer : UIView<UIWebViewDelegate>
{
@private
    UIWebView* mWebView;
}

@property (nonatomic) NSUInteger numberOfPages;
- (void) loadFile:(NSString*) path;
@end
