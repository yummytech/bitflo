//
//  ContactlessViewController.m
//  GoPaymentsPlus
//
//  Created by Boris  on 11/2/14.
//  Copyright (c) 2014 LLT. All rights reserved.
//

#import "ContactlessViewController.h"
#import "ThanksViewController.h"
#import "AppDelegate.h"

#define FLOBLE_UUID @"6e400001-b5a3-f393-e0a9-e50e24dcca9e"
#define FLOMIO_ACCOUNT @"5492cb448d10dc6b8b00009d"

@interface ContactlessViewController ()
@end

@implementation ContactlessViewController

@synthesize oneButton, twoButton, threeButton, fourButton, fiveButton, sixButton, sevenButton, eightButton, nineButton, zeroButton, deleteButton;
@synthesize firstNumber, secondNumber, thirdNumber, fourthNumber, salesButton;
@synthesize salesArray, previous, amountLabel, enterPasscodeLabel;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
}

- (void) receiveNotification:(NSNotification *) notification
{
    // [notification name] should always be @"TestNotification"
    // unless you use this method for observation of other notifications
    // as well.
    
    if ([[notification name] isEqualToString:@"UUIDNotification"]) {
        NSLog (@"Successfully received the UUID:%@",notification.userInfo);
        [self completeTransaction:[notification.userInfo objectForKey:@"UUID"]];
    }
    
}

-(IBAction)openSales:(id)sender {
    
    SalesViewController *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"sales"];
    svc.salesArray = self.salesArray;
    
    svc.delegate = self;
    
    svc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:svc animated:YES completion:nil];
    
    svc.totalLabel.text = [NSString stringWithFormat:@"Total $%.2f",[self.previous floatValue]];
    
}

