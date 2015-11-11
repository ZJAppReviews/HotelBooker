//
//  AboutOpenSourceLicensesViewController.m
//  Hotel Booker
//
//  Created by Matt Graham on 09/07/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "AboutOpenSourceLicensesViewController.h"

@interface AboutOpenSourceLicensesViewController ()

@end

@implementation AboutOpenSourceLicensesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource: @"OpenSourceLicenses" ofType: @"html"]];
	[self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	if (navigationType == UIWebViewNavigationTypeLinkClicked) {
		[[UIApplication sharedApplication] openURL:request.URL];
		return NO;
	}
	
	return YES;
}

@end
