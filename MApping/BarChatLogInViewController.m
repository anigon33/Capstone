//
//  BarChatLogInViewController.m
//  MApping
//
//  Created by Nigon's on 3/24/15.
//  Copyright (c) 2015 Adam Nigon. All rights reserved.
//

#import "BarChatLogInViewController.h"

@interface BarChatLogInViewController ()<PFLogInViewControllerDelegate>

@end

@implementation BarChatLogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"login"]];
    UIImageView *tellEm = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lettersBest"]];
    self.logInView.logo = tellEm;
  
    // Do any additional setup after loading the view.
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    

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

@end
