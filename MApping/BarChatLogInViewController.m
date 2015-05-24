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
    
    [self.logInView setLogo:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo"]]];
    [self.logInView.signUpButton setBackgroundImage:[UIImage imageNamed:@"SignUpandLogIn"] forState:UIControlStateNormal];
    
    [self.logInView.logInButton setBackgroundImage:[UIImage imageNamed:@"SignUpandLogIn"] forState:UIControlStateNormal];
    [self.logInView addSubview:imgView];
    [self.logInView sendSubviewToBack:imgView];
 }
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.logInView.logo setFrame:CGRectMake(55, 30, 240, 150)];
    [self.logInView.usernameField setFrame:CGRectMake(20, 210, 280, 40)];
    [self.logInView.passwordField setFrame:CGRectMake(20, 255, 280, 40)];
    [self.logInView.logInButton setFrame:CGRectMake(20, 305, 280, 50)];
    [self.logInView.passwordForgottenButton setFrame:CGRectMake(60, 370, 200, 15)];
    [self.logInView.signUpButton setFrame:CGRectMake(20, 425, 280, 40)];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
