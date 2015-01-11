//
//  ATMViewController.m
//  bitflo
//
//  Created by Boris  on 1/10/15.
//  Copyright (c) 2015 LLT. All rights reserved.
//

#import "ContactlessViewController.h"
#import "ThanksViewController.h"
#import <CommonCrypto/CommonCrypto.h>
#import "AJDHex.h"  // TODO: this file shouldn't be needed as functions are duplicated here.
#import "AppDelegate.h"
#import "ATMViewController.h"
#import "ConfigurationsViewController.h"
#import "ViewController.h"

@interface ATMViewController ()

@end

@implementation ATMViewController  {
    
    ACRAudioJackReader *_reader;
    ACRDukptReceiver *_dukptReceiver;
    int _swipeCount;
    
    NSCondition *_responseCondition;
    
    BOOL _firmwareVersionReady;
    NSString *_firmwareVersion;
    
    BOOL _statusReady;
    ACRStatus *_status;
    
    BOOL _resultReady;
    ACRResult *_result;
    
    BOOL _customIdReady;
    NSData *_customId;
    
    BOOL _deviceIdReady;
    NSData *_deviceId;
    
    BOOL _dukptOptionReady;
    BOOL _dukptOption;
    
    BOOL _trackDataOptionReady;
    ACRTrackDataOption _trackDataOption;
    
    BOOL _piccAtrReady;
    NSData *_piccAtr;
    
    BOOL _piccResponseApduReady;
    NSData *_piccResponseApdu;
    
    NSUserDefaults *_defaults;
    NSData *_masterKey;
    NSData *_masterKey2;
    NSData *_aesKey;
    NSData *_iksn;
    NSData *_ipek;
    
    NSString *_piccTimeoutString;
    NSString *_piccCardTypeString;
    NSString *_piccCommandApduString;
    NSString *_piccRfConfigString;
    
    NSUInteger _piccTimeout;
    NSUInteger _piccCardType;
    NSData *_piccCommandApdu;
    NSData *_piccRfConfig;
    
    UIAlertView *_trackDataAlert;
}

@synthesize logView, amountTextField;
@synthesize oneButton, twoButton, threeButton, fourButton, fiveButton, sixButton, sevenButton, eightButton, nineButton, zeroButton, deleteButton;
@synthesize firstNumber, secondNumber, thirdNumber, fourthNumber, enterPasscodeLabel;

- (IBAction)goToMain:(id)sender {
    
    ViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"main_merchant"];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)goToConfigurations:(id)sender {
    
    ConfigurationsViewController *cvc = [self.storyboard instantiateViewControllerWithIdentifier:@"conf"];
    [self.navigationController pushViewController:cvc animated:YES];
    
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
    
    passcode = [NSString stringWithFormat:@"%@%li",passcode,(long)selectedButton];
    NSLog(@"passcode:%@",passcode);
    
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
        
    }
    
}

- (void)blur {
    
    passcode = @"";
    
    [UIView animateWithDuration:1.0 animations:^{
        
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
        deleteButton.frame = CGRectMake(deleteButton.frame.origin.x + (self.view.frame.size.width * 0.5), deleteButton.frame.origin.y, deleteButton.frame.size.width, deleteButton.frame.size.height);
        
        enterPasscodeLabel.frame = CGRectMake(enterPasscodeLabel.frame.origin.x + (self.view.frame.size.width * 0.5), enterPasscodeLabel.frame.origin.y, enterPasscodeLabel.frame.size.width, enterPasscodeLabel.frame.size.height);
        
        firstNumber.frame = CGRectMake(firstNumber.frame.origin.x + (self.view.frame.size.width * 1.5), firstNumber.frame.origin.y, firstNumber.frame.size.width, firstNumber.frame.size.height);
        secondNumber.frame = CGRectMake(secondNumber.frame.origin.x + (self.view.frame.size.width * 1.5), secondNumber.frame.origin.y, secondNumber.frame.size.width, secondNumber.frame.size.height);
        thirdNumber.frame = CGRectMake(thirdNumber.frame.origin.x + (self.view.frame.size.width * 1.5), thirdNumber.frame.origin.y, thirdNumber.frame.size.width, thirdNumber.frame.size.height);
        fourthNumber.frame = CGRectMake(fourthNumber.frame.origin.x + (self.view.frame.size.width * 1.5), fourthNumber.frame.origin.y, fourthNumber.frame.size.width, fourthNumber.frame.size.height);
        
        
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
        deleteButton.frame = CGRectMake(deleteButton.frame.origin.x - (self.view.frame.size.width * 1), deleteButton.frame.origin.y, deleteButton.frame.size.width, deleteButton.frame.size.height);
        
        enterPasscodeLabel.frame = CGRectMake(enterPasscodeLabel.frame.origin.x - (self.view.frame.size.width * 1), enterPasscodeLabel.frame.origin.y, enterPasscodeLabel.frame.size.width, deleteButton.frame.size.height);
        
        firstNumber.frame = CGRectMake(firstNumber.frame.origin.x - (self.view.frame.size.width * 1.5), firstNumber.frame.origin.y, firstNumber.frame.size.width, firstNumber.frame.size.height);
        secondNumber.frame = CGRectMake(secondNumber.frame.origin.x - (self.view.frame.size.width * 1.5), secondNumber.frame.origin.y, secondNumber.frame.size.width, secondNumber.frame.size.height);
        thirdNumber.frame = CGRectMake(thirdNumber.frame.origin.x - (self.view.frame.size.width * 1.5), thirdNumber.frame.origin.y, thirdNumber.frame.size.width, thirdNumber.frame.size.height);
        fourthNumber.frame = CGRectMake(fourthNumber.frame.origin.x - (self.view.frame.size.width * 1.5), fourthNumber.frame.origin.y, fourthNumber.frame.size.width, fourthNumber.frame.size.height);
        
        
    }completion:^(BOOL finished){
        
        
        [PFCloud callFunctionInBackground:@"transfer"
                           withParameters:@{@"to": @"aaaaa", @"from": @"aaaaa", @"amount": @"aaaaa"}
                                    block:^(NSString *response, NSError *error) {
                                        if (!error) {
                                            [self goToThanks:nil];
                                        }
                                    }];
    }];
    
}


