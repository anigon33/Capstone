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
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"login"]];
    UIImageView *tellEm = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lettersBest"]];
    self.signUpView.logo = tellEm;
    
    self.signUpView.passwordField.textColor = [UIColor blackColor];

    // Do any additional setup after loading the view.
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.signUpView.logo setFrame:CGRectMake(30, 20, 260, 160)];
    
}
//- (void) myMethod {
//    PFUser *user = [PFUser user];
//    user.username = @"my name";
//    user.password = @"my pass";
//    user.email = @"email@example.com";
//    
//    // other fields can be set just like with PFObject
//
//    
//    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        if (!error) {
//            // Hooray! Let them use the app now.
//            
//            AdditionalSurveyQuestionsViewController *additionalVC = [[AdditionalSurveyQuestionsViewController alloc] init];
//            [self presentViewController:additionalVC animated:YES completion:nil];
//            
//            
//        } else {
//            NSString *errorString = [error userInfo][@"error"];
//            // Show the errorString somewhere and let the user try again.
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"error"
//                                                                message:errorString
//                                                               delegate:self
//                                                      cancelButtonTitle:@"Cancel"
//                                                      otherButtonTitles:@"Settings", nil];
//            
//            [alertView show];
//        }
//    }];
//}

    
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
