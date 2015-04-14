//
//  CouponViewController.h
//  MApping
//
//  Created by Nigon's on 4/9/15.
//  Copyright (c) 2015 Adam Nigon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import <Parse/Parse.h>
@interface CouponViewController : UIViewController <iCarouselDataSource, iCarouselDelegate>
@property (nonatomic, strong) PFObject *establishmentObject;

@end