- (IBAction)numbersMethod:(id)sender {
    
    int typedNumber = 0;
    NSString *currentInputText = @"0";
    
    switch ([sender tag]) {
        case 1:
            typedNumber = 1;
            break;
        case 2:
            typedNumber = 2;
            break;
        case 3:
            typedNumber = 3;
            break;
        case 4:
            typedNumber = 4;
            break;
        case 5:
            typedNumber = 5;
            break;
        case 6:
            typedNumber = 6;
            break;
        case 7:
            typedNumber = 7;
            break;
        case 8:
            typedNumber = 8;
            break;
        case 9:
            typedNumber = 9;
            break;
        case 10:
            typedNumber = 0;
            break;
        case 11:
            typedNumber = 11;
            break;
        case 12:
            typedNumber = 12;
            break;
        default:
            break;
    }
    
    
    if (typedNumber < 11) {
        if (currentInput > 0) {
            currentInputText = [NSString stringWithFormat:@"%i%i",currentInput,typedNumber];
        } else {
            currentInputText = [NSString stringWithFormat:@"%i",typedNumber];
        }
        
        currentInput = (int)[currentInputText integerValue];
        
        
        if ([currentInputText length] > 2) {
            int breakPoint = (int)[currentInputText length] - 2;
            currentInputText = [NSString stringWithFormat:@"%@.%@",[currentInputText substringWithRange:NSMakeRange (0, breakPoint)],[currentInputText substringFromIndex:breakPoint]];
        } else {
            currentInputText = [NSString stringWithFormat:@"0.%02d",currentInput];
            
        }
        
        amountTextField.text = [NSString stringWithFormat:@"$%.2f", [currentInputText floatValue]];
        
        
    } else if (typedNumber == 11) {
        
        currentInputText = @"0";
        currentInput = 0;
        amountTextField.text = [NSString stringWithFormat:@"$0.00"];
        
    }

}



