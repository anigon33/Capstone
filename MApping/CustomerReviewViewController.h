//
//  ReviewViewController.h
//  MApping
//
//  Created by Nigon's on 9/17/15.
//  Copyright (c) 2015 Adam Nigon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface CustomerReviewViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong)NSString *establishmentId;

@property BOOL presentedModally;

@end
