//
//  HotelApi.m
//  Hotel Booker
//
//  Created by Matt Graham on 11/05/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "HotelApi.h"
#import "Config.h"
#import "UserSettings.h"

#import <RestKit/RestKit.h>
#import <RestKit/UIImageView+AFNetworking.h>

NSString * const TravePortHotelAPIErrorDomain = @"TravePortHotelAPIErrorDomain";

@interface HotelApi ()
@property (nonatomic, readonly) NSString *targetBranch;
@end

@implementation HotelApi

+ (instancetype)sharedInstance {
	static HotelApi *instance = nil;
	@synchronized(self) {
		if (instance == nil)
			instance = [self new];
	}
	return instance;
}

- (instancetype)init {
	self = [super init];
	if (self) {
		[self configureRestKit];
	}
	return self;
}

- (void)configureRestKit {
    // One time setup
    
	// ensure text/json is accepted by RestKit
	Class<RKSerialization> applicationJsonClass = [RKMIMETypeSerialization serializationClassForMIMEType:@"application/json"];
	[RKMIMETypeSerialization registerClass:applicationJsonClass forMIMEType:@"text/json"];
	
	// ensure image/jpg is accepted by AFNetworking
	[AFImageRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"image/jpg", nil]];
}

- (void)configureHotelSearch:(RKObjectManager *)objectManager {
	NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful); // Anything in 2xx
	RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:HotelSearchResult.rkMapping
																							method:RKRequestMethodGET
																					   pathPattern:HOTEL_SEARCH_PATH
																						   keyPath:nil
																					   statusCodes:statusCodes];
	[objectManager addResponseDescriptor:responseDescriptor];
}

- (void)configureHotelDetails:(RKObjectManager *)objectManager {
	NSString *pathPattern = [NSString stringWithFormat:HOTEL_DETAILS_PATH, @":hotelId"];
	NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful); // Anything in 2xx
	RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:HotelDetailsResult.rkMapping
																							method:RKRequestMethodGET
																					   pathPattern:pathPattern
																						   keyPath:nil
																					   statusCodes:statusCodes];
	[objectManager addResponseDescriptor:responseDescriptor];
}

- (void)configureMedia:(RKObjectManager *)objectManager {
	NSString *pathPattern = [NSString stringWithFormat:MEDIA_PATH, @":hotelId"];
	NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful); // Anything in 2xx
	RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:HotelMediaResponse.rkMapping
																							method:RKRequestMethodGET
																					   pathPattern:pathPattern
																						   keyPath:nil
																					   statusCodes:statusCodes];
	[objectManager addResponseDescriptor:responseDescriptor];
}

- (HotelApiRequest *)getHotels:(SearchData *)searchData
		  success:(void (^)(HotelSearchResult *hotelSearchResult))success
		  failure:(void (^)(NSError *error))failure {
	
	[self preRequestConfig];
	
	NSString *path = HOTEL_SEARCH_PATH;
    #warning TODO remove targetBranch, once it is moved to HTTP Headers
	[[RKObjectManager sharedManager] getObjectsAtPath:path
										   parameters:[searchData queryParamsForSearch:YES branch:self.targetBranch]
											  success:
	 ^(RKObjectRequestOperation *operation, RKMappingResult *result) {
		 HotelSearchResult *hotelSearchResult = result.firstObject;
		 NSLog(@"HotelApi getHotels: Got %ld hotels", (unsigned long)hotelSearchResult.hotels.count);
		 if (success) {
			 success(hotelSearchResult);
		 }
	 } failure:
	 ^(RKObjectRequestOperation *operation, NSError *error) {
		 NSLog(@"HotelApi getHotels: Failed with error: %@", [error localizedDescription]);
		 NSLog(@"HotelApi getHotels: operation.mappingResult.dictionary: %@", operation.mappingResult.dictionary);
		 if (failure) {
			 failure(error);
		 }
	 }];
	
	return [[HotelApiRequest alloc] initWithRequestMethod:RKRequestMethodGET andPath:path];
}

- (void)getHotelThumbnail:(NSString *)hotelId
			 forImageView:(UIImageView *)imageView {

	[self preRequestConfig];

	NSString *path = [NSString stringWithFormat:HOTEL_THUMBNAIL_PATH, hotelId];
#warning TODO remove targetBranch, once it is moved to HTTP Headers
	NSMutableURLRequest *request = [RKObjectManager.sharedManager.HTTPClient requestWithMethod:@"GET" path:path parameters:@{@"targetBranch" : self.targetBranch}];
	
//#warning TODO - REMOVE
//	request.URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://json-uapi-layer.cloudapp.net:9000/hotels/%@/thumbnail?targetBranch=P7010255", hotelId]];
	
	[imageView setImageWithURLRequest:request placeholderImage:nil success:nil failure:nil];
}