- (IBAction)passcode:(id)sender {
    
    UIButton *senderButton = (UIButton *)sender;
    
    NSInteger selectedButton = [senderButton tag];
    
    if (selectedButton < 11) {
        passcode = [NSString stringWithFormat:@"%@%li",passcode,(long)selectedButton];
        NSLog(@"passcode:%@",passcode);
    } else {
        
        if ([passcode length] > 0) {
            passcode = [passcode substringToIndex:[passcode length] - 1];
        }
    }
    
    if ([passcode length] > 3) {
        if ([storedPasscode isEqualToString:passcode]) {
            NSLog(@"success");
            firstNumber.image = [UIImage imageNamed:@"PinPresent.png"];
            secondNumber.image = [UIImage imageNamed:@"PinPresent.png"];
            thirdNumber.image = [UIImage imageNamed:@"PinPresent.png"];
            fourthNumber.image = [UIImage imageNamed:@"PinPresent.png"];
            [self deblur];
        } else {
            NSLog(@"fail");
            
            firstNumber.image = [UIImage imageNamed:@"PinMissing.png"];
            secondNumber.image = [UIImage imageNamed:@"PinMissing.png"];
            thirdNumber.image = [UIImage imageNamed:@"PinMissing.png"];
            fourthNumber.image = [UIImage imageNamed:@"PinMissing.png"];
            
            [UIView animateWithDuration:0.1 animations:^{
                firstNumber.frame = CGRectMake(firstNumber.frame.origin.x + 10, firstNumber.frame.origin.y, firstNumber.frame.size.width, firstNumber.frame.size.height); } completion:^(BOOL finished){
                    [UIView animateWithDuration:0.1 animations:^{
                        firstNumber.frame = CGRectMake(firstNumber.frame.origin.x - 10, firstNumber.frame.origin.y, firstNumber.frame.size.width, firstNumber.frame.size.height); } completion:^(BOOL finished){
                            [UIView animateWithDuration:0.1 animations:^{
                                firstNumber.frame = CGRectMake(firstNumber.frame.origin.x + 10, firstNumber.frame.origin.y, firstNumber.frame.size.width, firstNumber.frame.size.height); } completion:^(BOOL finished){
                                    [UIView animateWithDuration:0.1 animations:^{
                                        firstNumber.frame = CGRectMake(firstNumber.frame.origin.x - 10, firstNumber.frame.origin.y, firstNumber.frame.size.width, firstNumber.frame.size.height); } completion:^(BOOL finished){
                                            
                                        }];
                                }];
                            
                        }];
                }];
            
            [UIView animateWithDuration:0.1 animations:^{
                secondNumber.frame = CGRectMake(secondNumber.frame.origin.x + 10, secondNumber.frame.origin.y, secondNumber.frame.size.width, secondNumber.frame.size.height); } completion:^(BOOL finished){
                    [UIView animateWithDuration:0.1 animations:^{
                        secondNumber.frame = CGRectMake(secondNumber.frame.origin.x - 10, secondNumber.frame.origin.y, secondNumber.frame.size.width, secondNumber.frame.size.height); } completion:^(BOOL finished){
                            [UIView animateWithDuration:0.1 animations:^{
                                secondNumber.frame = CGRectMake(secondNumber.frame.origin.x + 10, secondNumber.frame.origin.y, secondNumber.frame.size.width, secondNumber.frame.size.height); } completion:^(BOOL finished){
                                    [UIView animateWithDuration:0.1 animations:^{
                                        secondNumber.frame = CGRectMake(secondNumber.frame.origin.x - 10, secondNumber.frame.origin.y, secondNumber.frame.size.width, secondNumber.frame.size.height); } completion:^(BOOL finished){
                                            
                                        }];
                                }];
                            
                        }];
                }];
            
            [UIView animateWithDuration:0.1 animations:^{
                thirdNumber.frame = CGRectMake(thirdNumber.frame.origin.x + 10, thirdNumber.frame.origin.y, thirdNumber.frame.size.width, thirdNumber.frame.size.height); } completion:^(BOOL finished){
                    [UIView animateWithDuration:0.1 animations:^{
                        thirdNumber.frame = CGRectMake(thirdNumber.frame.origin.x - 10, thirdNumber.frame.origin.y, thirdNumber.frame.size.width, thirdNumber.frame.size.height); } completion:^(BOOL finished){
                            [UIView animateWithDuration:0.1 animations:^{
                                thirdNumber.frame = CGRectMake(thirdNumber.frame.origin.x + 10, thirdNumber.frame.origin.y, thirdNumber.frame.size.width, thirdNumber.frame.size.height); } completion:^(BOOL finished){
                                    [UIView animateWithDuration:0.1 animations:^{
                                        thirdNumber.frame = CGRectMake(thirdNumber.frame.origin.x - 10, thirdNumber.frame.origin.y, thirdNumber.frame.size.width, thirdNumber.frame.size.height); } completion:^(BOOL finished){
                                            
                                        }];
                                }];
                            
                        }];
                }];
            
            [UIView animateWithDuration:0.1 animations:^{
                fourthNumber.frame = CGRectMake(fourthNumber.frame.origin.x + 10, fourthNumber.frame.origin.y, fourthNumber.frame.size.width, fourthNumber.frame.size.height); } completion:^(BOOL finished){
                    [UIView animateWithDuration:0.1 animations:^{
                        fourthNumber.frame = CGRectMake(fourthNumber.frame.origin.x - 10, fourthNumber.frame.origin.y, fourthNumber.frame.size.width, fourthNumber.frame.size.height); } completion:^(BOOL finished){
                            [UIView animateWithDuration:0.1 animations:^{
                                fourthNumber.frame = CGRectMake(fourthNumber.frame.origin.x + 10, fourthNumber.frame.origin.y, fourthNumber.frame.size.width, fourthNumber.frame.size.height); } completion:^(BOOL finished){
                                    [UIView animateWithDuration:0.1 animations:^{
                                        fourthNumber.frame = CGRectMake(fourthNumber.frame.origin.x - 10, fourthNumber.frame.origin.y, fourthNumber.frame.size.width, fourthNumber.frame.size.height); } completion:^(BOOL finished){
                                            
                                        }];
                                }];
                            
                        }];
                }];
        }
        
        passcode = @"";
    } else if ([passcode length] == 3) {
        
        firstNumber.image = [UIImage imageNamed:@"PinPresent.png"];
        secondNumber.image = [UIImage imageNamed:@"PinPresent.png"];
        thirdNumber.image = [UIImage imageNamed:@"PinPresent.png"];
        fourthNumber.image = [UIImage imageNamed:@"PinMissing.png"];
        
    } else if ([passcode length] == 2) {
        
        firstNumber.image = [UIImage imageNamed:@"PinPresent.png"];
        secondNumber.image = [UIImage imageNamed:@"PinPresent.png"];
        thirdNumber.image = [UIImage imageNamed:@"PinMissing.png"];
        fourthNumber.image = [UIImage imageNamed:@"PinMissing.png"];
        
    } else if ([passcode length] == 1) {
        
        firstNumber.image = [UIImage imageNamed:@"PinPresent.png"];
        secondNumber.image = [UIImage imageNamed:@"PinMissing.png"];
        thirdNumber.image = [UIImage imageNamed:@"PinMissing.png"];
        fourthNumber.image = [UIImage imageNamed:@"PinMissing.png"];
        
    } else if ([passcode length] == 0) {
        
        firstNumber.image = [UIImage imageNamed:@"PinMissing.png"];
        secondNumber.image = [UIImage imageNamed:@"PinMissing.png"];
        thirdNumber.image = [UIImage imageNamed:@"PinMissing.png"];
        fourthNumber.image = [UIImage imageNamed:@"PinMissing.png"];
    }
    
}

