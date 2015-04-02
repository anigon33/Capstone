//
//  AdditionalQuestionsViewController.m
//  MApping
//
//  Created by Nigon's on 3/26/15.
//  Copyright (c) 2015 Adam Nigon. All rights reserved.
//

#import "AdditionalQuestionsViewController.h"

@interface AdditionalQuestionsViewController ()

@end

@implementation AdditionalQuestionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void) viewDidAppear:(BOOL)animated{
    NSString *message = @"Almost done! In order to keep bringing you the best deals around, we need to know a few more things about you!";
    NSString *title = @"WELCOME!";
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Settings", nil];
    [alertView show];
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
