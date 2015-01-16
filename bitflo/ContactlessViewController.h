//
//  ContactlessViewController.h
//  bitflo
//
//  Created by Boris  on 1/10/15.
//  Copyright (c) 2015 LLT. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "SalesViewController.h"


@interface ContactlessViewController : UIViewController <SalesDelegate>{
    
    CGPoint startPosition;
        
    UIVisualEffectView *blurEffectView;
    
    NSString *passcode;
    NSString *storedPasscode;
}


@property (nonatomic, strong) IBOutlet UIButton *oneButton;
@property (nonatomic, strong) IBOutlet UIButton *twoButton;
@property (nonatomic, strong) IBOutlet UIButton *threeButton;
@property (nonatomic, strong) IBOutlet UIButton *fourButton;
@property (nonatomic, strong) IBOutlet UIButton *fiveButton;
@property (nonatomic, strong) IBOutlet UIButton *sixButton;
@property (nonatomic, strong) IBOutlet UIButton *sevenButton;
@property (nonatomic, strong) IBOutlet UIButton *eightButton;
@property (nonatomic, strong) IBOutlet UIButton *nineButton;
@property (nonatomic, strong) IBOutlet UIButton *zeroButton;
@property (nonatomic, strong) IBOutlet UIButton *deleteButton;
@property (nonatomic, strong) IBOutlet UIButton *cancelButton;

@property (nonatomic, strong) IBOutlet UIImageView *firstNumber;
@property (nonatomic, strong) IBOutlet UIImageView *secondNumber;
@property (nonatomic, strong) IBOutlet UIImageView *thirdNumber;
@property (nonatomic, strong) IBOutlet UIImageView *fourthNumber;

@property (nonatomic, strong) IBOutlet UILabel *enterPasscodeLabel;

@property (nonatomic, strong) NSMutableArray *salesArray;
@property (nonatomic, retain) NSNumber* previous;

@property (nonatomic, strong) IBOutlet UIButton *salesButton;

@property (nonatomic, strong) IBOutlet UILabel *amountLabel;


@end