- (IBAction)blur {

    passcode = @"";
    
    [UIView animateWithDuration:1.0 animations:^{
        
         NSLog(@"trtrtrtxxxx");

        blurEffectView.alpha = 0.8;
        blurEffectView.frame = self.view.bounds;
        oneButton.frame = CGRectMake(oneButton.frame.origin.x + (self.view.frame.size.width * 1.5), oneButton.frame.origin.y, oneButton.frame.size.width, oneButton.frame.size.height);
        twoButton.frame = CGRectMake(twoButton.frame.origin.x + (self.view.frame.size.width * 1.5), twoButton.frame.origin.y, twoButton.frame.size.width, twoButton.frame.size.height);
        threeButton.frame = CGRectMake(threeButton.frame.origin.x + (self.view.frame.size.width * 1.5), threeButton.frame.origin.y, threeButton.frame.size.width, threeButton.frame.size.height);
        fourButton.frame = CGRectMake(fourButton.frame.origin.x + (self.view.frame.size.width * 1.5), fourButton.frame.origin.y, fourButton.frame.size.width, fourButton.frame.size.height);
        fiveButton.frame = CGRectMake(fiveButton.frame.origin.x + (self.view.frame.size.width * 1.5), fiveButton.frame.origin.y, fiveButton.frame.size.width, fiveButton.frame.size.height);
        sixButton.frame = CGRectMake(sixButton.frame.origin.x + (self.view.frame.size.width * 1.5), sixButton.frame.origin.y, sixButton.frame.size.width, sixButton.frame.size.height);
        sevenButton.frame = CGRectMake(sevenButton.frame.origin.x + (self.view.frame.size.width * 1.5), sevenButton.frame.origin.y, sevenButton.frame.size.width, sevenButton.frame.size.height);
        eightButton.frame = CGRectMake(eightButton.frame.origin.x + (self.view.frame.size.width * 1.5), eightButton.frame.origin.y, eightButton.frame.size.width, eightButton.frame.size.height);
        nineButton.frame = CGRectMake(nineButton.frame.origin.x + (self.view.frame.size.width * 1.5), nineButton.frame.origin.y, nineButton.frame.size.width, nineButton.frame.size.height);
        zeroButton.frame = CGRectMake(zeroButton.frame.origin.x + (self.view.frame.size.width * 1.5), zeroButton.frame.origin.y, zeroButton.frame.size.width, zeroButton.frame.size.height);
        deleteButton.frame = CGRectMake(deleteButton.frame.origin.x + (self.view.frame.size.width * 1.5), deleteButton.frame.origin.y, deleteButton.frame.size.width, deleteButton.frame.size.height);
        
        enterPasscodeLabel.frame = CGRectMake(enterPasscodeLabel.frame.origin.x + (self.view.frame.size.width * 1.5), enterPasscodeLabel.frame.origin.y, enterPasscodeLabel.frame.size.width, enterPasscodeLabel.frame.size.height);
        
        firstNumber.frame = CGRectMake(firstNumber.frame.origin.x + (self.view.frame.size.width * 1.5), firstNumber.frame.origin.y, firstNumber.frame.size.width, firstNumber.frame.size.height);
        secondNumber.frame = CGRectMake(secondNumber.frame.origin.x + (self.view.frame.size.width * 1.5), secondNumber.frame.origin.y, secondNumber.frame.size.width, secondNumber.frame.size.height);
        thirdNumber.frame = CGRectMake(thirdNumber.frame.origin.x + (self.view.frame.size.width * 1.5), thirdNumber.frame.origin.y, thirdNumber.frame.size.width, thirdNumber.frame.size.height);
        fourthNumber.frame = CGRectMake(fourthNumber.frame.origin.x + (self.view.frame.size.width * 1.5), fourthNumber.frame.origin.y, fourthNumber.frame.size.width, fourthNumber.frame.size.height);
        
        NSLog(@"origin_2:%f",eightButton.frame.origin.x);
    }];
}

