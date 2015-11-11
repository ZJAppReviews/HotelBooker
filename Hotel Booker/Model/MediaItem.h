//
//  MediaItem.h
//  Hotel Booker
//
//  Created by Matt Graham on 15/01/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

typedef NS_ENUM(NSUInteger, MediaItemType) {
	MediaItemTypeExterior,
	MediaItemTypeLobby,
	MediaItemTypeRoom,
	MediaItemTypeSuite,
	MediaItemTypeMeeting,
	MediaItemTypeRestaurant,
	MediaItemTypeBar,
	// The URL is not an image for the gallery type
	MediaItemTypeGallery,
	MediaItemTypeOther
};

@interface MediaItem : NSObject

@property (nonatomic) NSString *caption;
@property (nonatomic) NSInteger height;
@property (nonatomic) NSInteger width;
@property (nonatomic) NSString *url;
@property (nonatomic) NSString *typeString;
@property (nonatomic, readonly) MediaItemType type;

- (void)getImageForImageView:(UIImageView *)imageView
					 success:(void (^)(UIImage *image))success
					 failure:(void (^)(NSError *error))failure;

+ (RKObjectMapping *)rkMapping;

@end
