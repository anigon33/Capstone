//
//  CouponRedeemViewController.m
//  MApping
//
//  Created by Nigon's on 4/10/15.
//  Copyright (c) 2015 Adam Nigon. All rights reserved.
//

#import "CouponRedeemViewController.h"
#import <ParseUI/ParseUI.h>
#import "PayWithTweetViewController.h"
#import "AvViewController.h"
@interface CouponRedeemViewController ()<UIGestureRecognizerDelegate>
@property BOOL locked;

@property (strong, nonatomic) IBOutlet UILongPressGestureRecognizer *longPressGesture;

@property (weak, nonatomic) IBOutlet UILabel *promoLabelText;

@property (weak, nonatomic) IBOutlet UIImageView *IndividualCouponImage;


@end

@implementation CouponRedeemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.longPressGesture.allowableMovement = 50;
    self.longPressGesture.delegate = self;
    
    self.payWithTweetButton.hidden = YES;
    
    self.IndividualCouponImage.clipsToBounds = YES;
    self.IndividualCouponImage.layer.cornerRadius = 5;
    
    
    if ([[self.couponObject valueForKey:@"payWithTweet"] integerValue] ==1) {
        self.payWithTweetButton.hidden = NO;
        
    }
    
    
    [self.tabBarController.tabBar setHidden:YES];
    
    self.promoLabelText.text = [self.couponObject valueForKey:@"promoCode"];
    
    PFFile *userImageFile = self.couponObject[@"Coupon"];
    [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            self.IndividualCouponImage.image = [UIImage imageWithData:imageData];
            
            
            self.promoLabelText.hidden = YES;
            
            
            [self.IndividualCouponImage addGestureRecognizer:self.longPressGesture];
        }
    }];
    
    NSLog(@"yo");
    
}
-(void)viewWillAppear:(BOOL)animated{
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    if ([[self.couponObject valueForKey:@"payWithTweet"] integerValue] == 1) {
        self.locked = YES;
    }
}

- (IBAction)CouponPressed:(UILongPressGestureRecognizer *)sender {
    // check if locked if (!locked){
    if (!self.locked) {
        
        if (sender.state == UIGestureRecognizerStateBegan){
            NSLog(@"UIGestureRecognizerStateBegan.");
            self.promoLabelText.hidden = NO;
            
            
        }else if (sender.state == UIGestureRecognizerStateEnded){
            
            self.promoLabelText.hidden = YES;
            
            PFObject *couponUsed = [PFObject objectWithClassName:@"CouponUsed"];
            [couponUsed setObject:[PFUser currentUser] forKey:@"user"];
            [couponUsed setObject:[NSDate date] forKey:@"dateUsed"];
            [couponUsed setObject:self.couponObject forKey:@"coupon"];
            [couponUsed save]; // make synchronous first until system works, then go back and make async
            
            // find 12 hours ago from this moment - Use NSDate datewithtimeintervalsincenow (60 * 60 *12 )
            NSDate *timeSinceFirstDrink = [NSDate dateWithTimeIntervalSinceNow:(60 * 60 * 12)];
            
            // query for usedCupons by user (same query as carosel VC) BUT add constraint where 'createdAt' is less than 12 hours ago
            PFQuery *couponsUsed = [PFQuery queryWithClassName:@"CouponUsed"];
            [couponsUsed whereKey:@"user" equalTo:[PFUser currentUser]];
            [couponsUsed includeKey:@"coupon"];
            
            // [couponsUsed whereKey:@"createdAt" greaterThan:timeSinceFirstDrink];
            NSArray *usedCoupons = [couponsUsed findObjects];
            int count = 0;
            for (NSDictionary *coupon in usedCoupons) {
                if ([[[coupon valueForKey:@"coupon"] valueForKey:@"isLiquorCoupon"] integerValue] ==1 &&
                    [[coupon valueForKey:@"createdAt"] compare:timeSinceFirstDrink] == NSOrderedAscending) {
                    count++;
                }
            }
            if (count == 4){
                NSDate *timeTillNextDrink = [NSDate dateWithTimeInterval:(60 * 60 * 12) sinceDate:[NSDate date]];
                [[PFUser currentUser] setObject:[NSNumber numberWithBool:YES] forKey:@"isCutOff"];
                [[PFUser currentUser] setObject:timeTillNextDrink forKey:@"willResumeLiquor"];
                [[PFUser currentUser] save];
            }
            
            if ([[self.couponObject objectForKey:@"afterRedeemScreen"] isEqualToNumber: [NSNumber numberWithInt:1]]){
                
                [self performSegueWithIdentifier:@"toCustomerReview" sender:self];
                
            }else if ([[self.couponObject objectForKey:@"afterRedeemScreen"] isEqualToNumber: [NSNumber numberWithInt:2]]){
                
                [self.navigationController popViewControllerAnimated:NO];
                
            }else if ([[self.couponObject objectForKey:@"afterRedeemScreen"] isEqualToNumber: [NSNumber numberWithInt:3]]){
                
                [self performSegueWithIdentifier:@"toAvPlayer" sender:self];
            }
            
        }
    }
}
- (IBAction)backButtonPressed:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:NO];
    
    
}
- (IBAction)payWithTweetPressed:(UIButton *)sender {
    [self performSegueWithIdentifier:@"toPayWithTweet" sender:self];
}
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toCustomerReview"]) {
        NSLog(@"go to Customer Review Screen");
    }else if ([segue.identifier isEqualToString:@"toPayWithTweet"]){
        PayWithTweetViewController *destination = segue.destinationViewController;
        destination.establishmentId = self.establishmentId;
    }else if ([segue.identifier isEqualToString:@"toAvPlayer"]){
        AvViewController *av = segue.destinationViewController;
        av.couponObject = self.couponObject;
    }
}
- (IBAction)unwindToFromPayWithTweetViewController:(UIStoryboardSegue *)unwindSegue
{
    PayWithTweetViewController *source = unwindSegue.sourceViewController;
    if (source.success) {
        // set locked to NO
        self.locked = NO;
    }
    
}
@end