- (void)completeTransaction:(NSString *)UUID {
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    float amount = [appDelegate.currentAmount floatValue];
    
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
            
            [self blur];
            //[self performSelectorOnMainThread:@selector(goToThanksWithDict:) withObject:dict waitUntilDone:YES];
            
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
    
    deleteButton.frame = CGRectMake(deleteButton.frame.origin.x - (self.view.frame.size.width * 1), deleteButton.frame.origin.y, deleteButton.frame.size.width, deleteButton.frame.size.height);
    [self.view bringSubviewToFront:zeroButton];
    
    enterPasscodeLabel.frame = CGRectMake(enterPasscodeLabel.frame.origin.x - (self.view.frame.size.width * 1), enterPasscodeLabel.frame.origin.y, enterPasscodeLabel.frame.size.width, enterPasscodeLabel.frame.size.height);
    [self.view bringSubviewToFront:zeroButton];
    
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
    
    [self resetReader];
    
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

- (void)setLogFile {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *docDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    filePath = [NSString stringWithFormat:@"%@/log/log.txt", docDirPath];
    
    if (![fileManager fileExistsAtPath:filePath]){
        [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blur.png"]];
    
    [blurEffectView.contentView addSubview:imageView];
    
    blurEffectView.frame = CGRectMake(self.view.frame.origin.x - self.view.frame.size.width, self.view.frame.origin.y, self.view.frame.size.width * 2, self.view.frame.size.height);
    
    blurEffectView.alpha = 0.0;
    
    [self.view addSubview:blurEffectView];
    
    //[self setLogFile];
    
    // Register an observer for the Audio Session Route change notification.
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(handleRouteChange:)
                                                 name: AVAudioSessionRouteChangeNotification
                                               object: [AVAudioSession sharedInstance]];
    
    // Do any additional setup after loading the view, typically from a nib.
    
    // Initialize ACRAudioJackReader object.
    _reader = [[ACRAudioJackReader alloc] init];
    [_reader setDelegate:self];
    
    _swipeCount = 0;
    
    _responseCondition = [[NSCondition alloc] init];
    
    _firmwareVersionReady = NO;
    _firmwareVersion = nil;
    
    _statusReady = NO;
    _status = nil;
    
    _resultReady = NO;
    _result = nil;
    
    _customIdReady = NO;
    _customId = nil;
    
    _deviceIdReady = NO;
    _deviceId = nil;
    
    _dukptOptionReady = NO;
    _dukptOption = NO;
    
    _trackDataOptionReady = NO;
    _trackDataOption = NO;
    
    _piccAtrReady = NO;
    _piccAtr = nil;
    
    _piccResponseApduReady = NO;
    _piccResponseApdu = nil;
    
    // Load the settings.
    _defaults = [NSUserDefaults standardUserDefaults];
    
    _masterKey = [_defaults dataForKey:@"MasterKey"];
    if (_masterKey == nil) {
        _masterKey = [AJDHex byteArrayFromHexString:@"00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00"]; // TODO: Need to swap AJDHex class for local function call as Utilities are continaed herein
    }
    
    _masterKey2 = [_defaults dataForKey:@"MasterKey2"];
    if (_masterKey2 == nil) {
        _masterKey2 = [AJDHex byteArrayFromHexString:@"00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00"];
    }
    
    _aesKey = [_defaults dataForKey:@"AesKey"];
    if (_aesKey == nil) {
        _aesKey = [AJDHex byteArrayFromHexString:@"4E 61 74 68 61 6E 2E 4C 69 20 54 65 64 64 79 20"];
    }
    
    _iksn = [_defaults dataForKey:@"IKSN"];
    if (_iksn == nil) {
        _iksn = [AJDHex byteArrayFromHexString:@"FF FF 98 76 54 32 10 E0 00 00"];
    }
    
    _ipek = [_defaults dataForKey:@"IPEK"];
    if (_ipek == nil) {
        _ipek = [AJDHex byteArrayFromHexString:@"6A C2 92 FA A1 31 5B 4D 85 8A B3 A3 D7 D5 93 3A"];
    }
    
    _piccTimeoutString = [_defaults stringForKey:@"PiccTimeout"];
    _piccCardTypeString = [_defaults stringForKey:@"PiccCardType"];
    _piccCommandApduString = [_defaults stringForKey:@"PiccCommandApdu"];
    _piccRfConfigString = [_defaults stringForKey:@"PiccRfConfig"];
    
    if (_piccTimeoutString == nil) {
        _piccTimeoutString = @"1";
    }
    
    if (_piccCardTypeString == nil) {
        _piccCardTypeString = @"8F";
    }
    
    if (_piccCommandApduString == nil) {
        _piccCommandApduString = @"00 84 00 00 08";
    }
    
    if (_piccRfConfigString == nil) {
        _piccRfConfigString = @"07 85 85 85 85 85 85 85 85 69 69 69 69 69 69 69 69 3F 3F";
    }
    
    _piccTimeout = [_piccTimeoutString integerValue];
    uint8_t cardType[] = { 0 };
    [self toByteArray:_piccCardTypeString buffer:cardType bufferSize:sizeof(cardType)];
    _piccCardType = cardType[0];
    _piccCommandApdu = [self toByteArray:_piccCommandApduString];
    _piccRfConfig = [self toByteArray:_piccRfConfigString];
    
    // Initialize the DUKPT receiver object.
    _dukptReceiver = [[ACRDukptReceiver alloc] init];
    
    // Set the key serial number.
    [_dukptReceiver setKeySerialNumber:_iksn];
    
    // Load the initial key.
    [_dukptReceiver loadInitialKey:_ipek];
    
    
}

- (IBAction)Next:(id)sender {
    
    UITabBarController *tbc = [self.storyboard instantiateViewControllerWithIdentifier:@"tab"];
    [self.navigationController pushViewController:tbc animated:YES];
}

#pragma mark - Utility functions

- (NSString *)toHexString:(const uint8_t *)buffer length:(size_t)length {
    
    NSString *hexString = @"";
    size_t i = 0;
    
    for (i = 0; i < length; i++) {
        if (i == 0) {
            hexString = [hexString stringByAppendingFormat:@"%02X", buffer[i]];
        } else {
            hexString = [hexString stringByAppendingFormat:@" %02X", buffer[i]];
        }
    }
    
    return hexString;
}

- (NSUInteger)toByteArray:(NSString *)hexString buffer:(uint8_t *)buffer bufferSize:(NSUInteger)bufferSize {
    
    NSUInteger length = 0;
    BOOL first = YES;
    int num = 0;
    unichar c = 0;
    NSUInteger i = 0;
    
    for (i = 0; i < [hexString length]; i++) {
        
        c = [hexString characterAtIndex:i];
        if ((c >= '0') && (c <= '9')) {
            num = c - '0';
        } else if ((c >= 'A') && (c <= 'F')) {
            num = c - 'A' + 10;
        } else if ((c >= 'a') && (c <= 'f')) {
            num = c - 'a' + 10;
        } else {
            num = -1;
        }
        
        if (num >= 0) {
            
            if (first) {
                
                buffer[length] = num << 4;
                
            } else {
                
                buffer[length] |= num;
                length++;
            }
            
            first = !first;
        }
        
        if (length >= bufferSize) {
            break;
        }
    }
    
    return length;
}

- (NSData *)toByteArray:(NSString *)hexString {
    
    NSData *byteArray = nil;
    uint8_t *buffer = NULL;
    NSUInteger i = 0;
    unichar c = 0;
    NSUInteger count = 0;
    int num = 0;
    BOOL first = YES;
    NSUInteger length = 0;
    
    // Count the number of HEX characters.
    for (i = 0; i < [hexString length]; i++) {
        
        c = [hexString characterAtIndex:i];
        if (((c >= '0') && (c <= '9')) ||
            ((c >= 'A') && (c <= 'F')) ||
            ((c >= 'a') && (c <= 'f'))) {
            count++;
        }
    }
    
    // Allocate the buffer.
    buffer = (uint8_t *) malloc((count + 1) / 2);
    
    if (buffer != NULL) {
        
        for (i = 0; i < [hexString length]; i++) {
            
            c = [hexString characterAtIndex:i];
            if ((c >= '0') && (c <= '9')) {
                num = c - '0';
            } else if ((c >= 'A') && (c <= 'F')) {
                num = c - 'A' + 10;
            } else if ((c >= 'a') && (c <= 'f')) {
                num = c - 'a' + 10;
            } else {
                num = -1;
            }
            
            if (num >= 0) {
                
                if (first) {
                    
                    buffer[length] = num << 4;
                    
                } else {
                    
                    buffer[length] |= num;
                    length++;
                }
                
                first = !first;
            }
        }
        
        // Create the byte array.
        byteArray = [[NSData alloc] initWithBytes:buffer length:length];
        
        // Free the buffer.
        free(buffer);
        buffer = NULL;
    }
    
    return byteArray;
}

- (NSString *)toBatteryLevelString:(NSUInteger)batteryLevel {
    
    NSString *batteryLevelString = nil;
    
    switch (batteryLevel) {
        case 0:
            batteryLevelString = @">= 3.00V";
            break;
        case 1:
            batteryLevelString = @"2.90V - 2.99V";
            break;
        case 2:
            batteryLevelString = @"2.80V - 2.89V";
            break;
        case 3:
            batteryLevelString = @"2.70V - 2.79V";
            break;
        case 4:
            batteryLevelString = @"2.60V - 2.69V";
            break;
        case 5:
            batteryLevelString = @"2.50V - 2.59V";
            break;
        case 6:
            batteryLevelString = @"2.40V - 2.49V";
            break;
        case 7:
            batteryLevelString = @"2.30V - 2.39V";
            break;
        case 8:
            batteryLevelString = @"< 2.30V";
            break;
        default:
            batteryLevelString = @"Unknown";
            break;
    }
    
    return batteryLevelString;
}

- (NSString *)toErrorCodeString:(NSUInteger)errorCode {
    
    NSString *errorCodeString = nil;
    
    switch (errorCode) {
        case ACRErrorSuccess:
            errorCodeString = @"The operation completed successfully.";
            break;
        case ACRErrorInvalidCommand:
            errorCodeString = @"The command is invalid.";
            break;
        case ACRErrorInvalidParameter:
            errorCodeString = @"The parameter is invalid.";
            break;
        case ACRErrorInvalidChecksum:
            errorCodeString = @"The checksum is invalid.";
            break;
        case ACRErrorInvalidStartByte:
            errorCodeString = @"The start byte is invalid.";
            break;
        case ACRErrorUnknown:
            errorCodeString = @"The error is unknown.";
            break;
        case ACRErrorDukptOperationCeased:
            errorCodeString = @"The DUKPT operation is ceased.";
            break;
        case ACRErrorDukptDataCorrupted:
            errorCodeString = @"The DUKPT data is corrupted.";
            break;
        case ACRErrorFlashDataCorrupted:
            errorCodeString = @"The flash data is corrupted.";
            break;
        case ACRErrorVerificationFailed:
            errorCodeString = @"The verification is failed.";
            break;
        default:
            errorCodeString = @"Error communicating with reader.";
            break;
    }
    
    return errorCodeString;
}

- (BOOL)decryptData:(const void *)dataIn dataInLength:(size_t)dataInLength key:(const void *)key keyLength:(size_t)keyLength dataOut:(void *)dataOut dataOutLength:(size_t)dataOutLength pBytesReturned:(size_t *)pBytesReturned {
    
    BOOL ret = NO;
    
    // Decrypt the data.
    if (CCCrypt(kCCDecrypt, kCCAlgorithmAES128, 0, key, keyLength, NULL, dataIn, dataInLength, dataOut, dataOutLength, pBytesReturned) == kCCSuccess) {
        ret = YES;
    }
    
    return ret;
}

// TODO: This is the function that should clear all the fields in the app or Credit Card data
- (IBAction)clearData:(id)sender {
    
    _swipeCount = 0;
    
    //    self.swipeCountLabel.text = @"0";
    //    self.batteryStatusLabel.text = @"";
    //    self.dataReceivedLabel.text = @"";
    //    self.keySerialNumberLabel.text = @"";
    //    self.track1MacLabel.text = @"";
    //    self.track2MacLabel.text = @"";
    //
    //    self.track1Jis2DataLabel.text = @"";
    //    self.track1PrimaryAccountNumberLabel.text = @"";
    //    self.track1NameLabel.text = @"";
    //    self.track1ExpirationDateLabel.text = @"";
    //    self.track1ServiceCodeLabel.text = @"";
    //    self.track1DiscretionaryDataLabel.text = @"";
    //
    //    self.track2PrimaryAccountNumberLabel.text = @"";
    //    self.track2ExpirationDateLabel.text = @"";
    //    self.track2ServiceCodeLabel.text = @"";
    //    self.track2DiscretionaryDataLabel.text = @"";
    //
    //    [self.tableView reloadData];
}

- (void)resetReader {
    
    // Show the progress.
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Resetting the reader..." delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    //[alert show];
    
    // Reset the reader.
    [_reader resetWithCompletion:^{
        
        // Hide the progress.
        
        self.observingMessages = YES;
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        self.timerSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(self.timerSource, dispatch_walltime(NULL, 0), 0.5 * NSEC_PER_SEC, 1ull * NSEC_PER_SEC);
        dispatch_source_set_event_handler(self.timerSource, ^{
            if (self.isObservingMessages) {
                //[self transmit:nil];
                [self powerOn];
            }
        });
        dispatch_resume(self.timerSource);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [alert dismissWithClickedButtonIndex:0 animated:YES];
        });
        
    }];
}

