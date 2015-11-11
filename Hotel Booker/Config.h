//
//  Config.h
//  Hotel Booker
//
//  Created by Matt Graham on 11/05/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#ifndef Hotel_Booker_Config_h
#define Hotel_Booker_Config_h

// No trailing slash, please!
#define BASE_URL @"http://json-uapi-layer.cloudapp.net"
#define HOTEL_SEARCH_PATH @"/hotels"
#define HOTEL_THUMBNAIL_PATH @"/hotels/%@/thumbnail"
#define HOTEL_DETAILS_PATH @"/hotels/%@"
#define RATE_DETAILS_PATH @"/hotels/%@/rates/%@"
#define MEDIA_PATH @"/hotels/%@/links"
#define BOOKING_PATH @"/universal-records/new/hotel-reservation"

#define PRE_PROD_PORT @"9000"
#define PROD_PORT @"10000"

#define BASIC_AUTH_PRE_PROD_USERNAME @""
#define BASIC_AUTH_PRE_PROD_PASSWORD @""

#define BASIC_AUTH_PROD_USERNAME @""
#define BASIC_AUTH_PROD_PASSWORD @""

#define PRE_PROD_TARGET_BRANCH @""
#define PROD_TARGET_BRANCH @""

#define HOTEL_LIST_ELEMENT_ASPECT_RATIO (640.0F / 250.0F)

#endif
