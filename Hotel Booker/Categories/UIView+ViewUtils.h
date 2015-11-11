//
//  UIView+ViewUtils.h
//  Hotel Booker
//
//  Created by Matt Graham on 19/05/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * Provides UIView-related utility functions.
 */
@interface UIView (ViewUtils)

- (NSLayoutConstraint *) matchTopLayoutConstraintWithChild:(UIView *)child;
- (NSLayoutConstraint *) matchLeftLayoutConstraintWithChild:(UIView *)child;
- (NSLayoutConstraint *) matchRightLayoutConstraintWithChild:(UIView *)child;
- (NSLayoutConstraint *) matchBottomLayoutConstraintWithChild:(UIView *)child;
- (void) matchAutoLayoutConstraintsWithChild:(UIView *)child;

- (NSLayoutConstraint *) matchWidthWithChild:(UIView *)child;
- (NSLayoutConstraint *) matchHeightWithChild:(UIView *)child;

- (NSLayoutConstraint *) addTopLayoutConstraintWithChild:(UIView *)child value:(CGFloat)value;
- (NSLayoutConstraint *) addLeftLayoutConstraintWithChild:(UIView *)child value:(CGFloat)value;
- (NSLayoutConstraint *) addRightLayoutConstraintWithChild:(UIView *)child value:(CGFloat)value;
- (NSLayoutConstraint *) addBottomLayoutConstraintWithChild:(UIView *)child value:(CGFloat)value;
- (void) addAutoLayoutConstraintsWithChild:(UIView *)child
									   top:(CGFloat)top
									  left:(CGFloat)left
									bottom:(CGFloat)bottom
									 right:(CGFloat)right;

- (NSLayoutConstraint *) addCenterHorizontalLayoutConstraintWithChild:(UIView *)child;
- (NSLayoutConstraint *) addCenterVerticalLayoutConstraintWithChild:(UIView *)child;

- (NSLayoutConstraint *) addFixedWidthConstraint:(CGFloat)width;
- (NSLayoutConstraint *) findFixedWidthConstraint;
- (NSLayoutConstraint *) addFixedHeightConstraint:(CGFloat)height;
- (NSLayoutConstraint *) findFixedHeightConstraint;

- (NSLayoutConstraint *) addOrModifyConstraint:(NSLayoutConstraint *)constraint;
// find a constraint matching everything but the constant value
- (NSLayoutConstraint *) findConstraintMatching:(NSLayoutConstraint *)constraint;
- (void) removeConstraintsWithChild:(UIView *)child;

- (void)setMaskRect:(CGRect)maskRect;

@end
