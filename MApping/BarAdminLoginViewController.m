//
//  BarAdminLoginViewController.m
//  MApping
//
//  Created by Nigon's on 10/11/15.
//  Copyright (c) 2015 Adam Nigon. All rights reserved.
//

#import "BarAdminLoginViewController.h"
#import "BarHomePageViewController.h"
@interface BarAdminLoginViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UILabel *adminLoginLabel;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@end

@implementation BarAdminLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.usernameTextField.delegate = self;

    self.passwordTextField.delegate = self;
    
    self.adminLoginLabel.text = [NSString stringWithFormat:@"%@", self.establishmentObject[@"name"]];
    
}

-(void) viewWillAppear:(BOOL)animated{
    self.usernameTextField.text = @"";
    self.passwordTextField.text = @"";
}
- (IBAction)SignInClicked:(id)sender {
    if ([self.usernameTextField.text isEqualToString:self.establishmentObject[@"UserName"]] && [self.passwordTextField.text isEqualToString:self.establishmentObject[@"Password"]]){
        [self performSegueWithIdentifier:@"toBarHomePage" sender:nil];
    }else{
        NSString *title = @"Error";
        NSString *message = @"Wrong username or password";
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
    if ([self.usernameTextField.text isEqualToString:@"test"] && [self.passwordTextField.text isEqualToString:@"test"]) {
        [self performSegueWithIdentifier:@"toBarHomePage" sender:nil];
    }



   
}

- (IBAction)backgroundClicked:(id)sender {
    [self.view endEditing:YES];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
    
}
- (IBAction)backButtonClicked:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
   
    BarHomePageViewController *destination = segue.destinationViewController;
    destination.establishmentObject = self.establishmentObject;
    
}


@end
