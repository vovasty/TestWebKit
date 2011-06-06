//
//  BMWebViewRenderer.h
//  TestWebKit
//
//  Created by Vladimir Solomenchuk on 06.06.11.
//  Copyright 2011 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMRenderer.h"

@interface BMWebViewRenderer : UIView<UIWebViewDelegate, BMRenderer>
{
@private
    UIWebView* mWebView;
}

@property (nonatomic) NSUInteger numberOfPages;
@end
