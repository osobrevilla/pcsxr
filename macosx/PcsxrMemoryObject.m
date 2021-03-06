//
//  PcsxrMemoryObject.m
//  Pcsxr
//
//  Created by Charles Betts on 11/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PcsxrMemoryObject.h"
#import <Foundation/NSString.h>
#import <AppKit/NSColor.h>
#import <AppKit/NSImage.h>

@implementation PcsxrMemoryObject

+ (NSImage *)imageFromMcd:(short *)icon
{
	NSBitmapImageRep *imageRep = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:NULL pixelsWide:16 pixelsHigh:16 bitsPerSample:8 samplesPerPixel:3 hasAlpha:NO isPlanar:NO colorSpaceName:NSCalibratedRGBColorSpace bytesPerRow:0 bitsPerPixel:0];
	
#if 0
	int x, y, c;
	for (y = 0; y < 32; y++) {
		for (x = 0; x < 32; x++) {
			c = icon[(y>>1) * 16 + (x>>1)];
			c = ((c & 0x001f) << 10) | ((c & 0x7c00) >> 10) | (c & 0x03e0);
			c = ((c & 0x001f) << 3) | ((c & 0x03e0) << 6) | ((c & 0x7c00) << 9);
			
			NSUInteger NSc = c;
			
			[imageRep setPixel:&NSc atX:x y:y];
		}
	}
#else
	int x, y, c, i, r, g, b;
	for (i = 0; i < 256; i++) {
		x = (i % 16);
		y = (i / 16);
		c = icon[i];
		r = (c & 0x001f) << 3;
		g = ((c & 0x03e0) >> 5) << 3;
		b = ((c & 0x7c00) >> 10) << 3;
		[imageRep setColor:[NSColor colorWithCalibratedRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0] atX:x y:y];
	}
#endif
	NSImage *theImage = [[NSImage alloc] init];
	[theImage addRepresentation:imageRep];
	[imageRep release];
	[theImage setScalesWhenResized:YES];
	[theImage setSize:NSMakeSize(32, 32)];
	return [theImage autorelease];
}

- (id)initWithMcdBlock:(McdBlock *)infoBlock
{
	if (self = [super init]) {
		englishName = [[NSString alloc] initWithCString:infoBlock->Title encoding:NSASCIIStringEncoding];
		sjisName = [[NSString alloc] initWithCString:infoBlock->sTitle encoding:NSShiftJISStringEncoding];
		memImage = [[PcsxrMemoryObject imageFromMcd:infoBlock->Icon] retain];
		memName = [[NSString alloc] initWithCString:infoBlock->Name encoding:NSASCIIStringEncoding];
		memID = [[NSString alloc] initWithCString:infoBlock->ID encoding:NSASCIIStringEncoding];
		memIconCount = infoBlock->IconCount;
		memFlags = infoBlock->Flags;
		if ((infoBlock->Flags & 0xF0) == 0xA0) {
			if ((infoBlock->Flags & 0xF) >= 1 &&
				(infoBlock->Flags & 0xF) <= 3) {
				notDeleted = NO;
			} else
				notDeleted = NO;
		} else if ((infoBlock->Flags & 0xF0) == 0x50)
			notDeleted = YES;
		else
			notDeleted = NO;

	}
	return self;
}

@synthesize englishName;
@synthesize sjisName;
@synthesize memImage;
@synthesize notDeleted;
@synthesize memFlags;
@synthesize memName;
@synthesize memID;
@synthesize memIconCount;

- (void)dealloc
{
	[englishName release];
	[sjisName release];
	[memName release];
	[memID release];
	[memImage release];
	
	[super dealloc];
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"%@ (%@): Name: %@ ID: %@ Flags: %d", englishName, sjisName, memName, memID, memFlags];
}

@end