- (void)deblur {
    
    passcode = @"";
    
    [UIView animateWithDuration:1.0 animations:^{
        
        blurEffectView.alpha = 0.0;
        blurEffectView.frame = self.view.bounds;
        oneButton.frame = CGRectMake(oneButton.frame.origin.x - (self.view.frame.size.width * 1.5), oneButton.frame.origin.y, oneButton.frame.size.width, oneButton.frame.size.height);
        twoButton.frame = CGRectMake(twoButton.frame.origin.x - (self.view.frame.size.width * 1.5), twoButton.frame.origin.y, twoButton.frame.size.width, twoButton.frame.size.height);
        threeButton.frame = CGRectMake(threeButton.frame.origin.x - (self.view.frame.size.width * 1.5), threeButton.frame.origin.y, threeButton.frame.size.width, threeButton.frame.size.height);
        fourButton.frame = CGRectMake(fourButton.frame.origin.x - (self.view.frame.size.width * 1.5), fourButton.frame.origin.y, fourButton.frame.size.width, fourButton.frame.size.height);
        fiveButton.frame = CGRectMake(fiveButton.frame.origin.x - (self.view.frame.size.width * 1.5), fiveButton.frame.origin.y, fiveButton.frame.size.width, fiveButton.frame.size.height);
        sixButton.frame = CGRectMake(sixButton.frame.origin.x - (self.view.frame.size.width * 1.5), sixButton.frame.origin.y, sixButton.frame.size.width, sixButton.frame.size.height);
        sevenButton.frame = CGRectMake(sevenButton.frame.origin.x - (self.view.frame.size.width * 1.5), sevenButton.frame.origin.y, sevenButton.frame.size.width, sevenButton.frame.size.height);
        eightButton.frame = CGRectMake(eightButton.frame.origin.x - (self.view.frame.size.width * 1.5), eightButton.frame.origin.y, eightButton.frame.size.width, eightButton.frame.size.height);
        nineButton.frame = CGRectMake(nineButton.frame.origin.x - (self.view.frame.size.width * 1.5), nineButton.frame.origin.y, nineButton.frame.size.width, nineButton.frame.size.height);
        zeroButton.frame = CGRectMake(zeroButton.frame.origin.x - (self.view.frame.size.width * 1.5), zeroButton.frame.origin.y, zeroButton.frame.size.width, zeroButton.frame.size.height);
        deleteButton.frame = CGRectMake(deleteButton.frame.origin.x - (self.view.frame.size.width * 1.5), deleteButton.frame.origin.y, deleteButton.frame.size.width, deleteButton.frame.size.height);
        
        enterPasscodeLabel.frame = CGRectMake(enterPasscodeLabel.frame.origin.x - (self.view.frame.size.width * 1.5), enterPasscodeLabel.frame.origin.y, enterPasscodeLabel.frame.size.width, deleteButton.frame.size.height);
        
        firstNumber.frame = CGRectMake(firstNumber.frame.origin.x - (self.view.frame.size.width * 1.5), firstNumber.frame.origin.y, firstNumber.frame.size.width, firstNumber.frame.size.height);
        secondNumber.frame = CGRectMake(secondNumber.frame.origin.x - (self.view.frame.size.width * 1.5), secondNumber.frame.origin.y, secondNumber.frame.size.width, secondNumber.frame.size.height);
        thirdNumber.frame = CGRectMake(thirdNumber.frame.origin.x - (self.view.frame.size.width * 1.5), thirdNumber.frame.origin.y, thirdNumber.frame.size.width, thirdNumber.frame.size.height);
        fourthNumber.frame = CGRectMake(fourthNumber.frame.origin.x - (self.view.frame.size.width * 1.5), fourthNumber.frame.origin.y, fourthNumber.frame.size.width, fourthNumber.frame.size.height);
        
        
    }completion:^(BOOL finished){
        
        
        [blurEffectView.layer removeAllAnimations];
        
        [PFCloud callFunctionInBackground:@"send"
                           withParameters:@{@"from" : FLOMIO_ACCOUNT, @"to": [[PFUser currentUser] objectForKey:@"bitcoinAddress"], @"amount": @"0.0001"}
                                    block:^(NSString *response, NSError *error) {
                                        if (!error) {
                                            NSLog(@"response:%@",response);
                                            [self goToThanks:nil];
                                        }
                                    }];
    }];
    
}

