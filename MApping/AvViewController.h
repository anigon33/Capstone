//
//  AvViewController.h
//  MApping
//
//  Created by Nigon's on 5/25/15.
//  Copyright (c) 2015 Adam Nigon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>
#import <Parse/Parse.h>

@interface AvViewController : AVPlayerViewController
@property (nonatomic, strong) PFObject *couponObject;
@end
