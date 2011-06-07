//
//  Compatibility.m
//  BookmateReader
//
//  Created by Konstantin Anoshkin on 31.08.10.
//  Copyright 2010 K. Anoshkin. All rights reserved.
//

#import "Compatibility.h"


void KAGraphicsBeginImageContextWithOptions(CGSize size, BOOL opaque, CGFloat scale)
{
	if ( &UIGraphicsBeginImageContextWithOptions )
		UIGraphicsBeginImageContextWithOptions(size, opaque, scale);
	else
		UIGraphicsBeginImageContext(size);
}


BOOL KADeviceIsIPad(void)
{
	static int sInterfaceIdiom = -1;
	if ( sInterfaceIdiom < UIUserInterfaceIdiomPhone )
		sInterfaceIdiom = [[UIDevice currentDevice] respondsToSelector: @selector(userInterfaceIdiom)] ? [[UIDevice currentDevice] userInterfaceIdiom] : UIUserInterfaceIdiomPhone;
	return ( sInterfaceIdiom == UIUserInterfaceIdiomPad );
}
