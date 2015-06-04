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
@property (nonatomic, strong)PFObject *couponObject;
@property (weak, nonatomic) IBOutlet UIButton *payWithTweetButton;

@property (nonatomic, strong) NSString *establishmentId;
@end
