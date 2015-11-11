//
//  MediaItem.m
//  Hotel Booker
//
//  Created by Matt Graham on 15/01/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "MediaItem.h"
#import <RestKit/UIImageView+AFNetworking.h>

@implementation MediaItem

+ (RKObjectMapping *)rkMapping {
	static RKObjectMapping *mapping = nil;
	
	if (!mapping) {
		mapping = [RKObjectMapping mappingForClass:[MediaItem class]];
		[mapping addAttributeMappingsFromArray:@[@"caption", @"height", @"width", @"url"]];
		[mapping addAttributeMappingsFromDictionary:@{@"type" : @"typeString"}];
	}
	return mapping;
}
		 
- (MediaItemType)type {
	if ([self.typeString isEqualToString:@"EXT"]) {
		return MediaItemTypeExterior;
	}
	else if ([self.typeString isEqualToString:@"LOBBY"]) {
		return MediaItemTypeLobby;
	}
	else if ([self.typeString isEqualToString:@"ROOM"]) {
		return MediaItemTypeRoom;
	}
	else if ([self.typeString isEqualToString:@"SUITE"]) {
		return MediaItemTypeSuite;
	}
	else if ([self.typeString isEqualToString:@"MEET"]) {
		return MediaItemTypeMeeting;
	}
	else if ([self.typeString isEqualToString:@"REST"]) {
		return MediaItemTypeRestaurant;
	}
	else if ([self.typeString isEqualToString:@"BAR"]) {
		return MediaItemTypeBar;
	}
	else if ([self.typeString isEqualToString:@"Gallery"]) {
		return MediaItemTypeGallery;
	}
	else if ([self.typeString isEqualToString:@"OTHER"]) {
		return MediaItemTypeOther;
	}
	
	NSLog(@"Unknown Media Item type: %@", self.typeString);
	return MediaItemTypeOther;
}

- (void)getImageForImageView:(UIImageView *)imageView
					 success:(void (^)(UIImage *image))success
					 failure:(void (^)(NSError *error))failure {
	if (self.type != MediaItemTypeGallery) {
		NSURL *url = [NSURL URLWithString:self.url];
		if (url) {
			__weak UIImageView *weakImageView = imageView;
			NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
			[request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
			
			[imageView setImageWithURLRequest:request placeholderImage:nil success:
			 ^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
				 if (weakImageView) {
					 weakImageView.image = image;
				 }
				 if (success) {
					 success(image);
				 }
			} failure:
			 ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
				 if (failure) {
					 failure(error);
				 }
			}];
		}
	}
}

@end
