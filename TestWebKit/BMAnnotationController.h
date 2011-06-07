//
//  BMAnnotationController.h
//  TestWebKit
//
//  Created by Vladimir Solomenchuk on 07.06.11.
//  Copyright 2011 none. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BMLink;
@interface BMAnnotationController : UIViewController 
{
    IBOutlet UITextView* mTextView;
}

@property (nonatomic, retain) BMLink* link;
@end
