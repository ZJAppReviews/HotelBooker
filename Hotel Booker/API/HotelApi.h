//
//  HotelApi.h
//  Hotel Booker
//
//  Created by Matt Graham on 11/05/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HotelApiRequest.h"
#import "SearchData.h"
#import "HotelSearchResult.h"
#import "HotelDetailsResult.h"
#import "HotelMediaResponse.h"
#import "BookingInfo.h"
#import "HotelBookingResponse.h"

FOUNDATION_EXPORT NSString * const TravePortHotelAPIErrorDomain;
typedef NS_ENUM(NSUInteger, TravePortHotelAPIErrorDomainCode) {
	TravePortHotelAPIErrorDomainCodeInvalidBookingResponse
};

/**
 * Encapsulates the Travelport Hotel search and booking API. Each API endpoint is represented as a function in this
 * class.
 */
@interface HotelApi : NSObject

+ (instancetype)sharedInstance;

/**
 * Performs a hotel search based on the provided criteria. Only the providers set in UserSettings are searched.
 */
- (HotelApiRequest *)getHotels:(SearchData *)searchData
		  success:(void (^)(HotelSearchResult *hotelSearchResult))success
		  failure:(void (^)(NSError *error))failure;

/**
 * Gets the thumbnail for the hotel with the provided ID and puts it into the provided UIImageView
 */
- (void)getHotelThumbnail:(NSString *)hotelId
			 forImageView:(UIImageView *)imageView;

/**
 * Gets the full details of the hotel wtih the provided ID
 */
- (HotelApiRequest *)getHotelDetails:(NSString *)hotelId
			 searchData:(SearchData *)searchData
				success:(void (^)(HotelDetailsResult *hotelDetailsResult))success
				failure:(void (^)(NSError *error))failure;

/**
 * Gets the media images for the hotel with the provided hotel ID
 */
- (HotelApiRequest *)getMedia:(NSString *)hotelId
							success:(void (^)(HotelMediaResponse *mediaResponse))success
							failure:(void (^)(NSError *error))failure;

/**
 * Books the hotel
 */
- (void)book:(BookingInfo *)bookingInfo
	 success:(void (^)(HotelBookingResponse *response))success
	 failure:(void (^)(NSError *error))failure;

@end
