//
//  CouponRedeemViewController.m
//  MApping
//
//  Created by Nigon's on 4/10/15.
//  Copyright (c) 2015 Adam Nigon. All rights reserved.
//

#import "CouponRedeemViewController.h"
#import <ParseUI/ParseUI.h>
@interface CouponRedeemViewController ()
@property (strong, nonatomic) IBOutlet UILongPressGestureRecognizer *longPressGesture;

@property (weak, nonatomic) IBOutlet UILabel *promoLabelText;

@property (weak, nonatomic) IBOutlet UIImageView *IndividualCouponImage;

@end

@implementation CouponRedeemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.longPressGesture.minimumPressDuration = .5;
    self.longPressGesture.numberOfTouchesRequired = 1;
    
    self.promoLabelText.text = [self.establishmentObject valueForKey:@"promoCode"];
    
    PFFile *userImageFile = self.establishmentObject[@"Coupon"];
    [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            self.IndividualCouponImage.image = [UIImage imageWithData:imageData];
            self.IndividualCouponImage.contentMode = UIViewContentModeScaleAspectFill;
            
            self.promoLabelText.hidden = YES;

            [self.IndividualCouponImage addGestureRecognizer:self.longPressGesture];
            [self.IndividualCouponImage addSubview:self.promoLabelText];

        }
    }];
        
//    self.IndividualCouponImage.file = [self.establishmentObject valueForKey:@"Coupon"];
//    [self.IndividualCouponImage loadInBackground];
   
    // Do any additional setup after loading the view.
}


- (IBAction)CouponPressed:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan){
        NSLog(@"UIGestureRecognizerStateBegan.");
        //Do Whatever You want on Began of Gesture
        self.promoLabelText.hidden = NO;
        self.promoLabelText.alpha = 1.0f;
        // Then fades it away after 2 seconds (the cross-fade animation will take 0.5s)
        [UIView animateWithDuration:0.5 delay:4.0 options:UIViewAnimationOptionShowHideTransitionViews animations:^{
            // Animate the alpha value of your imageView from 1.0 to 0.0 here
            self.promoLabelText.alpha = 0.0f;
        } completion:^(BOOL finished) {
            // Once the animation is completed and the alpha has gone to 0.0, hide the view for good
            self.promoLabelText.hidden = YES;
        
        }];
    }else if (sender.state == UIGestureRecognizerStateEnded){
        [self performSegueWithIdentifier:@"toCustomerReview" sender:self];
    }
}
- (IBAction)backButtonPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
