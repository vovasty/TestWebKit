//
//  TestWebKitViewController.h
//  TestWebKit
//
//  Created by Vladimir Solomenchuk on 01.06.11.
//  Copyright 2011 none. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestWebKitViewController : UIViewController<UIWebViewDelegate>
{
    IBOutlet UIWebView* mWebView;
    IBOutlet UILabel* mStatus;
    NSUInteger mCurrentOffset;
    NSUInteger mNumberOfPages;
    NSInteger mCurrentPage;
    
    CFAbsoluteTime mTimerStart;
    IBOutlet UIButton* mButtonUp;
    IBOutlet UIButton* mButtonDown;
    IBOutlet UIButton* mButtonPaginate;
    
    CGRect mWebFrame;
}

- (IBAction) pgUp:(id)sender;
- (IBAction) pgDown:(id)sender;
- (IBAction) paginate:(id)sender;
- (IBAction) load:(id)sender;
@end
