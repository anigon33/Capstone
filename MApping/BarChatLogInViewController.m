//
//  BarChatLogInViewController.m
//  MApping
//
//  Created by Nigon's on 3/24/15.
//  Copyright (c) 2015 Adam Nigon. All rights reserved.
//

#import "BarChatLogInViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface BarChatLogInViewController ()<PFLogInViewControllerDelegate>

@end

@implementation BarChatLogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    imgView.image = [UIImage imageNamed:@"blackBackground"];
    self.logInView.backgroundColor =[UIColor clearColor];
    self.logInView.emailAsUsername = true;
    [self.logInView.logInButton setTitle:@"Log In" forState:UIControlStateNormal];
    [self.logInView setLogo:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo"]]];
    
    //[self.logInView.signUpButton setBackgroundImage:[UIImage imageNamed:@"SignUpTextRight"] forState:UIControlStateNormal];
    [self.logInView.logInButton setBackgroundImage:[UIImage imageNamed:@"SignUpandLogIn"] forState:UIControlStateNormal];
    self.logInView.signUpButton.clipsToBounds = YES;
    [self.logInView addSubview:imgView];
    [self.logInView sendSubviewToBack:imgView];
 }
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    
    if (screenWidth == 320) {
        [self.logInView.logo setFrame:CGRectMake(55, 30, 240, 150)];
        [self.logInView.usernameField setFrame:CGRectMake(20, 210, 280, 40)];
        [self.logInView.passwordField setFrame:CGRectMake(20, 255, 280, 40)];
        [self.logInView.logInButton setFrame:CGRectMake(20, 305, 280, 50)];
        [self.logInView.passwordForgottenButton setFrame:CGRectMake(60, 370, 200, 15)];
        [self.logInView.signUpButton setFrame:CGRectMake(20, 425, 280, 40)];
    }
    if (screenWidth == 375){
        [self.logInView.logo setFrame:CGRectMake(70, 30, 240, 150)];
        [self.logInView.usernameField setFrame:CGRectMake(45, 210, 280, 40)];
        [self.logInView.passwordField setFrame:CGRectMake(45, 255, 280, 40)];
        [self.logInView.logInButton setFrame:CGRectMake(45, 305, 280, 50)];
        [self.logInView.passwordForgottenButton setFrame:CGRectMake(85, 370, 200, 15)];
        [self.logInView.signUpButton setFrame:CGRectMake(45, 425, 280, 40)];

    }
    if (screenWidth == 414){
        [self.logInView.logo setFrame:CGRectMake(95, 40, 240, 150)];
        [self.logInView.usernameField setFrame:CGRectMake(65, 210, 280, 40)];
        [self.logInView.passwordField setFrame:CGRectMake(65, 255, 280, 40)];
        [self.logInView.logInButton setFrame:CGRectMake(65, 305, 280, 50)];
        [self.logInView.passwordForgottenButton setFrame:CGRectMake(105, 370, 200, 15)];
        [self.logInView.signUpButton setFrame:CGRectMake(65, 425, 280, 40)];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
