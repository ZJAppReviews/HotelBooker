//
//  PhotoViewerCell.h
//  Hotel Booker
//
//  Created by Matt Graham on 17/06/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MediaItem.h"

@interface PhotoViewerCell : UICollectionViewCell <UIScrollViewDelegate>

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *placeHolderImageView;
@property (nonatomic) UIImageView *imageView;
@property (nonatomic) MediaItem *mediaItem;

@end
