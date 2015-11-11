//
//  UIView+ViewUtils.m
//  Hotel Booker
//
//  Created by Matt Graham on 19/05/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "UIView+ViewUtils.h"

@implementation UIView (ViewUtils)

- (NSLayoutConstraint *) matchTopLayoutConstraintWithChild:(UIView *)child {
	return [self addTopLayoutConstraintWithChild:child value:0.0];
}

- (NSLayoutConstraint *) matchLeftLayoutConstraintWithChild:(UIView *)child {
	return [self addLeftLayoutConstraintWithChild:child value:0.0];
	
}

- (NSLayoutConstraint *) matchRightLayoutConstraintWithChild:(UIView *)child {
	return [self addRightLayoutConstraintWithChild:child value:0.0];
}

- (NSLayoutConstraint *) matchBottomLayoutConstraintWithChild:(UIView *)child {
	return [self addBottomLayoutConstraintWithChild:child value:0.0];
}

- (void) matchAutoLayoutConstraintsWithChild:(UIView *)child {
	[self matchTopLayoutConstraintWithChild:child];
	[self matchLeftLayoutConstraintWithChild:child];
	[self matchRightLayoutConstraintWithChild:child];
	[self matchBottomLayoutConstraintWithChild:child];
}

- (NSLayoutConstraint *) matchWidthWithChild:(UIView *)child {
	return [self addOrModifyConstraint:[NSLayoutConstraint
										constraintWithItem:child
										attribute:NSLayoutAttributeWidth
										relatedBy:0
										toItem:self
										attribute:NSLayoutAttributeWidth
										multiplier:1.0
										constant:0]];
}

- (NSLayoutConstraint *) matchHeightWithChild:(UIView *)child {
	return [self addOrModifyConstraint: [NSLayoutConstraint
										 constraintWithItem:child
										 attribute:NSLayoutAttributeHeight
										 relatedBy:0
										 toItem:self
										 attribute:NSLayoutAttributeHeight
										 multiplier:1.0
										 constant:0]];
}

- (NSLayoutConstraint *) addTopLayoutConstraintWithChild:(UIView *)child value:(CGFloat)value {
	return [self addOrModifyConstraint:[NSLayoutConstraint constraintWithItem:child
																	attribute:NSLayoutAttributeTop
																	relatedBy:NSLayoutRelationEqual
																	   toItem:self
																	attribute:NSLayoutAttributeTop
																   multiplier:1.0
																	 constant:value]];
}

- (NSLayoutConstraint *) addLeftLayoutConstraintWithChild:(UIView *)child value:(CGFloat)value {
	return [self addOrModifyConstraint:[NSLayoutConstraint constraintWithItem:child
																	attribute:NSLayoutAttributeLeading
																	relatedBy:NSLayoutRelationEqual
																	   toItem:self
																	attribute:NSLayoutAttributeLeading
																   multiplier:1.0
																	 constant:value]];
}

- (NSLayoutConstraint *) addRightLayoutConstraintWithChild:(UIView *)child value:(CGFloat)value {
	return [self addOrModifyConstraint:[NSLayoutConstraint constraintWithItem:child
																	attribute:NSLayoutAttributeTrailing
																	relatedBy:NSLayoutRelationEqual
																	   toItem:self
																	attribute:NSLayoutAttributeTrailing
																   multiplier:1.0
																	 constant:value]];
}

- (NSLayoutConstraint *) addBottomLayoutConstraintWithChild:(UIView *)child value:(CGFloat)value {
	return [self addOrModifyConstraint:[NSLayoutConstraint constraintWithItem:child
																	attribute:NSLayoutAttributeBottom
																	relatedBy:NSLayoutRelationEqual
																	   toItem:self
																	attribute:NSLayoutAttributeBottom
																   multiplier:1.0
																	 constant:value]];
}

- (void) addAutoLayoutConstraintsWithChild:(UIView *)child
									   top:(CGFloat)top
									  left:(CGFloat)left
									bottom:(CGFloat)bottom
									 right:(CGFloat)right {
	[self addTopLayoutConstraintWithChild:child value:top];
	[self addLeftLayoutConstraintWithChild:child value:left];
	[self addRightLayoutConstraintWithChild:child value:bottom];
	[self addBottomLayoutConstraintWithChild:child value:right];
}

