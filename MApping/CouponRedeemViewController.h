//
//  CouponRedeemViewController.h
//  MApping
//
//  Created by Nigon's on 4/10/15.
//  Copyright (c) 2015 Adam Nigon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <Social/Social.h>

@interface CouponRedeemViewController : UIViewController
@property (nonatomic, strong)PFObject *establishmentObject;
@property (weak, nonatomic) IBOutlet UIButton *payWithTweetButton;

- (IBAction)twitterPost:(id)sender;

@end
