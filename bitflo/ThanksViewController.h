//
//  ThanksViewController.h
//  bitflo
//
//  Created by Boris  on 1/10/15.
//  Copyright (c) 2015 LLT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ThanksViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, strong) NSString *transactionID;
@property (nonatomic, strong) NSNumber *approved;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *phone;

@property (nonatomic, strong) IBOutlet UILabel *messageLabel;
@property (nonatomic, strong) IBOutlet UILabel *transactionIdLabel;
@property (nonatomic, strong) IBOutlet UILabel *amountLabel;

@property (nonatomic, strong) IBOutlet UITextField *phoneNumberTextField;
@property (nonatomic, strong) IBOutlet UITextField *emailTextField;

@end
