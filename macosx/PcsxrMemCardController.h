//
//  PcsxrMemCardManager.h
//  Pcsxr
//
//  Created by Charles Betts on 11/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface PcsxrMemCardController : NSWindowController <NSWindowDelegate>
{
	IBOutlet NSCollectionView *memCard1view;
	IBOutlet NSCollectionView *memCard2view;
	NSMutableArray *memCard1Array;
	NSMutableArray *memCard2Array;
}

- (IBAction)moveBlock:(id)sender;
- (IBAction)formatCard:(id)sender;
- (IBAction)deleteMemoryObject:(id)sender;
- (void)loadMemoryCardInfoForCard:(int)theCard;
- (BOOL)isMemoryBlockEmptyOnCard:(int)aCard block:(int)aBlock;
- (int)countFreeBlocksOnCard:(int)aCard;
@end
