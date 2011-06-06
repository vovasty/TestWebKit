//
//  FileSystemUtilities.h
//  BookmateReader
//
//  Created by Konstantin Anoshkin on 7.04.10.
//  Copyright 2010 K. Anoshkin. All rights reserved.
//

#import <Foundation/Foundation.h>


#if TARGET_IPHONE_SIMULATOR
	// On iPhone Simulator NSTemporaryDirectory() returns a Mac OS X temporary directory which is outside our application sandbox.
	// For consistency's sake we want to make it behave as on an honest-to-goodness iPhone device.
	NSString *KATemporaryDirectory ( void );
	#define NSTemporaryDirectory() KATemporaryDirectory()
#endif

NSString *KADocumentsDirectory ( void );
NSString *KACachesDirectory ( void );
