//
//  LabelledTextField.m
//  Hotel Booker
//
//  Created by Matt Graham on 25/06/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "LabelledTextField.h"
#import "UIView+ViewUtils.h"
#import "Palette.h"
#import "NSString+Validate.h"

@interface LabelledTextField()

@property (nonatomic, strong) UIView *nibView;
@property (nonatomic) NSUInteger maxChars;
@property (nonatomic) NSCharacterSet *allowedCharacterSet;

@end

@implementation LabelledTextField

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if(self) {
		[self setUp:YES];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if(self) {
		[self setUp:NO];
	}
	return self;
}

- (void) setUp:(BOOL)fromCoder {
	self.maxChars = NSUIntegerMax;
	self.allowedCharacterSet = nil;
	
	NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	NSArray *nibContents = [bundle loadNibNamed:@"LabelledTextField" owner:self options:nil];
	self.nibView = nibContents[0];
	self.nibView.frame = self.frame;
	self.nibView.backgroundColor = [UIColor clearColor];
	
	if(fromCoder) {
		self.translatesAutoresizingMaskIntoConstraints = NO;
		self.nibView.translatesAutoresizingMaskIntoConstraints = NO;
	}
	
	self.titleLabel.textColor = DARK_TEXT_COLOR;
	self.textField.layer.borderColor = DARK_TEXT_COLOR.CGColor;
	self.textField.layer.borderWidth = 1.0F;
	self.textField.tintColor = FORM_CURSOR_COLOR;
	
	self.type = LabelledTextFieldTypeName;
	
	[self addSubview:self.nibView];
	
	[self matchAutoLayoutConstraintsWithChild:self.nibView];
}

- (void)setLabelText:(NSString *)labelText {
	self.titleLabel.text = labelText;
}

- (NSUInteger)typeInt {
	return self.type;
}

- (void)setTypeInt:(NSUInteger)typeInt {
	if (typeInt >= LabelledTextFieldTypeMax) {
		[NSException raise:@"Invalid LabelledTextFieldType" format:@"%lu", (unsigned long)typeInt];
	}

	self.type = typeInt;
}

-(void)setType:(LabelledTextFieldType)type {
	_type = type;
	
	UITextAutocapitalizationType autocapitalizationType = UITextAutocapitalizationTypeNone;
	UITextAutocorrectionType autocorrectionType = UITextAutocorrectionTypeNo;
	UITextSpellCheckingType spellCheckingType = UITextSpellCheckingTypeNo;
	UIKeyboardType keyboardType = UIKeyboardTypeDefault;
	NSString *placeHolder = nil;
	self.maxChars = NSUIntegerMax;
	self.allowedCharacterSet = nil;
	
	switch (type) {
		case LabelledTextFieldTypePostCode:
			autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
			keyboardType = UIKeyboardTypeASCIICapable;
			break;
		case LabelledTextFieldTypePhoneNumber:
			keyboardType = UIKeyboardTypePhonePad;
			break;
		case LabelledTextFieldTypeEmailAddress:
			keyboardType = UIKeyboardTypeEmailAddress;
			break;
		case LabelledTextFieldTypeCreditCardNumber:
			keyboardType = UIKeyboardTypeNumbersAndPunctuation;
			placeHolder = @"1234567812345678";
			self.maxChars = placeHolder.length;
			self.allowedCharacterSet = [NSCharacterSet decimalDigitCharacterSet];
			break;
		case LabelledTextFieldTypeCreditCardExpiryDate:
			keyboardType = UIKeyboardTypeNumbersAndPunctuation;
			placeHolder = @"0115";
			self.maxChars = placeHolder.length;
			self.allowedCharacterSet = [NSCharacterSet decimalDigitCharacterSet];
			break;
			
		case LabelledTextFieldTypeName:
		case LabelledTextFieldTypeAddress:
		default:
			autocapitalizationType = UITextAutocapitalizationTypeWords;
			break;
	}
	
	self.textField.autocapitalizationType = autocapitalizationType;
	self.textField.autocorrectionType = autocorrectionType;
	self.textField.spellCheckingType = spellCheckingType;
	self.textField.keyboardType = keyboardType;
	self.textField.placeholder = placeHolder;
	self.textField.keyboardAppearance = UIKeyboardAppearanceDark;
}

