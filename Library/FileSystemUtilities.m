//
//  FileSystemUtilities.m
//  BookmateReader
//
//  Created by Konstantin Anoshkin on 7.04.10.
//  Copyright 2010 K. Anoshkin. All rights reserved.
//

#import "FileSystemUtilities.h"


#if TARGET_IPHONE_SIMULATOR
NSString *KATemporaryDirectory ( void )
{
	return [NSHomeDirectory() stringByAppendingPathComponent: @"tmp"];
}
#endif


NSString *KADocumentsDirectory ( void )
{
	static NSString *sDocumentsPath = nil;
	if ( sDocumentsPath == nil )
		sDocumentsPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] retain];
	return sDocumentsPath;
}


NSString *KACachesDirectory ( void )
{
	static NSString *sCachesPath = nil;
	if ( sCachesPath == nil )
		sCachesPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] retain];
	return sCachesPath;
}