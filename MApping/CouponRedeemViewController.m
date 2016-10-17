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
#import "CustomerReviewViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

@interface CouponRedeemViewController ()<UIGestureRecognizerDelegate>
@property BOOL locked;
@property (weak, nonatomic) IBOutlet UIView *lockedView;
@property (weak, nonatomic) IBOutlet UIView *LikeContainerView;

@property (strong, nonatomic) IBOutlet UILongPressGestureRecognizer *longPressGesture;
@property (weak, nonatomic) IBOutlet UIImageView *lockedCoupon;

@property (weak, nonatomic) IBOutlet UIView *promoCodeView;


@property (weak, nonatomic) IBOutlet UILabel *promoLabelText;
@property (weak, nonatomic) IBOutlet UIImageView *IndividualCouponImage;
@property BOOL returnedFromTweetBool;
@end

@implementation CouponRedeemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    FBSDKLikeControl *likeButton = [[FBSDKLikeControl alloc] init];
    likeButton.objectID = @"https://www.facebook.com/Google";
    likeButton.center = self.LikeContainerView.center;
    [self.LikeContainerView addSubview:likeButton];

//    
//    self.LikeButtonView.objectID = @"https://www.facebook.com/Google";
//    
    [likeButton addTarget:self action:@selector(likeButtonPressed) forControlEvents:UIControlEventValueChanged];
    
    
   // self.LikeButtonView.transform = CGAffineTransformMakeScale(2,2);
   // self.LikeButtonView.likeControlHorizontalAlignment = FBSDKLikeControlHorizontalAlignmentCenter;
    
    
   
//    
//    NSLayoutConstraint *centerConstraint = [NSLayoutConstraint constraintWithItem:self.button attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.lockedView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
//    
//    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.button attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.lockedView attribute:NSLayoutAttributeTop multiplier:1.0 constant:60.0];
//    
//    centerConstraint.active = YES;
//    topConstraint.active = YES;
//    [self.view addConstraint:centerConstraint];
//    [self.view addConstraint:topConstraint];
    
    
    self.longPressGesture.allowableMovement = 50;
    self.longPressGesture.delegate = self;
    

    
    self.lockedView.hidden = YES;
    
    self.promoCodeView.hidden = YES;
    
    self.IndividualCouponImage.clipsToBounds = YES;
    self.IndividualCouponImage.layer.cornerRadius = 5;
    
    
    if ([[self.couponObject valueForKey:@"payWithTweet"] integerValue] ==1) {
        self.lockedView.hidden = NO;
        
    }
    
    
    [self.tabBarController.tabBar setHidden:YES];
    
    self.promoLabelText.text = [self.couponObject valueForKey:@"promoCode"];
    
    PFFile *userImageFile = self.couponObject[@"Coupon"];
    [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            self.IndividualCouponImage.image = [UIImage imageWithData:imageData];
            
            
            self.promoCodeView.hidden = YES;
            
            
            [self.IndividualCouponImage addGestureRecognizer:self.longPressGesture];
        }
    }];
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    

    if ([[self.couponObject valueForKey:@"payWithTweet"] integerValue] == 1) {
        self.locked = YES;
        
        if (self.returnedFromTweetBool == YES) {
            self.locked = NO;
            self.returnedFromTweetBool = NO;
        }
    }
}
-(void) likeButtonPressed{
    
    
    
    self.locked = NO;
    self.lockedView.hidden = YES;
}
-(void)viewDidAppear:(BOOL)animated{
    
    PFQuery *couponsUsed = [PFQuery queryWithClassName:@"CouponUsed" predicate:[NSPredicate predicateWithFormat:@"user == %@", [PFUser currentUser]]];
    
    NSArray *coupons = [couponsUsed findObjects];
    
    if (coupons.count == 0) {
        UIAlertController *message = [UIAlertController alertControllerWithTitle:@"Congratulations!!!" message:@"You have unlocked a Bar Coup Coupon. Please make sure to CONTINUOUSLY HOLD DOWN finger to reveal promo code. The bartender or waitress MUST see this code!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [message addAction:defaultAction];
        
        [self presentViewController:message animated:NO completion:nil];
        
        
    }

    
}
- (IBAction)CouponPressed:(UILongPressGestureRecognizer *)sender {
    // check if locked if (!locked){
    if (!self.locked) {
        
        if (sender.state == UIGestureRecognizerStateBegan){
            NSLog(@"UIGestureRecognizerStateBegan.");
            self.promoCodeView.hidden = NO;
            
            
            
        }else if (sender.state == UIGestureRecognizerStateEnded){
            
            self.promoCodeView.hidden = YES;
            PFQuery *query = [PFQuery queryWithClassName:@"CouponUsed"];
            [query whereKey:@"user" equalTo:[PFUser currentUser]];
            [query includeKey:@"coupon"];
            NSUInteger couponCount = [query countObjects];
            
            PFObject *couponUsed = [PFObject objectWithClassName:@"CouponUsed"];
            [couponUsed setObject:[PFUser currentUser] forKey:@"user"];
            [couponUsed setObject:[NSDate date] forKey:@"dateUsed"];
            [couponUsed setObject:self.couponObject forKey:@"coupon"];
            [couponUsed setObject:self.couponObject[@"establishmentId"] forKey:@"establishmentId"];
            [couponUsed save]; // make synchronous first until system works, then go back and make async
            
            
            
            if (couponCount == 0) {
                [self performSegueWithIdentifier:@"toPersonalSurvey" sender:nil];
            }else{
            // find 12 hours ago from this moment - Use NSDate datewithtimeintervalsincenow (60 * 60 *12 )
            NSDate *timeSinceFirstDrink = [NSDate dateWithTimeIntervalSinceNow:(60 * 60 * 12)];
            
            // query for usedCupons by user (same query as carosel VC) BUT add constraint where 'createdAt' is less than 12 hours ago
            PFQuery *couponsUsed = [PFQuery queryWithClassName:@"CouponUsed"];
            [couponsUsed whereKey:@"user" equalTo:[PFUser currentUser]];
            [couponsUsed includeKey:@"coupon"];
            
             [couponsUsed whereKey:@"createdAt" greaterThan:timeSinceFirstDrink];
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
}
- (IBAction)backButtonPressed:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:NO];
    
    
}
- (IBAction)payWithTweetPressed:(UIButton *)sender {
    [self performSegueWithIdentifier:@"toPayWithTweet" sender:self];
}
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toCustomerReview"]) {
        CustomerReviewViewController *destination = segue.destinationViewController;
        destination.establishmentId = self.establishmentId;
        
    }else if ([segue.identifier isEqualToString:@"toPayWithTweet"]){
        PayWithTweetViewController *destination = segue.destinationViewController;
        destination.establishmentId = self.establishmentId;
        destination.couponObject = self.couponObject;
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
        self.lockedView.hidden = YES;
        self.locked = NO;
        self.returnedFromTweetBool = YES;
    }
    
}
@end
