//
//  BMWebViewRenderer.h
//  TestWebKit
//
//  Created by Vladimir Solomenchuk on 06.06.11.
//  Copyright 2011 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMRenderer.h"
#import "TapDetectingWindow.h"

@interface BMWebViewRenderer : BMRenderer<UIWebViewDelegate, TapDetectingWindowDelegate>
{
@private
    UIWebView* mWebView;
    TapDetectingWindow* mWindow;
}
@end