- (NSLayoutConstraint *) addCenterHorizontalLayoutConstraintWithChild:(UIView *)child {
	return [self addOrModifyConstraint:[NSLayoutConstraint constraintWithItem:child
																	attribute:NSLayoutAttributeCenterX
																	relatedBy:NSLayoutRelationEqual
																	   toItem:self
																	attribute:NSLayoutAttributeCenterX
																   multiplier:1.0
																	 constant:0.0]];
}

- (NSLayoutConstraint *) addCenterVerticalLayoutConstraintWithChild:(UIView *)child {
	return [self addOrModifyConstraint:[NSLayoutConstraint constraintWithItem:child
																	attribute:NSLayoutAttributeCenterY
																	relatedBy:NSLayoutRelationEqual
																	   toItem:self
																	attribute:NSLayoutAttributeCenterY
																   multiplier:1.0
																	 constant:0.0]];
}

- (NSLayoutConstraint *) addFixedWidthConstraint:(CGFloat)width {
	return [self addOrModifyConstraint:[self createFixedWidthOrHeightConstraint:NO withConstant:width]];

}

- (NSLayoutConstraint *) findFixedWidthConstraint {
	return [self findConstraintMatching:[self createFixedWidthOrHeightConstraint:NO withConstant:0.0F]];
}

- (NSLayoutConstraint *) addFixedHeightConstraint:(CGFloat)height {
	return [self addOrModifyConstraint:[self createFixedWidthOrHeightConstraint:YES withConstant:height]];
}

- (NSLayoutConstraint *) findFixedHeightConstraint {
	return [self findConstraintMatching:[self createFixedWidthOrHeightConstraint:YES withConstant:0.0F]];
}

- (NSLayoutConstraint *) createFixedWidthOrHeightConstraint:(BOOL)isHeight withConstant:(CGFloat)constant {
	return [NSLayoutConstraint constraintWithItem:self
										attribute:isHeight ? NSLayoutAttributeHeight : NSLayoutAttributeWidth
										relatedBy:NSLayoutRelationEqual
										   toItem:nil
										attribute:NSLayoutAttributeNotAnAttribute
									   multiplier:1.0
										 constant:constant];
}

- (NSLayoutConstraint *) addOrModifyConstraint:(NSLayoutConstraint *)constraint {
	NSLayoutConstraint *existingConstraint = [self findConstraintMatching:constraint];

	if (existingConstraint) {
		if (existingConstraint.constant != constraint.constant) {
			existingConstraint.constant = constraint.constant;
		}
		return existingConstraint;
	} else {
		[self addConstraint:constraint];
		return constraint;
	}
}

- (NSLayoutConstraint *) findConstraintMatching:(NSLayoutConstraint *)constraint {
	NSUInteger index = [self.constraints indexOfObjectPassingTest:
						^BOOL(NSLayoutConstraint *existingConstraint, NSUInteger idx, BOOL *stop) {
							*stop = existingConstraint.firstAttribute == constraint.firstAttribute &&
							existingConstraint.relation == constraint.relation &&
							existingConstraint.secondAttribute == existingConstraint.secondAttribute &&
							existingConstraint.firstItem == existingConstraint.firstItem &&
							existingConstraint.secondItem == existingConstraint.secondItem &&
							existingConstraint.multiplier == existingConstraint.multiplier;
							return *stop;
						}];
	
	NSLayoutConstraint *existingConstraint = nil;
	if (index != NSNotFound) {
		existingConstraint = self.constraints[index];
	}
	return existingConstraint;
}


- (void) removeConstraintsWithChild:(UIView *)child {
	NSIndexSet *indexes = [self.constraints indexesOfObjectsPassingTest:
	 ^BOOL(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop) {
		 return constraint.firstItem == child || constraint.secondItem == child;
	 }];
	
	NSArray *constraintsToRemove = [self.constraints objectsAtIndexes:indexes];
	[self removeConstraints:constraintsToRemove];
}

- (void)setMaskRect:(CGRect)maskRect {
	CAShapeLayer *layer = [CAShapeLayer new];
	CGPathRef path = CGPathCreateWithRect(maskRect, NULL);
	layer.path = path;
	CGPathRelease(path);
	self.layer.mask = layer;
}

@end
