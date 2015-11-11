//
//  PhotoViewerViewController.h
//  Hotel Booker
//
//  Created by Matt Graham on 12/06/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "HotelCompact.h"

@interface PhotoViewerViewController : BaseViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic) HotelCompact *hotelCompact;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
