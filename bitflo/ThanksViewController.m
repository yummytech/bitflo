//
//  ThanksViewController.m
//  GoPaymentsPlus
//
//  Created by Boris  on 11/2/14.
//  Copyright (c) 2014 LLT. All rights reserved.
//

#import "ThanksViewController.h"
#import "AppDelegate.h"
#import "ViewController.h"
#import "ViewController.h"

@interface ThanksViewController ()

@end

@implementation ThanksViewController

@synthesize transactionID, approved;
@synthesize transactionIdLabel, amountLabel, messageLabel;
@synthesize phoneNumberTextField, emailTextField;
@synthesize email, phone;

- (IBAction)back:(id)sender {
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    appDelegate.isNewPayment = [NSNumber numberWithBool:YES];
    
    phoneNumberTextField.text = @"";
    emailTextField.text = @"";
    
    for (int i= 0 ; i < [[self.navigationController viewControllers]count] ; i++) {
        if ( [[[self.navigationController viewControllers] objectAtIndex:i] isKindOfClass:[ViewController class]]) {
            [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:i] animated:YES];
        }
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardWillShow:)
     name:UIKeyboardWillShowNotification
     object:nil];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardWillHide:)
     name:UIKeyboardWillHideNotification
     object:nil];
}

- (IBAction)sendSMS:(id)sender {
    

    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"amount:%@",appDelegate.currentAmount);
    
    [PFCloud callFunctionInBackground:@"sms"
                       withParameters:@{@"phone": phoneNumberTextField.text, @"amount":appDelegate.currentAmount}
                                block:^(NSDictionary *result, NSError *error) {
                                    if (!error) {
                                        
                                        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"SMS Sent"
                                                                                         message:@"The receipt was successfully sent"
                                                                                        delegate:self
                                                                               cancelButtonTitle:@"Cancel"
                                                                               otherButtonTitles: nil];
                                        [alert addButtonWithTitle:@"OK"];
                                        [alert show];
                                        phoneNumberTextField.text = @"";
                                        [self back:nil];
                                        
                                    } {;
                                        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"SMS Sent"
                                                                                         message:@"The receipt was successfully sent"
                                                                                        delegate:self
                                                                               cancelButtonTitle:@"Cancel"
                                                                               otherButtonTitles: nil];
                                        [alert addButtonWithTitle:@"OK"];
                                        [alert show];
                                        phoneNumberTextField.text = @"";
                                        [self back:nil];
                                        
                                        
                                    }
                                }];
    
}

- (IBAction)sendEmail:(id)sender {

    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"amount:%@",appDelegate.currentAmount);
    
    [PFCloud callFunctionInBackground:@"email"
                       withParameters:@{@"email": emailTextField.text, @"amount":appDelegate.currentAmount}
                                block:^(NSDictionary *result, NSError *error) {
                                    if (!error) {
                                        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Email Sent"
                                                                                         message:@"The receipt was successfully sent"
                                                                                        delegate:self
                                                                               cancelButtonTitle:@"Cancel"
                                                                               otherButtonTitles: nil];
                                        [alert addButtonWithTitle:@"OK"];
                                        [alert show];
                                        emailTextField.text = @"";
                                        [self back:nil];
                                        
                                    }
                                }];

    
}

- (void)viewWillAppear:(BOOL)animated {
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (email) {
        emailTextField.text = email;
    }
    
    if (phone) {
        phoneNumberTextField.text = phone;
    }
    
    BOOL isApproved = [approved boolValue];
    
    if (isApproved) {
        messageLabel.text = @"Congratuations your transaction was approved!!!";
        amountLabel.text = [NSString stringWithFormat:@"$%@",appDelegate.currentAmount];
        transactionIdLabel.text = transactionID;
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITextField Delegate Methods and other related methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
}

- (void)keyboardWillShow:(NSNotification *)notification {
    
    
    CGSize kbSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    double duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    int curve = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    
    if (self.view.frame.origin.y == 0) {
        // slide view up..
        
        [UIView beginAnimations:@"foo" context:nil];
        [UIView setAnimationDuration:duration];
        [UIView setAnimationCurve:curve];
        self.view.frame = CGRectMake(0, self.view.frame.origin.y - kbSize.height + 20, self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
        
    }
    
}

- (void) keyboardWillHide:(NSNotification *)notification {
    
    double duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    int curve = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    
    if (self.view.frame.origin.y < 0) {
        // slide view down
        [UIView beginAnimations:@"foo" context:nil];
        [UIView setAnimationDuration:duration];
        [UIView setAnimationCurve:curve];
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
        
    }
    
    
}

@end
