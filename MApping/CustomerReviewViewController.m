//
//  CustomerReviewViewController.m
//  MApping
//
//  Created by Nigon's on 4/10/15.
//  Copyright (c) 2015 Adam Nigon. All rights reserved.
//

#import "CustomerReviewViewController.h"
#import <Parse/Parse.h>
@interface CustomerReviewViewController ()
@property (weak, nonatomic) IBOutlet UILabel *questionCouterLabel;
@property (weak, nonatomic) IBOutlet UILabel *reviewQuestionsLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (nonatomic, strong) PFObject *couponReviewSurvey;

@end

@implementation CustomerReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (IBAction)backPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
    
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
