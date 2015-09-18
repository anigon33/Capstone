//
//  BarChatSignUpViewController.m
//  MApping
//
//  Created by Nigon's on 3/24/15.
//  Copyright (c) 2015 Adam Nigon. All rights reserved.
//

#import "BarChatSignUpViewController.h"
#import "AdditionalSurveyQuestionsViewController.h"
#import <Parse/Parse.h>
@interface BarChatSignUpViewController ()<PFSignUpViewControllerDelegate, PFLogInViewControllerDelegate>

@end

@implementation BarChatSignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    imgView.image = [UIImage imageNamed:@"blackBackground"];
   
    self.signUpView.backgroundColor =[UIColor clearColor];
    
    self.signUpView.emailAsUsername = true;

    [self.signUpView setLogo:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo"]]];
    [self.signUpView.signUpButton setBackgroundImage:[UIImage imageNamed:@"SignUpandLogIn"] forState:UIControlStateNormal];
    self.signUpView.usernameField.placeholder = @"Email Address";    
    [self.signUpView addSubview:imgView];
    [self.signUpView sendSubviewToBack:imgView];

   }
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
//    [self.signUpView.dismissButton setFrame:CGRectMake(5, 15, 50, 50)];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    
    if (screenWidth == 320) {
        [self.signUpView.logo setFrame:CGRectMake(55, 50, 240, 150)];
        [self.signUpView.emailField setFrame:CGRectMake(20, 205, 280, 40)];
        [self.signUpView.usernameField setFrame:CGRectMake(20, 250, 280, 40)];
        [self.signUpView.passwordField setFrame:CGRectMake(20, 295, 280, 40)];
        [self.signUpView.signUpButton setFrame:CGRectMake(20, 375, 280, 40)];
    }
    if (screenWidth == 375) {
        [self.signUpView.logo setFrame:CGRectMake(80, 65, 240, 150)];
        //[self.signUpView.emailField setFrame:CGRectMake(45, 235, 285, 50)];
        [self.signUpView.usernameField setFrame:CGRectMake(45, 285, 285, 50)];
        [self.signUpView.passwordField setFrame:CGRectMake(45, 340, 285, 50)];
        [self.signUpView.signUpButton setFrame:CGRectMake(45, 410, 285, 50)];
    }
    
    if (screenWidth == 414) {
        [self.signUpView.logo setFrame:CGRectMake(100, 70, 240, 150)];
        [self.signUpView.emailField setFrame:CGRectMake(50, 225, 320, 50)];
        [self.signUpView.usernameField setFrame:CGRectMake(50, 280, 320, 50)];
        [self.signUpView.passwordField setFrame:CGRectMake(50, 335, 320, 50)];
        [self.signUpView.signUpButton setFrame:CGRectMake(50, 395, 320, 50)];
    }
}

@end
