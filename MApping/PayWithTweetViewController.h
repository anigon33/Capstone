//
//  PayWithTweetViewController.h
//  MApping
//
//  Created by Nigon's on 5/31/15.
//  Copyright (c) 2015 Adam Nigon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface PayWithTweetViewController : UIViewController
@property (nonatomic, strong) NSString *establishmentId;
@property (nonatomic, strong)PFObject *couponObject;

@property BOOL success;
@end
