//
//  LabelledTextField.h
//  Hotel Booker
//
//  Created by Matt Graham on 25/06/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LabelledTextFieldType) {
	LabelledTextFieldTypeName = 0,
	LabelledTextFieldTypeAddress = 1,
	LabelledTextFieldTypePostCode = 2,
	LabelledTextFieldTypePhoneNumber = 3,
	LabelledTextFieldTypeEmailAddress = 4,
	LabelledTextFieldTypeCreditCardNumber = 5,
	LabelledTextFieldTypeCreditCardExpiryDate = 6,

	LabelledTextFieldTypeMax
};

/** Encapsulates a textfield of certain types with a label.
 */
IB_DESIGNABLE
@interface LabelledTextField : UIView <UITextFieldDelegate>

@property (nonatomic) IBInspectable NSString *labelText;
@property (nonatomic) IBInspectable NSUInteger typeInt;
@property (nonatomic) LabelledTextFieldType type;
@property (nonatomic, readonly) NSString *text;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;

- (BOOL)isValid;
/** validates the contents and sets the border color appropriately */
- (void)validate;
+ (void)validateAllInContainer:(UIView *)container;


@end
