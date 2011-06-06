//
//  BMReadController.h
//  TestWebKit
//
//  Created by Vladimir Solomenchuk on 06.06.11.
//  Copyright 2011 none. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMRenderer.h"

@class BMEpub;
@interface BMReadController : UIViewController<BMRendererDelegate>
{
    BMRenderer* mRenderer;
    UILabel* mPageInfo;
}

@property(nonatomic, retain) BMEpub* book;
@end
