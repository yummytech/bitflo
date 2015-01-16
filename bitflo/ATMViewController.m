//
//  ATMViewController.m
//  bitflo
//
//  Created by Boris  on 1/10/15.
//  Copyright (c) 2015 LLT. All rights reserved.
//

#import "ContactlessViewController.h"
#import "ThanksViewController.h"
#import "AppDelegate.h"
#import "ATMViewController.h"
#import "ConfigurationsViewController.h"
#import "ViewController.h"

#define FLOMIO_ACCOUNT @"5492cb448d10dc6b8b00009d"

@interface ATMViewController ()

@end

@implementation ATMViewController

@synthesize amountTextField;
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
        deleteButton.frame = CGRectMake(deleteButton.frame.origin.x - (self.view.frame.size.width * 1.5), deleteButton.frame.origin.y, deleteButton.frame.size.width, deleteButton.frame.size.height);
        
        enterPasscodeLabel.frame = CGRectMake(enterPasscodeLabel.frame.origin.x - (self.view.frame.size.width * 1.5), enterPasscodeLabel.frame.origin.y, enterPasscodeLabel.frame.size.width, deleteButton.frame.size.height);
        
        firstNumber.frame = CGRectMake(firstNumber.frame.origin.x - (self.view.frame.size.width * 1.5), firstNumber.frame.origin.y, firstNumber.frame.size.width, firstNumber.frame.size.height);
        secondNumber.frame = CGRectMake(secondNumber.frame.origin.x - (self.view.frame.size.width * 1.5), secondNumber.frame.origin.y, secondNumber.frame.size.width, secondNumber.frame.size.height);
        thirdNumber.frame = CGRectMake(thirdNumber.frame.origin.x - (self.view.frame.size.width * 1.5), thirdNumber.frame.origin.y, thirdNumber.frame.size.width, thirdNumber.frame.size.height);
        fourthNumber.frame = CGRectMake(fourthNumber.frame.origin.x - (self.view.frame.size.width * 1.5), fourthNumber.frame.origin.y, fourthNumber.frame.size.width, fourthNumber.frame.size.height);
        
        
    }completion:^(BOOL finished){
        
        
        [PFCloud callFunctionInBackground:@"transfer"
                           withParameters:@{@"from": FLOMIO_ACCOUNT, @"to": currentAccount, @"amount": @"0.0001"}
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
        
    } else if (typedNumber == 12) {
        
        if ([amountTextField.text length] > 1) {
            amountTextField.text = [amountTextField.text substringToIndex:[amountTextField.text length] - 1];
        } else {
            currentInputText = @"0";
            currentInput = 0;
            amountTextField.text = [NSString stringWithFormat:@"$0.00"];
        }
    }

}

- (void)completeTransaction:(NSString *)UUID {
    
    
    [self blur];
    
    //AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //float amount = [appDelegate.currentAmount floatValue];
    
    NSLog(@"UUID:%@",[UUID stringByReplacingOccurrencesOfString:@" " withString:@""]);
    
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
                
            } else {
                currentAccount = [[objects objectAtIndex:0] objectForKey:@"account"];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
}

- (void) receiveNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"UUIDNotification"])
        NSLog (@"Successfully received the UUID");
}

@end
