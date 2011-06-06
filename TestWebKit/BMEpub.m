//
//  BMEpub.m
//  TestWebKit
//
//  Created by Vladimir Solomenchuk on 06.06.11.
//  Copyright 2011 none. All rights reserved.
//

#import "BMEpub.h"
#import "ZipArchive.h"
#import "FileSystemUtilities.h"
#import "TFHpple.h"

@implementation BMEpub

-(id) initWithFile:(NSString*) path
{
    self = [super init];
    if (self) 
    {
        mPath = [path retain];
    }
    
    return self;
}


-(BOOL) extract
{
    if ( mPathExtracted )
        return YES;
    
    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:[mPath lastPathComponent]];

    [[NSFileManager defaultManager]  createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];

    ZipArchive* zip = [[ZipArchive alloc] init];
    [zip UnzipOpenFile:mPath];
    
    BOOL res = [zip UnzipFileTo:path overWrite:YES];
    
    [zip UnzipCloseFile];
    [zip release];
    
    if ( res )
        mPathExtracted = [path retain];
    
    return res;
}

-(NSArray*) spine
{
    if ( !mSpine )
    {
        if ( ![self extract] )
            return nil;
        NSData *manifestData = [[NSData alloc] initWithContentsOfFile:[[mPathExtracted stringByAppendingPathComponent:@"META-INF"] stringByAppendingPathComponent:@"container.xml"] ];
        
        TFHpple* manifestParser = [[TFHpple alloc] initWithHTMLData:manifestData];
        
        NSArray *rootFiles  = [manifestParser search:@"//container/rootfiles/rootfile"];
        TFHppleElement* contentElement = [rootFiles objectAtIndex:0];
        NSString *contentPath = [mPathExtracted stringByAppendingPathComponent:[contentElement objectForKey:@"full-path"]];

        [manifestData release];
        [manifestParser release];
        
        NSData *contentData = [[NSData alloc] initWithContentsOfFile:contentPath];
        TFHpple* contentParser = [[TFHpple alloc] initWithHTMLData:contentData];
        NSArray* manifestItems = [contentParser search:@"//package/manifest/item"];
        
        mManifest = [[NSMutableDictionary alloc] initWithCapacity:[manifestItems count]];
        
        for ( TFHppleElement* item in manifestItems )
        {
            NSMutableDictionary* itemDict = [NSMutableDictionary dictionaryWithCapacity:2];
            [itemDict setObject:[item objectForKey:@"id"] forKey:@"id"];
            [itemDict setObject:[mPathExtracted stringByAppendingPathComponent:[item objectForKey:@"href"]] forKey:@"path"];
            [mManifest setObject:itemDict forKey:[item objectForKey:@"id"]];
        }
        
        NSArray *spineRefs  = [contentParser search:@"//package/spine/itemref"];
        mSpine = [[NSMutableArray alloc] initWithCapacity:[spineRefs count]];
        for ( TFHppleElement* ref in spineRefs )
        {
            NSMutableDictionary* itemDict = [mManifest objectForKey:[ref objectForKey:@"idref"]];
            if ( itemDict )
                [mSpine addObject:itemDict];
        }
                                
    }
    
    return mSpine;
}

- (void)dealloc
{
    [mPath release];
    [mPathExtracted release];
    [mSpine release];
    [super dealloc];
}

@end
