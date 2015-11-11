//
//  MediaItems.h
//  Hotel Booker
//
//  Created by Matt Graham on 12/06/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "MediaItem.h"

@interface MediaItems : NSObject

@property (nonatomic) NSArray /* MediaItem */ *mediaItems;

/** Removes any items of the specified type */
- (void)removeItemsOfType:(MediaItemType)type;

/** Gets the first media item of the specified type or nil if there are none */
- (MediaItem *)mediaItemOfType:(MediaItemType)type;

+ (RKObjectMapping *)rkMapping;

@end