- (HotelApiRequest *)getHotelDetails:(NSString *)hotelId
			 searchData:(SearchData *)searchData
				success:(void (^)(HotelDetailsResult *hotelDetailsResult))success
				failure:(void (^)(NSError *error))failure {

	[self preRequestConfig];

	NSString *path = [NSString stringWithFormat:HOTEL_DETAILS_PATH, hotelId];
	
#warning TODO remove targetBranch, once it is moved to HTTP Headers
	[[RKObjectManager sharedManager] getObject:nil
										  path:path
									parameters:[searchData queryParamsForSearch:NO branch:self.targetBranch]
									   success:
	 ^(RKObjectRequestOperation *operation, RKMappingResult *result) {
		 HotelDetailsResult *hotelDetailsResult = result.firstObject;
		 NSLog(@"HotelApi getHotelDetails: Got hotel details for \"%@\"", hotelDetailsResult.hotelDetails.hotelProperty.name);
		 if (success) {
			 success(hotelDetailsResult);
		 }
	 } failure:
	 ^(RKObjectRequestOperation *operation, NSError *error) {
		 NSLog(@"HotelApi getHotelDetails: Failed with error: %@", [error localizedDescription]);
		 if (failure) {
			 failure(error);
		 }
	 }];
	
	return [[HotelApiRequest alloc] initWithRequestMethod:RKRequestMethodGET andPath:path];
}

- (HotelApiRequest *)getMedia:(NSString *)hotelId
							success:(void (^)(HotelMediaResponse *mediaResponse))success
							failure:(void (^)(NSError *error))failure {
	
	[self preRequestConfig];

	NSString *path = [NSString stringWithFormat:MEDIA_PATH, hotelId];
	
#warning TODO remove targetBranch, once it is moved to HTTP Headers
	[[RKObjectManager sharedManager] getObject:nil path:path parameters:@{@"targetBranch" : self.targetBranch} success:
	 ^(RKObjectRequestOperation *operation, RKMappingResult *result) {
		 HotelMediaResponse *mediaResponse = result.firstObject;
		 NSLog(@"HotelApi getHotelDetails: Got rate details");
		 if (success) {
			 success(mediaResponse);
		 }
	 } failure:
	 ^(RKObjectRequestOperation *operation, NSError *error) {
		 NSLog(@"Failed with error: %@", [error localizedDescription]);
		 if (failure) {
			 failure(error);
		 }
	 }];
	
	return [[HotelApiRequest alloc] initWithRequestMethod:RKRequestMethodGET andPath:path];
}

- (void)book:(BookingInfo *)bookingInfo
	 success:(void (^)(HotelBookingResponse *response))success
	 failure:(void (^)(NSError *error))failure {
	
	[self preRequestConfig];

	AFHTTPClient *httpClient = RKObjectManager.sharedManager.HTTPClient;
	// pretend to be a GET request, so that the in and out params go into the query string
	NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
															path:BOOKING_PATH
													  parameters:@{@"in" : bookingInfo.searchData.checkInDateString,
																   @"out" : bookingInfo.searchData.checkOutDateString}];
#ifndef BOOKING_PATH_GET
	// now set to POST
	request.HTTPMethod = @"POST";
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
#warning TODO remove targetBranch, once it is moved to HTTP Headers
    NSString *bookingBody = [bookingInfo completedBookingTemplate:self.targetBranch];
	request.HTTPBody = [bookingBody dataUsingEncoding:NSUTF8StringEncoding];
#endif
	
	AFHTTPRequestOperation *operation = [httpClient HTTPRequestOperationWithRequest:request success:
	 ^(AFHTTPRequestOperation *operation, id responseObject) {
		 HotelBookingResponse *response = nil;
		 
		 if ([responseObject isKindOfClass:[NSData class]]) {
			 id jsonObjectOrArray = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
			 if ([jsonObjectOrArray isKindOfClass:[NSDictionary class]]) {
				 NSDictionary *jsonObject = (NSDictionary *)jsonObjectOrArray;
				 if (jsonObject[@"universalRecord"]) {
					 response = [HotelBookingResponse modelObjectWithDictionary:jsonObject];
				 }
			 }
		 }
		 
		 if (response) {
			 if (success) {
				 success(response);
			 }
		 }
		 else {
			 if (failure) {
				 failure([NSError errorWithDomain:TravePortHotelAPIErrorDomain
											 code:TravePortHotelAPIErrorDomainCodeInvalidBookingResponse
										 userInfo:nil]);
			 }
		 }
	 } failure:
	 ^(AFHTTPRequestOperation *operation, NSError *error) {
		 if (failure) {
			 failure(error);
		 }
	 }
	];
	
	[httpClient enqueueHTTPRequestOperation:operation];
}

- (void)preRequestConfig {
    // Called before every request
    
    ResultsEnvironment *environment = [UserSettings.sharedInstance resultsEnvironment];
    
    // initialize an AFNetworking HTTPClient
    NSString *baseUrlString = [NSString stringWithFormat:@"%@:%@", BASE_URL, environment.port];
    NSURL *baseURL = [NSURL URLWithString:baseUrlString];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    [client setDefaultHeader:@"filter" value:@"mobile"];
    
#warning TODO add targetBranch, once it is moved to HTTP Headers
    //[client setDefaultHeader:@"targetBranch" value:TARGET_BRANCH];
    
    [client setAuthorizationHeaderWithUsername:environment.username password:environment.password];
    
    // initialize RestKit
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    [RKObjectManager setSharedManager:objectManager];
    
    // configure each API call
    [self configureHotelSearch:objectManager];
    [self configureHotelDetails:objectManager];
    [self configureMedia:objectManager];
    
}

- (NSString *)targetBranch {
    return [UserSettings.sharedInstance resultsEnvironment].targetBranch;
}

@end