- (IBAction)resetReader_b:(id)sender {
    
    [self resetReader];
}

- (IBAction)transmit:(id)sender {
    
    // Transmit the command APDU.
    _piccResponseApduReady = NO;
    _resultReady = NO;
    
    // Show the PICC response APDU.
    //[self showPiccResponseApdu:piccViewController];
    
    NSData *commandApdu = nil;
    commandApdu = [AJDHex byteArrayFromHexString:@"FF CA 00 00 00"];
    
    if (![_reader piccTransmitWithTimeout:9.0 commandApdu:[commandApdu bytes] length:[commandApdu length]]) {
        
        // Show the request queue error.
        [self showRequestQueueError];
        
    } else {
        
        [self powerOn];
        
    }
    
}

-(void)powerOn {
    
    /*
     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Powering on the PICC..." delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
     [alert show];
     */
    
    // Clear the ATR.
    
    // Power on the PICC.
    _piccAtrReady = NO;
    _resultReady = NO;
    if (![_reader piccPowerOnWithTimeout:_piccTimeout cardType:_piccCardType]) {
        
        // Show the request queue error.
        [self showRequestQueueError];
        
    } else {
        
        //NSLog(@"Success");
        // Show the PICC ATR.
        //[self showPiccAtr:piccViewController];
    }
    
}

