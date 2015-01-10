//
//  LoginViewController.m
//  bitflo
//
//  Created by Boris  on 1/10/15.
//  Copyright (c) 2015 LLT. All rights reserved.
//


#import "LoginViewController.h"
#import "ViewController.h"



@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize userNameTextField, passwordTextField;


- (void)viewWillAppear:(BOOL)animated {
    
    if ([PFUser currentUser]) {
        [self nextView];
    }
    
}

- (IBAction)login:(id)sender {
    
    [PFUser logInWithUsernameInBackground:userNameTextField.text password:passwordTextField.text
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            [self nextView];
                                        } else {
                                            NSLog(@"Error:%@",error);
                                            // The login failed. Check error to see why.
                                        }
                                    }];
}

- (void)nextView {

    NSString *type = [[PFUser currentUser] objectForKey:@"type"];
    
    if ([type isEqualToString:@"M"]) {
        ViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"main_merchant"];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        ViewController *cvc = [self.storyboard instantiateViewControllerWithIdentifier:@"main_customer"];
        [self.navigationController pushViewController:cvc animated:YES];
    }
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
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

@end
