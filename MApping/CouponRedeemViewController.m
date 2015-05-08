//
//  CouponRedeemViewController.m
//  MApping
//
//  Created by Nigon's on 4/10/15.
//  Copyright (c) 2015 Adam Nigon. All rights reserved.
//

#import "CouponRedeemViewController.h"
#import <ParseUI/ParseUI.h>
@interface CouponRedeemViewController ()<UIGestureRecognizerDelegate, UITextViewDelegate>
{
    UITextView *sharingTextView;
    NSString *permanentText;
}
@property (strong, nonatomic) IBOutlet UILongPressGestureRecognizer *longPressGesture;

@property (weak, nonatomic) IBOutlet UILabel *promoLabelText;

@property (weak, nonatomic) IBOutlet UIImageView *IndividualCouponImage;

@end

@implementation CouponRedeemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    permanentText = @"YEs sir";

    
    
    self.longPressGesture.allowableMovement = 50;
    self.longPressGesture.delegate = self;

    
    self.payWithTweetButton.hidden = [self.establishmentObject[@"payWithTweet"] boolValue];
    self.payWithTweetButton.alpha = 1.0f;
    
    
    
    
    self.promoLabelText.text = [self.establishmentObject valueForKey:@"promoCode"];
    
    PFFile *userImageFile = self.establishmentObject[@"Coupon"];
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

- (IBAction)twitterPost:(id)sender {
    SLComposeViewController *mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    
    [mySLComposerSheet setInitialText:permanentText];
//    [mySLComposerSheet dismissViewControllerAnimated:YES completion:^{
//    
//        NSLog(@"LOGG");
//    }];
  

    
    
    [self presentViewController:mySLComposerSheet animated:YES completion:^{
        for (UIView *viewLayer1 in mySLComposerSheet.view.subviews) {
            for (UIView *viewLayer2 in viewLayer1.subviews) {
                if ([viewLayer2 isKindOfClass:[UIView class]]) {
                    for (UIView *viewLayer3 in viewLayer2.subviews) {
                        if ([viewLayer3 isKindOfClass:[UITextView class]]) {
                            [(UITextView *)viewLayer3 setDelegate:self];
                            sharingTextView = (UITextView *)viewLayer3;
                        }
                    }
                }
            }
        }
    }];
   
   
    [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
        
        switch (result) {
            case SLComposeViewControllerResultCancelled:
                NSLog(@"Post Canceled");
                break;
            case SLComposeViewControllerResultDone:
                
                NSLog(@"Post Sucessful");
                
                
                
                break;
                
            default:
                break;
        }
    }];
    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView == sharingTextView) {
        NSRange substringRange = [textView.text rangeOfString:permanentText];
        if (range.location >= substringRange.location && range.location <= substringRange.location + substringRange.length) {
            return NO;
        }
    }
    return YES;
}

@end
