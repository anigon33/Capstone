//
//  DetailsViewController.h
//  MApping
//
//  Created by Nigon's on 3/18/15.
//  Copyright (c) 2015 Adam Nigon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
@interface DetailsViewController : UIViewController <UIGestureRecognizerDelegate, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

@property PFObject *establishmentObject;

@end
