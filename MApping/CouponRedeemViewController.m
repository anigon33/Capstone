//
//  CouponRedeemViewController.m
//  MApping
//
//  Created by Nigon's on 4/10/15.
//  Copyright (c) 2015 Adam Nigon. All rights reserved.
//

#import "CouponRedeemViewController.h"

@interface CouponRedeemViewController ()
@property (strong, nonatomic) IBOutlet UILongPressGestureRecognizer *longPressGesture;
@property (weak, nonatomic) IBOutlet UIImageView *IndiviualCouponImage;
@property (weak, nonatomic) IBOutlet UIImageView *PromoCodeImage;

@end

@implementation CouponRedeemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.longPressGesture.minimumPressDuration = .5;
    self.longPressGesture.numberOfTouchesRequired = 1;
    [self.IndiviualCouponImage addGestureRecognizer:self.longPressGesture];
    self.PromoCodeImage.hidden = YES;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)CouponPressed:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan){
        NSLog(@"UIGestureRecognizerStateBegan.");
        //Do Whatever You want on Began of Gesture
        self.PromoCodeImage.hidden = NO;
        self.PromoCodeImage.alpha = 1.0f;
        // Then fades it away after 2 seconds (the cross-fade animation will take 0.5s)
        [UIView animateWithDuration:0.5 delay:4.0 options:0 animations:^{
            // Animate the alpha value of your imageView from 1.0 to 0.0 here
            self.PromoCodeImage.alpha = 0.0f;
        } completion:^(BOOL finished) {
            // Once the animation is completed and the alpha has gone to 0.0, hide the view for good
            self.PromoCodeImage.hidden = YES;
            
        }];
    }else if (sender.state == UIGestureRecognizerStateEnded){
        
        [self performSegueWithIdentifier:@"backToCouponHome" sender:self];

    }
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
