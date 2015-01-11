//
//  ConfigurationsViewController.m
//  bitflo
//
//  Created by Boris  on 1/11/15.
//  Copyright (c) 2015 LLT. All rights reserved.
//

#import "ConfigurationsViewController.h"
#import "ATMViewController.h"
#import "ViewController.h"
#import "AppDelegate.h"

@interface ConfigurationsViewController ()

@end

@implementation ConfigurationsViewController

@synthesize accountTextField;

- (IBAction)goToMain:(id)sender {
    
    ViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"main_merchant"];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)goToATM:(id)sender {
    
    ATMViewController *avc = [self.storyboard instantiateViewControllerWithIdentifier:@"atm"];
    [self.navigationController pushViewController:avc animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    
    accountTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"account"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldDidEndEditing:(UITextField *)textField {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:accountTextField.text
                     forKey:@"account"];
    [userDefaults synchronize];
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // Any additional checks to ensure you have the correct textField here.
    [textField resignFirstResponder];
    
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