- (NSString *)text {
	return self.textField.text;
}

- (BOOL)isValid {
	switch (self.type) {
		case LabelledTextFieldTypeName:
			return [self.text isValidName];
			break;
		case LabelledTextFieldTypePhoneNumber:
			return [self.text isValidPhoneNumber];
			break;
		case LabelledTextFieldTypeEmailAddress:
			return [self.text isValidEmailAddress];
			break;
		case LabelledTextFieldTypeCreditCardNumber:
			return [self.text isValidCreditCardNumber];
			break;
		case LabelledTextFieldTypeCreditCardExpiryDate:
			return [self.text isValidCreditCardExpiryDate];
			break;
			
		case LabelledTextFieldTypeAddress:
		case LabelledTextFieldTypePostCode:
		default:
			return self.text.length > 0;
			break;
	}
}

- (void)validate {
	if ([self isValid]) {
		self.textField.layer.borderWidth = 1.0F;
		self.textField.layer.borderColor = DARK_TEXT_COLOR.CGColor;
	}
	else {
		self.textField.layer.borderWidth = 2.0F;
		self.textField.layer.borderColor = FORM_ERROR_COLOR.CGColor;
	}
}

+ (void)validateAllInContainer:(UIView *)container {
	for (UIView *view in container.subviews) {
		if ([view isKindOfClass:self.class]) {
			LabelledTextField *labelledTextField = (LabelledTextField *)view;
			[labelledTextField validate];
		}
	}
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	if ([self findNextLabelledTextFieldInParent]) {
		self.textField.returnKeyType = UIReturnKeyNext;
	} else {
		self.textField.returnKeyType = UIReturnKeyDone;
	}
	
	[self scrollToSelfIfInScrollView];
	
	return YES;
}

- (void)scrollToSelfIfInScrollView {
	UIScrollView *scrollView = [self findScrollViewForView:self];
	
	if (scrollView) {
		CGFloat yOffset = self.frame.origin.y;
		[scrollView setContentOffset:CGPointMake(0.0F, yOffset) animated:YES];
	}
}

- (UIScrollView *)findScrollViewForView:(UIView *)view {
	if (!view || [view isKindOfClass:[UIScrollView class]]) {
		return (UIScrollView *)view;
	} else {
		return [self findScrollViewForView:view.superview];
	}
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	self.titleLabel.textColor = BLUE_TEXT_COLOR;
	self.textField.layer.borderColor = BLUE_TEXT_COLOR.CGColor;
	self.textField.layer.borderWidth = 2.0F;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	self.titleLabel.textColor = DARK_TEXT_COLOR;
	[self validate];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	// Prevent undo crash
	if (range.location + range.length > textField.text.length) {
		return NO;
	}
	
	NSUInteger newLength = textField.text.length + string.length - range.length;
	
	BOOL validCharacters = YES;
	if (self.allowedCharacterSet) {
		NSString *filtered = [[string componentsSeparatedByCharactersInSet:self.allowedCharacterSet.invertedSet] componentsJoinedByString:@""];
		validCharacters = filtered.length == string.length;
	}
	
	return validCharacters && newLength <= self.maxChars;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	LabelledTextField *nextLabelledTextField = [self findNextLabelledTextFieldInParent];
	
	if (nextLabelledTextField) {
		[nextLabelledTextField.textField becomeFirstResponder];
	}
	else {
		[self.textField resignFirstResponder];
	}
	
	return YES;
}

- (LabelledTextField *)findNextLabelledTextFieldInParent {
	BOOL foundOurselves = NO;
	for (UIView *view in self.superview.subviews) {
		if (!foundOurselves) {
			if (view == self) {
				foundOurselves = YES;
			}
		}
		else {
			if ([view isKindOfClass:[LabelledTextField class]]) {
				return (LabelledTextField *)view;
			}
		}
	}
	
	return nil;
}

@end