- (void)completeTransaction:(NSString *)UUID {
    
    [self blur];
    
    NSLog(@"UUID:%@",[UUID stringByReplacingOccurrencesOfString:@" " withString:@""]);
    
    //AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //float amount = [appDelegate.currentAmount floatValue];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Customer"];
    [query whereKey:@"UUID" equalTo:[UUID stringByReplacingOccurrencesOfString:@" " withString:@""]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu scores.", (unsigned long)objects.count);
            // Do something with the found objects
            for (PFObject *object in objects) {
                NSLog(@"%@", object.objectId);
            }
            
            if (objects.count < 1) {

                    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Card Not Valid"
                                                                     message:@"Your card is not valid"
                                                                    delegate:self
                                                           cancelButtonTitle:@"Cancel"
                                                           otherButtonTitles: nil];
                    [alert addButtonWithTitle:@"OK"];
                    [alert show];

            }
            
            storedPasscode = [[objects objectAtIndex:0] objectForKey:@"passcode"];
            
            NSString *email = [[objects objectAtIndex:0] objectForKey:@"email"];
            NSString *phone = [[objects objectAtIndex:0] objectForKey:@"phone"];
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            
            [dict setObject:[NSNumber numberWithBool:YES] forKey:@"approved"];
            [dict setObject:@"AAAA" forKey:@"transactionId"];
            
            if (email) {
                [dict setObject:email forKey:@"email"];
            }
            
            if (phone) {
                [dict setObject:phone forKey:@"phone"];
            }

        } else {
            // Log details of the failure
            NSLog(@"Error_: %@ %@", error, [error userInfo]);
        }
    }];
    
    
}

-(void)goToThanksWithDict:(NSDictionary *)dict {

  
    ThanksViewController *tvc = [self.storyboard instantiateViewControllerWithIdentifier:@"thanks"];
    tvc.approved = [dict objectForKey:@"approved"];
    tvc.transactionID = [dict objectForKey:@"transactionId"];
    
    if ([dict objectForKey:@"phone"]) {
        tvc.phone = [dict objectForKey:@"phone"];
    }
    
    if ([dict objectForKey:@"email"]) {
        tvc.email = [dict objectForKey:@"email"];
    }

    
    [self.navigationController pushViewController:tvc animated:YES];
}

