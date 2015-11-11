//
//  HotelApiRequest.m
//  Hotel Booker
//
//  Created by Matt Graham on 10/06/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "HotelApiRequest.h"

@interface HotelApiRequest()

@property (nonatomic) RKRequestMethod method;
@property (nonatomic) NSString *path;

@end

@implementation HotelApiRequest

- (instancetype)initWithRequestMethod:(RKRequestMethod)method andPath:(NSString *)path {
	if (self = [super init]) {
		_method = method;
		_path = path;
	}
	return self;
}

- (void)cancel {
	[[RKObjectManager sharedManager] cancelAllObjectRequestOperationsWithMethod:self.method matchingPathPattern:self.path];
}

@end