- (void)showRequestQueueError {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        // Show the result.
        UIAlertView *resultAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"The request cannot be queued." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [resultAlert show];
    });
}

- (void)setSleep {
    
    // Show the progress.
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Setting the reader to sleep..." delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    [alert show];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // Set the reader to sleep.
        _resultReady = NO;
        if (![_reader sleep]) {
            
            // TODO: Show the sleep request queue error (this should only happen when App goes to background so perhaps a Nitification?).
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reader Error"
                                                            message:@"The reader couldn't be set to sleep"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
        } else {
            
            // This is simply a place holder for the Successful Sleep state. Not needed for this app.
        }
        
        // Hide the progress.
        dispatch_async(dispatch_get_main_queue(), ^{
            [alert dismissWithClickedButtonIndex:0 animated:YES];
        });
    });
}

#pragma mark - Audio Jack Reader Delegate

- (void)reader:(ACRAudioJackReader *)reader didNotifyResult:(ACRResult *)result {
    
    [_responseCondition lock];
    _result = result;
    _resultReady = YES;
    [_responseCondition signal];
    [_responseCondition unlock];
}

- (void)reader:(ACRAudioJackReader *)reader didSendFirmwareVersion:(NSString *)firmwareVersion {
    
    [_responseCondition lock];
    _firmwareVersion = firmwareVersion;
    _firmwareVersionReady = YES;
    [_responseCondition signal];
    [_responseCondition unlock];
}

- (void)reader:(ACRAudioJackReader *)reader didSendStatus:(ACRStatus *)status {
    
    [_responseCondition lock];
    _status = status;
    _statusReady = YES;
    [_responseCondition signal];
    [_responseCondition unlock];
}

- (void)readerDidNotifyTrackData:(ACRAudioJackReader *)reader {
    
    // Show the track data alert.
    dispatch_async(dispatch_get_main_queue(), ^{
        
        _trackDataAlert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Processing the track data..." delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
        [_trackDataAlert show];
        
        // Dismiss the track data alert after 5 seconds.
        [self performSelector:@selector(AJD_dismissAlertView:) withObject:_trackDataAlert afterDelay:5];
    });
}

