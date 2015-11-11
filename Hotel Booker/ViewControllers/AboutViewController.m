//
//  AboutViewController.m
//  Hotel Booker
//
//  Created by Matt Graham on 08/07/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "AboutViewController.h"
#import "UIView+ViewUtils.h"

@interface AboutViewController ()

@property (nonatomic) BOOL hasAppeared;

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.versionLabel.text = [@"v" stringByAppendingString:
							  [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	self.hasAppeared = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	self.hasAppeared = NO;
}

- (void)viewWillLayoutSubviews {
	[super viewWillLayoutSubviews];
	[self showHideApadmiElementsForOrientation];
}

- (void)showHideApadmiElementsForOrientation {
	BOOL isLandscape = self.view.frame.size.width > self.view.frame.size.height;
	
	if (isLandscape) {
		[self.apadmiPreText addFixedHeightConstraint:0.0F];
		[self.apadmiPostText addFixedHeightConstraint:0.0F];
		
		self.apadmiTopConstraint.constant = 0.0F;
		self.apadmiBottomConstraint.constant = 0.0F;
	}
	else {
		if (self.hasAppeared) {
			CGFloat preTextHeight = [self getRequiredHeightForLabel:self.apadmiPreText];
			[self.apadmiPreText addFixedHeightConstraint:preTextHeight];			
			CGFloat postTextHeight = [self getRequiredHeightForLabel:self.apadmiPostText];
			[self.apadmiPostText addFixedHeightConstraint:postTextHeight];

			self.apadmiTopConstraint.constant = 16.0F;
			self.apadmiBottomConstraint.constant = 8.0F;
		}
	}
}

- (CGFloat)getRequiredHeightForLabel:(UILabel *)label {
	// base the available width of the self.view.frame, because this is correct here on iOS7, whereas the label's frame
	// hasn'e been updated yet.
	CGSize maxSize = CGSizeMake(self.view.frame.size.width - 2 * label.frame.origin.x, CGFLOAT_MAX);
	CGRect rect = [label.text boundingRectWithSize:maxSize
										  options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
									   attributes:@{NSFontAttributeName : label.font}
										  context:nil];
	
	return ceilf(rect.size.height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showApadmiWebsite:(id)sender {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.apadmi.com"]];
}

@end
