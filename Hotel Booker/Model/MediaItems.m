//
//  MediaItems.m
//  Hotel Booker
//
//  Created by Matt Graham on 12/06/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "MediaItems.h"

@implementation MediaItems

+ (RKObjectMapping *)rkMapping {
	static RKObjectMapping *mapping = nil;
	
	if (!(mapping)) {
		mapping = [RKObjectMapping mappingForClass:[MediaItems class]];
		[mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"mediaItem"
																				toKeyPath:@"mediaItems"
																			  withMapping:MediaItem.rkMapping]];
	}
	return mapping;
}

- (void)removeItemsOfType:(MediaItemType)type {
	NSIndexSet *indexes = [self.mediaItems indexesOfObjectsPassingTest:^BOOL(MediaItem* mediaItem, NSUInteger idx, BOOL *stop) {
		return mediaItem.type != type;
	}];
	self.mediaItems = [self.mediaItems objectsAtIndexes:indexes];
}

- (MediaItem *)mediaItemOfType:(MediaItemType)type {
	for (MediaItem *mediaItem in self.mediaItems) {
		if (mediaItem.type == type) {
			return mediaItem;
		}
	}
	return nil;
}

@end