- (void)reader:(ACRAudioJackReader *)reader didSendTrackData:(ACRTrackData *)trackData {
    
    ACRTrack1Data *track1Data = [[ACRTrack1Data alloc] init];
    ACRTrack2Data *track2Data = [[ACRTrack2Data alloc] init];
    ACRTrack1Data *track1MaskedData = [[ACRTrack1Data alloc] init];
    ACRTrack2Data *track2MaskedData = [[ACRTrack2Data alloc] init];
    NSString *track1MacString = @"";
    NSString *track2MacString = @"";
    //NSString *batteryStatusString = [self AJD_stringFromBatteryStatus:trackData.batteryStatus];
    NSString *keySerialNumberString = @"";
    NSString *errorString = @"";
    
    // Dismiss the track data alert.
    dispatch_async(dispatch_get_main_queue(), ^{
        [self AJD_dismissAlertView:_trackDataAlert];
    });
    
    if ((trackData.track1ErrorCode != ACRTrackErrorSuccess) &&
        (trackData.track2ErrorCode != ACRTrackErrorSuccess)) {
        
        errorString = @"The track 1 and track 2 data";
        
    } else {
        
        if (trackData.track1ErrorCode != ACRTrackErrorSuccess) {
            errorString = @"The track 1 data";
        }
        
        if (trackData.track2ErrorCode != ACRTrackErrorSuccess) {
            errorString = @"The track 2 data";
        }
    }
    
    errorString = [errorString stringByAppendingString:@" may be corrupted. Please swipe the card again!"];
    
    // Show the track error.
    if ((trackData.track1ErrorCode != ACRTrackErrorSuccess) ||
        (trackData.track2ErrorCode != ACRTrackErrorSuccess)) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:errorString message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        });
    }
    
    if ([trackData isKindOfClass:[ACRAesTrackData class]]) {
        
        ACRAesTrackData *aesTrackData = (ACRAesTrackData *) trackData;
        uint8_t *buffer = (uint8_t *) [aesTrackData.trackData bytes];
        NSUInteger bufferLength = [aesTrackData.trackData length];
        uint8_t decryptedTrackData[128];
        size_t decryptedTrackDataLength = 0;
        
        // Decrypt the track data.
        if (![self decryptData:buffer dataInLength:bufferLength key:[_aesKey bytes] keyLength:[_aesKey length] dataOut:decryptedTrackData dataOutLength:sizeof(decryptedTrackData) pBytesReturned:&decryptedTrackDataLength]) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"The track data cannot be decrypted. Please swipe the card again!" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
            });
            
            goto cleanup;
        }
        
        // Verify the track data.
        if (![_reader verifyData:decryptedTrackData length:decryptedTrackDataLength]) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"The track data contains checksum error. Please swipe the card again!" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
            });
            
            goto cleanup;
        }
        
        // Decode the track data.
        track1Data = [track1Data initWithBytes:decryptedTrackData length:trackData.track1Length];
        track2Data = [track2Data initWithBytes:decryptedTrackData + 79 length:trackData.track2Length];
        
    } else if ([trackData isKindOfClass:[ACRDukptTrackData class]]) {
        
        ACRDukptTrackData *dukptTrackData = (ACRDukptTrackData *) trackData;
        NSUInteger ec = 0;
        NSUInteger ec2 = 0;
        NSData *key = nil;
        NSData *dek = nil;
        NSData *macKey = nil;
        uint8_t dek3des[24];
        
        keySerialNumberString = [AJDHex hexStringFromByteArray:dukptTrackData.keySerialNumber];
        track1MacString = [AJDHex hexStringFromByteArray:dukptTrackData.track1Mac];
        track2MacString = [AJDHex hexStringFromByteArray:dukptTrackData.track2Mac];
        track1MaskedData = [track1MaskedData initWithString:dukptTrackData.track1MaskedData];
        track2MaskedData = [track2MaskedData initWithString:dukptTrackData.track2MaskedData];
        
        // Compare the key serial number.
        if (![ACRDukptReceiver compareKeySerialNumber:_iksn ksn2:dukptTrackData.keySerialNumber]) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"The key serial number does not match with the settings." message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
            });
            
            goto cleanup;
        }
        
        // Get the encryption counter from KSN.
        ec = [ACRDukptReceiver encryptionCounterFromKeySerialNumber:dukptTrackData.keySerialNumber];
        
        // Get the encryption counter from DUKPT receiver.
        ec2 = [_dukptReceiver encryptionCounter];
        
        // Load the initial key if the encryption counter from KSN is less than
        // the encryption counter from DUKPT receiver.
        if (ec < ec2) {
            
            [_dukptReceiver loadInitialKey:_ipek];
            ec2 = [_dukptReceiver encryptionCounter];
        }
        
        // Synchronize the key if the encryption counter from KSN is greater
        // than the encryption counter from DUKPT receiver.
        while (ec > ec2) {
            
            [_dukptReceiver key];
            ec2 = [_dukptReceiver encryptionCounter];
        }
        
        if (ec != ec2) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"The encryption counter is invalid." message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
            });
            
            goto cleanup;
        }
        
        key = [_dukptReceiver key];
        if (key == nil) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"The maximum encryption count had been reached." message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
            });
            
            goto cleanup;
        }
        
        dek = [ACRDukptReceiver dataEncryptionRequestKeyFromKey:key];
        macKey = [ACRDukptReceiver macRequestKeyFromKey:key];
        
        // Generate 3DES key (K1 = K3).
        memcpy(dek3des, [dek bytes], [dek length]);
        memcpy(dek3des + [dek length], [dek bytes], 8);
        
        if (dukptTrackData.track1Data != nil) {
            
            uint8_t track1Buffer[80];
            size_t bytesReturned = 0;
            NSString *track1DataString = nil;
            
            // Decrypt the track 1 data.
            if (![self AJD_tripleDesDecryptData:[dukptTrackData.track1Data bytes] dataInLength:[dukptTrackData.track1Data length] key:dek3des keyLength:sizeof(dek3des) dataOut:track1Buffer dataOutLength:sizeof(track1Buffer) bytesReturned:&bytesReturned]) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"The track 1 data cannot be decrypted. Please swipe the card again!" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [alert show];
                });
                
                goto cleanup;
            }
            
            // Generate the MAC for track 1 data.
            track1MacString = [track1MacString stringByAppendingFormat:@" (%@)", [AJDHex hexStringFromByteArray:[ACRDukptReceiver macFromData:track1Buffer dataLength:sizeof(track1Buffer) key:[macKey bytes] keyLength:[macKey length]]]];
            
            // Get the track 1 data as string.
            track1DataString = [[NSString alloc] initWithBytes:track1Buffer length:dukptTrackData.track1Length encoding:NSASCIIStringEncoding];
            
            // Divide the track 1 data into fields.
            track1Data = [track1Data initWithString:track1DataString];
        }
        
        if (dukptTrackData.track2Data != nil) {
            
            uint8_t track2Buffer[48];
            size_t bytesReturned = 0;
            NSString *track2DataString = nil;
            
            // Decrypt the track 2 data.
            if (![self AJD_tripleDesDecryptData:[dukptTrackData.track2Data bytes] dataInLength:[dukptTrackData.track2Data length] key:dek3des keyLength:sizeof(dek3des) dataOut:track2Buffer dataOutLength:sizeof(track2Buffer) bytesReturned:&bytesReturned]) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"The track 2 data cannot be decrypted. Please swipe the card again!" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [alert show];
                });
                
                goto cleanup;
            }
            
            // Generate the MAC for track 2 data.
            track2MacString = [track2MacString stringByAppendingFormat:@" (%@)", [AJDHex hexStringFromByteArray:[ACRDukptReceiver macFromData:track2Buffer dataLength:sizeof(track2Buffer) key:[macKey bytes] keyLength:[macKey length]]]];
            
            // Get the track 2 data as string.
            track2DataString = [[NSString alloc] initWithBytes:track2Buffer length:dukptTrackData.track2Length encoding:NSASCIIStringEncoding];
            
            // Divide the track 2 data into fields.
            track2Data = [track2Data initWithString:track2DataString];
        }
    }
    