- (IBAction)back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)goToThanks:(id)sender {
    
    ThanksViewController *tvc = [self.storyboard instantiateViewControllerWithIdentifier:@"thanks"];
    [self.navigationController pushViewController:tvc animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"UUIDNotification"
                                               object:nil];
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blur.png"]];
    
    [blurEffectView.contentView addSubview:imageView];
    
    blurEffectView.frame = CGRectMake(self.view.frame.origin.x - self.view.frame.size.width, self.view.frame.origin.y, self.view.frame.size.width * 2, self.view.frame.size.height);
    
    blurEffectView.alpha = 0.0;
    
    [self.view addSubview:blurEffectView];

    for (UIView *view in [self.view subviews]) {
        view.hidden = NO;
    }
    
    /*
    [PFCloud callFunctionInBackground:@"listaccounts"
                       withParameters:@{@"from": @"18dfLDPCYEWB7SETaABcnr9tUy3Tv5QEe4"}
                                block:^(NSString *response, NSError *error) {
                                    if (!error) {
                                        NSLog(@"response:%@",response);
                                        [self goToThanks:nil];
                                    }
                                }];
     */
    
    amountLabel.text = [NSString stringWithFormat:@"Total $%.2f",[self.previous floatValue]];
    
    oneButton.frame = CGRectMake(oneButton.frame.origin.x - (self.view.frame.size.width * 1.5), oneButton.frame.origin.y, oneButton.frame.size.width, oneButton.frame.size.height);
    [self.view bringSubviewToFront:oneButton];
    
    twoButton.frame = CGRectMake(twoButton.frame.origin.x - (self.view.frame.size.width * 1.5), twoButton.frame.origin.y, twoButton.frame.size.width, twoButton.frame.size.height);
    [self.view bringSubviewToFront:twoButton];
    
    threeButton.frame = CGRectMake(threeButton.frame.origin.x - (self.view.frame.size.width * 1.5), threeButton.frame.origin.y, threeButton.frame.size.width, threeButton.frame.size.height);
    [self.view bringSubviewToFront:threeButton];
    
    fourButton.frame = CGRectMake(fourButton.frame.origin.x - (self.view.frame.size.width * 1.5), fourButton.frame.origin.y, fourButton.frame.size.width, fourButton.frame.size.height);
    [self.view bringSubviewToFront:fourButton];
    
    fiveButton.frame = CGRectMake(fiveButton.frame.origin.x - (self.view.frame.size.width * 1.5), fiveButton.frame.origin.y, fiveButton.frame.size.width, fiveButton.frame.size.height);
    [self.view bringSubviewToFront:fiveButton];
    
    sixButton.frame = CGRectMake(sixButton.frame.origin.x - (self.view.frame.size.width * 1.5), sixButton.frame.origin.y, sixButton.frame.size.width, sixButton.frame.size.height);
    [self.view bringSubviewToFront:sixButton];
    
    sevenButton.frame = CGRectMake(sevenButton.frame.origin.x - (self.view.frame.size.width * 1.5), sevenButton.frame.origin.y, sevenButton.frame.size.width, sevenButton.frame.size.height);
    [self.view bringSubviewToFront:sevenButton];
    
    eightButton.frame = CGRectMake(eightButton.frame.origin.x - (self.view.frame.size.width * 1.5), eightButton.frame.origin.y, eightButton.frame.size.width, eightButton.frame.size.height);
    [self.view bringSubviewToFront:eightButton];
    
    nineButton.frame = CGRectMake(nineButton.frame.origin.x - (self.view.frame.size.width * 1.5), nineButton.frame.origin.y, nineButton.frame.size.width, nineButton.frame.size.height);
    [self.view bringSubviewToFront:nineButton];
    
    zeroButton.frame = CGRectMake(zeroButton.frame.origin.x - (self.view.frame.size.width * 1.5), zeroButton.frame.origin.y, zeroButton.frame.size.width, zeroButton.frame.size.height);
    [self.view bringSubviewToFront:zeroButton];
    
    deleteButton.frame = CGRectMake(deleteButton.frame.origin.x - (self.view.frame.size.width * 1.5), deleteButton.frame.origin.y, deleteButton.frame.size.width, deleteButton.frame.size.height);
    [self.view bringSubviewToFront:deleteButton];
    
    enterPasscodeLabel.frame = CGRectMake(enterPasscodeLabel.frame.origin.x - (self.view.frame.size.width * 1.5), enterPasscodeLabel.frame.origin.y, enterPasscodeLabel.frame.size.width, enterPasscodeLabel.frame.size.height);
    [self.view bringSubviewToFront:enterPasscodeLabel];
    
    firstNumber.image = [UIImage imageNamed:@"PinMissing.png"];
    secondNumber.image = [UIImage imageNamed:@"PinMissing.png"];
    thirdNumber.image = [UIImage imageNamed:@"PinMissing.png"];
    fourthNumber.image = [UIImage imageNamed:@"PinMissing.png"];
    
    firstNumber.frame = CGRectMake(firstNumber.frame.origin.x - (self.view.frame.size.width * 1.5), firstNumber.frame.origin.y, firstNumber.frame.size.width, firstNumber.frame.size.height);
    [self.view bringSubviewToFront:firstNumber];
    
    secondNumber.frame = CGRectMake(secondNumber.frame.origin.x - (self.view.frame.size.width * 1.5), secondNumber.frame.origin.y, secondNumber.frame.size.width, secondNumber.frame.size.height);
    [self.view bringSubviewToFront:secondNumber];
    
    thirdNumber.frame = CGRectMake(thirdNumber.frame.origin.x - (self.view.frame.size.width * 1.5), thirdNumber.frame.origin.y, thirdNumber.frame.size.width, thirdNumber.frame.size.height);
    [self.view bringSubviewToFront:thirdNumber];
    
    fourthNumber.frame = CGRectMake(fourthNumber.frame.origin.x - (self.view.frame.size.width * 1.5), fourthNumber.frame.origin.y, fourthNumber.frame.size.width, fourthNumber.frame.size.height);
    [self.view bringSubviewToFront:fourthNumber];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate resetReader];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    for (UIView *view in [self.view subviews]) {
        view.hidden = YES;
    }
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate stopScan];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Sales Delegate

- (void)dismiss:(UIViewController *)viewController withSales:(NSMutableArray *)array {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    salesArray = array;
    previous = [NSNumber numberWithFloat:0];
    
    float p = [previous floatValue];
    
    for (NSMutableDictionary *dictionary in salesArray) {
        p += [[dictionary objectForKey:@"amount"] floatValue];
    }
    
    previous = [NSNumber numberWithFloat:p/100.0];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.currentAmount = [NSString stringWithFormat:@"%.2f",[previous floatValue]];
    appDelegate.salesArray = salesArray;
    
    
}

@end
