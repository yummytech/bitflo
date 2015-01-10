//
//  ViewController.h
//  bitflo
//
//  Created by Boris  on 1/10/15.
//  Copyright (c) 2015 LLT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddNoteViewController.h"
#import "SalesViewController.h"

@import CoreBluetooth;
@import QuartzCore;

@interface ViewController : UIViewController <AddNoteDelegate, SalesDelegate, UITextFieldDelegate> {
    
    NSArray *services;
    NSString *amount;
    int currentInput;
    
    NSMutableArray *salesArray;
    
    BOOL newPayment;
}

@property (nonatomic, strong) NSNumber* total;
@property (nonatomic, retain) NSNumber* previous;
@property (nonatomic, strong) IBOutlet UIButton *chargeButton;
@property (nonatomic, strong) IBOutlet UIButton *noteButton;
@property (nonatomic, strong) IBOutlet UIButton *itemsCountButton;
@property (nonatomic, strong) IBOutlet UILabel *itemCountLabel;
@property (nonatomic, strong) IBOutlet UILabel *lowerAmountLabel;
@property (nonatomic, strong) NSMutableArray *salesArray;

@property (nonatomic, strong) IBOutlet UITextField *testTextfield;

@end