cleanup:
    
    // Show the data.
    dispatch_async(dispatch_get_main_queue(), ^{
        
        _swipeCount++;
        //        self.swipeCountLabel.text = [NSString stringWithFormat:@"%d", _swipeCount];
        //
        //        self.batteryStatusLabel.text = batteryStatusString;
        //        self.keySerialNumberLabel.text = keySerialNumberString;
        //        self.track1MacLabel.text = track1MacString;
        //        self.track2MacLabel.text = track2MacString;
        //
        //        self.track1Jis2DataLabel.text = track1Data.jis2Data;
        //        self.track1PrimaryAccountNumberLabel.text = [NSString stringWithFormat:@"%@\n%@", track1Data.primaryAccountNumber, track1MaskedData.primaryAccountNumber];
        //        self.track1NameLabel.text = [NSString stringWithFormat:@"%@\n%@", track1Data.name, track1MaskedData.name];
        //        self.track1ExpirationDateLabel.text = [NSString stringWithFormat:@"%@\n%@", track1Data.expirationDate, track1MaskedData.expirationDate];
        //        self.track1ServiceCodeLabel.text = [NSString stringWithFormat:@"%@\n%@", track1Data.serviceCode, track1MaskedData.serviceCode];
        //        self.track1DiscretionaryDataLabel.text = [NSString stringWithFormat:@"%@\n%@", track1Data.discretionaryData, track1MaskedData.discretionaryData];
        //
        //        self.track2PrimaryAccountNumberLabel.text = [NSString stringWithFormat:@"%@\n%@", track2Data.primaryAccountNumber, track2MaskedData.primaryAccountNumber];
        //        self.track2ExpirationDateLabel.text = [NSString stringWithFormat:@"%@\n%@", track2Data.expirationDate, track2MaskedData.expirationDate];
        //        self.track2ServiceCodeLabel.text = [NSString stringWithFormat:@"%@\n%@", track2Data.serviceCode, track2MaskedData.serviceCode];
        //        self.track2DiscretionaryDataLabel.text = [NSString stringWithFormat:@"%@\n%@", track2Data.discretionaryData, track2MaskedData.discretionaryData];
        //
        //        [self.tableView reloadData];
    });
}

- (void)reader:(ACRAudioJackReader *)reader didSendRawData:(const uint8_t *)rawData length:(NSUInteger)length {
    
    NSString *hexString = [self toHexString:rawData length:length];
    
    hexString = [hexString stringByAppendingString:[_reader verifyData:rawData length:length] ? @" (Checksum OK)" : @" (Checksum Error)"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //Set hex value to Gloval Variable
        AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate.cardData setObject:hexString forKey:@"hex"];
        
        //Wrtite to Log
        NSString *logEntry = [NSString stringWithFormat:@"Reader sent data:%@",hexString];
        [logEntry writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
        
        
        // NSLog(@"LOG_HEX%@",hexString);
        // TODO: This is where I need to display the hexString into the Card Details/Log Console views.
        // self.dataReceivedLabel.text = hexString;
        // [self.tableView reloadData];
    });
}

- (void)reader:(ACRAudioJackReader *)reader didSendCustomId:(const uint8_t *)customId length:(NSUInteger)length {
    
    [_responseCondition lock];
    _customId = [NSData dataWithBytes:customId length:length];
    _customIdReady = YES;
    [_responseCondition signal];
    [_responseCondition unlock];
}

- (void)reader:(ACRAudioJackReader *)reader didSendDeviceId:(const uint8_t *)deviceId length:(NSUInteger)length {
    
    [_responseCondition lock];
    _deviceId = [NSData dataWithBytes:deviceId length:length];
    _deviceIdReady = YES;
    [_responseCondition signal];
    [_responseCondition unlock];
}

- (void)reader:(ACRAudioJackReader *)reader didSendDukptOption:(BOOL)enabled {
    
    [_responseCondition lock];
    _dukptOption = enabled;
    _dukptOptionReady = YES;
    [_responseCondition signal];
    [_responseCondition unlock];
}

- (void)reader:(ACRAudioJackReader *)reader didSendTrackDataOption:(ACRTrackDataOption)option {
    
    [_responseCondition lock];
    _trackDataOption = option;
    _trackDataOptionReady = YES;
    [_responseCondition signal];
    [_responseCondition unlock];
}

- (void)reader:(ACRAudioJackReader *)reader didSendPiccAtr:(const uint8_t *)atr length:(NSUInteger)length {
    
    [_responseCondition lock];
    _piccAtr = [NSData dataWithBytes:atr length:length];
    _piccAtrReady = YES;
    
    [self transmit:nil];
    
    [_responseCondition signal];
    [_responseCondition unlock];
}

