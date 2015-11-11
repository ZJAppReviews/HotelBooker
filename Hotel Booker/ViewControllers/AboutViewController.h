//
//  AboutViewController.h
//  Hotel Booker
//
//  Created by Matt Graham on 08/07/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "BaseViewController.h"

@interface AboutViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *scrollContentView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *apadmiTopConstraint;
@property (weak, nonatomic) IBOutlet UILabel *apadmiPreText;
@property (weak, nonatomic) IBOutlet UILabel *apadmiPostText;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *apadmiBottomConstraint;

@end
