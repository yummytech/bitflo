//
//  ViewController.m
//  bitflo
//
//  Created by Boris  on 1/10/15.
//  Copyright (c) 2015 LLT. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "SalesViewController.h"
#import "ContactlessViewController.h"
#import "ATMViewController.h"
#import "ConfigurationsViewController.h"

#define FLOBLE_UUID @"6e400001-b5a3-f393-e0a9-e50e24dcca9e"

@interface ViewController ()

@end

@implementation ViewController

@synthesize chargeButton, itemCountLabel, lowerAmountLabel, noteButton, total, previous, salesArray;
@synthesize itemsCountButton, testTextfield;

- (IBAction)goToConfigurations:(id)sender {
    
    ConfigurationsViewController *cvc = [self.storyboard instantiateViewControllerWithIdentifier:@"conf"];
    [self.navigationController pushViewController:cvc animated:YES];
    
}

- (IBAction)goToATM:(id)sender {
    
    ATMViewController *avc = [self.storyboard instantiateViewControllerWithIdentifier:@"atm"];
    [self.navigationController pushViewController:avc animated:YES];
}

-(IBAction)openSales:(id)sender {
    
    SalesViewController *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"sales"];
    svc.salesArray = salesArray;
    
    svc.delegate = self;
    
    svc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:svc animated:YES completion:nil];
    
    svc.totalLabel.text = [NSString stringWithFormat:@"Total $%.2f",[previous floatValue]];
    
}

-(IBAction)addNote:(id)sender {
    
    AddNoteViewController *anvc = [self.storyboard instantiateViewControllerWithIdentifier:@"addNote"];
    anvc.delegate = self;
    
    anvc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:anvc animated:YES completion:nil];
    
    if (![noteButton.titleLabel.text isEqualToString:@"Note"]) {
        anvc.textView.text = noteButton.titleLabel.text;
    }
    
}

- (float)labelNumericalValue {
    
    NSString *textOfNumber = [chargeButton.titleLabel.text substringFromIndex:8];
    return [textOfNumber floatValue];
    
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
        
        total = [NSNumber numberWithFloat:[previous floatValue] + [currentInputText floatValue]];
        
        
        [chargeButton setTitle:[NSString stringWithFormat:@"Charge $%.2f",[total floatValue]] forState:UIControlStateNormal];
        lowerAmountLabel.text = [NSString stringWithFormat:@"$%.2f", [currentInputText floatValue]];
        
    } else if (typedNumber == 11) {
        
        currentInputText = @"0";
        currentInput = 0;
        lowerAmountLabel.text = [NSString stringWithFormat:@"$0.00"];
        [chargeButton setTitle:[NSString stringWithFormat:@"Charge $%.2f",[previous floatValue]] forState:UIControlStateNormal];
        
        
    } else if (typedNumber == 12) {
        
        NSLog(@"que ladilla");
        
        previous = [NSNumber numberWithFloat:[self labelNumericalValue]];
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.currentAmount = [NSString stringWithFormat:@"%.2f",[total floatValue]];
        
        NSMutableDictionary *sale = [[NSMutableDictionary alloc] init];
        [sale setObject:[NSNumber numberWithFloat:currentInput] forKey:@"amount"];
        [sale setObject:@"Custom Amount" forKey:@"description"];
        if (![noteButton.titleLabel.text isEqualToString:@"Note"]) {
            [sale setObject:noteButton.titleLabel.text forKey:@"note"];
        }
        [salesArray addObject:sale];
        
        if (itemsCountButton.alpha == 0.0) {
            [UIView beginAnimations:@"fade" context:nil];
            [UIView setAnimationDuration:0.25];
            itemsCountButton.alpha = 1;
            itemCountLabel.alpha = 1;
            [UIView commitAnimations];
        }
        
        currentInputText = @"0";
        currentInput = 0;
        lowerAmountLabel.text = @"$0.00 ";
        itemCountLabel.text = [NSString stringWithFormat:@"%li",[itemCountLabel.text integerValue] + 1 ];
        [noteButton setTitle:@"Note" forState:UIControlStateNormal];
        
        appDelegate.salesArray = salesArray;
    }
    
    
    
}

- (IBAction)pay:(id)sender {
    
    ContactlessViewController *cvc = [self.storyboard instantiateViewControllerWithIdentifier:@"payment"];
    //cvc.amount = appDelegate.currentAmount;
    cvc.salesArray = salesArray;
    cvc.previous = previous;
    [self.navigationController pushViewController:cvc animated:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [chargeButton setTitle:@"LOCO" forState:UIControlStateNormal];
    currentInput = 0;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    salesArray = appDelegate.salesArray;
    
}

- (void) viewWillAppear:(BOOL)animated {

    [testTextfield becomeFirstResponder];
    
    previous = [NSNumber numberWithFloat:0];
    
    float p = [previous floatValue];
    
    for (NSMutableDictionary *dictionary in salesArray) {
        p += [[dictionary objectForKey:@"amount"] floatValue];
    }
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    newPayment = [appDelegate.isNewPayment boolValue];

    appDelegate.currentAmount = [NSString stringWithFormat:@"%.2f",p/100.0];
    
    previous = [NSNumber numberWithFloat:p/100.0];
    
    if (newPayment) {
        lowerAmountLabel.text = @"$0.00";
        [chargeButton setTitle:@"Charge $0.00" forState:UIControlStateNormal];
        total = [NSNumber numberWithFloat:0.00];
        previous = [NSNumber numberWithFloat:0.00];
        appDelegate.isNewPayment = [NSNumber numberWithBool:NO];
        appDelegate.salesArray = [[NSMutableArray alloc] init];
        salesArray = [[NSMutableArray alloc] init];
    } else {
        [chargeButton setTitle:[NSString stringWithFormat:@"Charge $%.2f",[previous floatValue]] forState:UIControlStateNormal];
    }

    if ([salesArray count] > 0) {
        [itemCountLabel setText:[NSString stringWithFormat:@"%lu",(unsigned long)[salesArray count]]];
    } else {
        [itemCountLabel setText:@"0"];
        [chargeButton setTitle:@"Charge $0.00" forState:UIControlStateNormal];
    }
    
    
    if ([itemCountLabel.text isEqualToString:@"0"]) {
        [UIView beginAnimations:@"fade" context:nil];
        [UIView setAnimationDuration:0.25];
        itemsCountButton.alpha = 0.0;
        itemCountLabel.alpha = 0.0;
        [UIView commitAnimations];
    }
    
    
    
}

- (void) viewWillDisappear:(BOOL)animated {
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.currentNumberOfItems = itemCountLabel.text;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didReceiveTokenValue:(NSString *)value {
    
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Token"
                                                     message:value
                                                    delegate:self
                                           cancelButtonTitle:@"Cancel"
                                           otherButtonTitles: nil];
    [alert addButtonWithTitle:@"OK"];
    [alert show];
}

#pragma mark - delegates

- (void)sendNewItems:(NSMutableArray *)value {
    
    salesArray = value;
    //[salesArray addObjectsFromArray:value];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    appDelegate.salesArray = salesArray;
    
    
}

- (void)dismiss:(UIViewController *)viewController withNote:(NSString *)string {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [noteButton setTitle:string forState:UIControlStateNormal];
}

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