- (void)reader:(ACRAudioJackReader *)reader didSendPiccResponseApdu:(const uint8_t *)responseApdu length:(NSUInteger)length {
    
    [_responseCondition lock];
    _piccResponseApdu = [NSData dataWithBytes:responseApdu length:length];
    
    // Mute AudioJack library
    _reader.mute = YES;
    // Route audio to speakers
    [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
    
    // Construct URL to a scan sound file
    NSString *path = [[NSBundle mainBundle] pathForResource:@"scan_sound" ofType:@"mp3"]; // Android scan sound
    // NSString *path = [[NSBundle mainBundle] pathForResource:@"notification" ofType:@"mp3"];  // Bird chirp sound
    NSURL *soundUrl = [NSURL fileURLWithPath:path];
    
    NSError *error;
    // Create audio player object and initialize with URL to sound a scan
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:&error];
    self.audioPlayer.numberOfLoops = 1; // only play sound once
    
    if (self.audioPlayer == nil)
        NSLog(@"%@",[error description]);
    else
        self.audioPlayer.delegate = self; // assign this player delegate to this class so audioPlayerDidFinishPlaying will be called here
    [self.audioPlayer play]; // play the scan sound
    NSString *UUID = [self toHexString:[_piccResponseApdu bytes] length:[_piccResponseApdu length]];
    
    
    NSLog(@"UUID:%@",UUID);
    
    if ([UUID length] > 0) {
        NSLog(@"UUIS");
        [self performSelectorOnMainThread:@selector(completeTransaction:) withObject:UUID waitUntilDone:NO];
        
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        logView.text = [NSString stringWithFormat:@"%@ \n %@", logView.text,[self toHexString:[_piccResponseApdu bytes] length:[_piccResponseApdu length]-2]]; // log the scan UUID without SW1 and SW2
    });
    
    
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //
    //        if (![previousResponse isEqualToString:[self toHexString:[_piccResponseApdu bytes] length:[_piccResponseApdu length]]]) {
    //            NSLog(@"SDE%@",[self toHexString:[_piccResponseApdu bytes] length:[_piccResponseApdu length]]);
    //        }
    //
    //        previousResponse = [self toHexString:[_piccResponseApdu bytes] length:[_piccResponseApdu length]];
    //
    //    });
    
    
    _piccResponseApduReady = YES;
    [_responseCondition signal];
    [_responseCondition unlock];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)audioPlayer successfully:(BOOL)flag
{
    [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideNone error:nil]; // Route audio back to Headphones
    _reader.mute = NO; // Unmute the AudioJack library
}

- (void)readerDidReset:(ACRAudioJackReader *)reader {
    
}

#pragma mark - Private Methods

/**
 * Converts the battery status to string.
 * @param batteryStatus the battery status.
 * @return the battery status string.
 */
- (NSString *)AJD_stringFromBatteryStatus:(NSUInteger)batteryStatus {
    
    NSString *batteryStatusString = nil;
    
    switch (batteryStatus) {
            
        case ACRBatteryStatusLow:
            batteryStatusString = @"Low";
            break;
            
        case ACRBatteryStatusFull:
            batteryStatusString = @"Full";
            break;
            
        default:
            batteryStatusString = @"Unknown";
            break;
    }
    
    return batteryStatusString;
}

/**
 * Decrypts the data using Triple DES.
 * @param dataIn           the input buffer.
 * @param dataInLength     the input buffer length.
 * @param key              the key.
 * @param keyLength        the key length.
 * @param dataOut          the output buffer.
 * @param dataOutLength    the output buffer length.
 * @param bytesReturnedPtr the pointer to number of bytes returned.
 * @return <code>YES</code> if the operation completed successfully, otherwise
 *         <code>NO</code>.
 */
- (BOOL)AJD_tripleDesDecryptData:(const void *)dataIn dataInLength:(size_t)dataInLength key:(const void *)key keyLength:(size_t)keyLength dataOut:(void *)dataOut dataOutLength:(size_t)dataOutLength bytesReturned:(size_t *)bytesReturnedPtr {
    
    BOOL ret = NO;
    
    // Decrypt the data.
    if (CCCrypt(kCCDecrypt, kCCAlgorithm3DES, 0, key, keyLength, NULL, dataIn, dataInLength, dataOut, dataOutLength, bytesReturnedPtr) == kCCSuccess) {
        ret = YES;
    }
    
    return ret;
}

/**
 * Dismisses the alert view.
 * @param alertView the alert view.
 */
- (void)AJD_dismissAlertView:(UIAlertView *)alertView {
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
}


/**
 * Detect when the audio route has changed manage when Headphone jack is plugged/unplugged so as to never hear the AudioJack tone
 * @param notification the notification registered
 */
-(void)handleRouteChange:(NSNotification*)notification{
    AVAudioSession *session = [AVAudioSession sharedInstance];
    AVAudioSessionPortDescription *input = [[session.currentRoute.inputs count]?session.currentRoute.inputs:nil objectAtIndex:0];
    
    if ([input.portType isEqual: @"MicrophoneBuiltIn"]) {
        // TODO: need to mute AudioJack library
    } else if ([input.portType isEqual: @"MicrophoneWired"]) {
        // TODO: need to unmute AudioJack library
    }
}

@end
