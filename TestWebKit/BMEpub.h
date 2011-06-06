//
//  BMEpub.h
//  TestWebKit
//
//  Created by Vladimir Solomenchuk on 06.06.11.
//  Copyright 2011 none. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BMEpub : NSObject {
@private
    NSString *mPath;
    NSString *mPathExtracted;
    NSMutableArray* mSpine;
    NSMutableDictionary* mManifest;
}

-(id) initWithFile:(NSString*) path;
@property (nonatomic, readonly) NSArray* spine;

@end
