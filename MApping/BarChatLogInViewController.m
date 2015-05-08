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
    UIImageView *loginBackground = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"BarCoupLogo"]];
    self.logInView.logo = loginBackground;
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundImage"]];
    self.view.contentMode = UIViewContentModeScaleAspectFill;
 }
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
