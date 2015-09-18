//
//  CouponViewController.m
//  MApping
//
//  Created by Nigon's on 4/9/15.
//  Copyright (c) 2015 Adam Nigon. All rights reserved.
//

#import "CouponViewController.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "CouponRedeemViewController.h"
#import "Constants.h"
@interface CouponViewController ()
@property (weak, nonatomic) IBOutlet iCarousel *carousel;
@property (assign, readonly) BOOL isDataAvailable;

@property (weak, nonatomic) IBOutlet UILabel *singleMenLabel;
@property (weak, nonatomic) IBOutlet UILabel *singleWomenLabel;
@property (weak, nonatomic) IBOutlet UILabel *barName;

@property (strong, nonatomic) PFObject *selectedCoupon;
@property (strong, nonatomic) NSMutableArray *allCoupons;

@property(nonatomic, strong) NSArray *usedCoupons;

@property (nonatomic, strong) NSMutableArray *couponImages;
@end

@implementation CouponViewController


- (void)dealloc
{
    //it's a good idea to set these to nil here to avoid
    //sending messages to a deallocated viewcontroller
    _carousel.delegate = nil;
    _carousel.dataSource = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.carousel.type = iCarouselTypeCoverFlow2;
    self.carousel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.carousel.backgroundColor = [UIColor clearColor];
    self.carousel.scrollSpeed = .5;
    self.carousel.delegate = self;
    self.carousel.dataSource = self;
    
    
    self.barName.text = [self.establishmentObject objectForKey:@"name"];
    PFQuery *gender = [PFQuery queryWithClassName:@"Visit"];
    [gender whereKey:@"establishments" equalTo:self.establishmentObject];
    [gender whereKeyDoesNotExist:@"end"];
    [gender includeKey:@"user"];
    [gender findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSMutableDictionary *males = [[NSMutableDictionary alloc]init];
            NSMutableDictionary *females = [[NSMutableDictionary alloc]init];
            for (PFObject *visit in objects) {
                [[visit objectForKey:@"user"] objectForKey:@"gender"];
                [[visit objectForKey:@"user"] objectForKey:@"maritalStatus"];
                if ([[[visit objectForKey:@"user"] objectForKey:@"gender"] isEqualToString:@"Male"] && [[visit objectForKey:@"user"] objectForKey:@"maritalStatus"]) {
                    if (![males objectForKey:[[visit objectForKey:@"user"]valueForKey:@"objectId"]]) {
                        
                        [males setObject:[visit objectForKey:@"user"] forKey:[[visit objectForKey:@"user"]valueForKey:@"objectId"]];
                        
                    }
                }
                if ([[[visit objectForKey:@"user"] objectForKey:@"gender"] isEqualToString:@"Female"] && [[visit objectForKey:@"user"] objectForKey:@"maritalStatus"]) {
                    if (![females objectForKey:[[visit objectForKey:@"user"]valueForKey:@"objectId"]]) {
                        
                        [females setObject:[visit objectForKey:@"user"] forKey:[[visit objectForKey:@"user"]valueForKey:@"objectId"]];
                        
                    }
                    
                }
            }
            
            self.singleMenLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)males.count];
            self.singleWomenLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)females.count];
        }
    }];
    
    
    
    
    
    
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    [self.tabBarController.tabBar setHidden:NO];
    
    [[PFUser currentUser] fetch];
    if ([[PFUser currentUser] objectForKey:@"willResumeLiquor"] == nil|| [[[PFUser currentUser] objectForKey:@"willResumeLiquor"] compare:[NSDate date]] == NSOrderedAscending) {
        [[PFUser currentUser] setObject:[NSNumber numberWithBool:NO] forKey:@"isCutOff"];
        [[PFUser currentUser] save];
    }
    //start activity indicator
    UIActivityIndicatorView *acitvityIndicator = [[UIActivityIndicatorView alloc]init];
    [acitvityIndicator startAnimating];
    PFQuery *couponQuery = [PFQuery queryWithClassName:@"TavernCoupons"];
    [couponQuery whereKey:@"establishmentId" equalTo:self.establishmentObject[@"establishmentId"]];
    [couponQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.allCoupons = [[NSMutableArray alloc]initWithArray:objects];
            NSUInteger index = 0;
            for (NSDictionary *coupons in self.allCoupons){
                if ([[coupons valueForKey:@"isWelcomeMessage"] isEqualToNumber:[NSNumber numberWithBool:YES]]) {
                    index = [self.allCoupons indexOfObject:coupons];
                }
            }
            PFObject *messageCoupon = [self.allCoupons objectAtIndex:index];
            [self.allCoupons removeObjectAtIndex:index];
            
            [self.allCoupons insertObject:messageCoupon atIndex:0];
            
            PFQuery *couponsUsed = [PFQuery queryWithClassName:@"CouponUsed"];
            [couponsUsed whereKey:@"dateUsed" greaterThan:[NSDate dateWithTimeIntervalSinceNow:-60 * 60 * kHoursForCouponReset]];
            [couponsUsed whereKey:@"user" equalTo:[PFUser currentUser]];
            self.usedCoupons = [[NSArray alloc] initWithArray:[couponsUsed findObjects]];
            
            
            
            [self.carousel reloadData];
            //end activity indicator
            [acitvityIndicator stopAnimating];
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        
        
    }];
    
    
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    self.carousel = nil;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return self.allCoupons.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
   // CGFloat screenHeight = screenRect.size.height;
    
    UILabel *label = nil;
    NSLog(@"index: %ld", (long)index);
    
    NSLog(@"bar name: %@", [self.allCoupons objectAtIndex:index][@"promoCode"]);
    //create new view if no view is available for recycling
    if (view == nil)
    {
        if (screenWidth == 320.00f){
            
            view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 380)];
        }else if (screenWidth == 375.00f){
            view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 310, 460)];

        }else if (screenWidth == 414.00f){
            view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 350, 550)];

        }
            view.clipsToBounds = YES;
            view.layer.cornerRadius = 5;
            PFFile *couponImage = [self.allCoupons objectAtIndex:index][@"Coupon"];
            
            
            [couponImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error)
             {
                 if (!error)
                 {
                     
                     view.contentMode = UIViewContentModeScaleAspectFill;
                     for (NSDictionary *used in self.usedCoupons) {
                         if ([[[self.allCoupons objectAtIndex:index] valueForKey:@"objectId"] isEqualToString:[[used valueForKey:@"coupon"] valueForKey:@"objectId"]] ||
                             ([[[PFUser currentUser] valueForKey:@"isCutOff"]integerValue] == 1 && [[[self.allCoupons objectAtIndex:index]  valueForKey:@"isLiquorCoupon"] integerValue] == 1)) {
                             view.alpha = .6 ;
                             
                             
                         }
                     }
                     
                     UIImage *coupon = [UIImage imageWithData:data];
                     UIImageView *couponView = [[UIImageView alloc]init];
                     if (screenWidth == 320.00f){
                         couponView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 280, 380)];
                     } else if (screenWidth == 375.00f){
                         couponView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 310, 460)];

                     }else if (screenWidth == 414.00f){
                         couponView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 350, 550)];

                     }
                     couponView.image = coupon;
                     [view addSubview:couponView];
                     
                     // use the newly retrieved data
                 }
             }];

    }
    
//        }else if (screenWidth == 375.00f){
//            
//            view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 310, 450)];
//            view.clipsToBounds = YES;
//            view.layer.cornerRadius = 5;
//            PFFile *couponImage = [self.allCoupons objectAtIndex:index][@"Coupon"];
//            
//            
//            [couponImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error)
//             {
//                 if (!error)
//                 {
//                     
//                     view.contentMode = UIViewContentModeScaleAspectFill;
//                     for (NSDictionary *used in self.usedCoupons) {
//                         if ([[[self.allCoupons objectAtIndex:index] valueForKey:@"objectId"] isEqualToString:[[used valueForKey:@"coupon"] valueForKey:@"objectId"]] ||
//                             ([[[PFUser currentUser] valueForKey:@"isCutOff"]integerValue] == 1 && [[[self.allCoupons objectAtIndex:index]  valueForKey:@"isLiquorCoupon"] integerValue] == 1)) {
//                             view.alpha = .6 ;
//                             
//                             
//                         }
//                     }
//                     
//                     UIImage *coupon = [UIImage imageWithData:data];
//                     UIImageView *couponView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 310, 450)];
//                     couponView.image = coupon;
//                     [view addSubview:couponView];
//                     
//                     // use the newly retrieved data
//                 }
//             }];
//
//            
//        } else if (screenWidth == 414){
//        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 330, 485)];
//        view.clipsToBounds = YES;
//        view.layer.cornerRadius = 5;
//        PFFile *couponImage = [self.allCoupons objectAtIndex:index][@"Coupon"];
//        
//        
//        [couponImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error)
//         {
//             if (!error)
//             {
//                 
//                 view.contentMode = UIViewContentModeScaleAspectFill;
//                 for (NSDictionary *used in self.usedCoupons) {
//                     if ([[[self.allCoupons objectAtIndex:index] valueForKey:@"objectId"] isEqualToString:[[used valueForKey:@"coupon"] valueForKey:@"objectId"]] ||
//                         ([[[PFUser currentUser] valueForKey:@"isCutOff"]integerValue] == 1 && [[[self.allCoupons objectAtIndex:index]  valueForKey:@"isLiquorCoupon"] integerValue] == 1)) {
//                         view.alpha = .6 ;
//                         
//                         
//                     }
//                 }
//                 
//                 UIImage *coupon = [UIImage imageWithData:data];
//                 UIImageView *couponView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 330, 485)];
//                 couponView.image = coupon;
//                 [view addSubview:couponView];
//                 
//                 // use the newly retrieved data
//             }
//         }];
//        //}
//        
//        }
    
  //  }
    else
    {
        //get a reference to the label in the recycled view
        label = (UILabel *)[view viewWithTag:1];
    }
    
    //set item label
    //remember to always set any properties of your carousel item
    //views outside of the `if (view == nil) {...}` check otherwise
    //you'll get weird issues with carousel item content appearing
    //in the wrong place in the carousel
    label.text = @"";
    
    return view;
}
- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    if (option == iCarouselOptionSpacing)
    {
        return value * 1.5;
    }
    if (option == iCarouselOptionTilt) {
        return value = .8;
    }
    if (option == iCarouselOptionWrap){
        return YES;
    }
    else if(option == iCarouselOptionVisibleItems) {
        return self.allCoupons.count;
    }
    return value;
}

- (CATransform3D)carousel:(iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    //implement 'flip3D' style carousel
    transform = CATransform3DRotate(transform, M_PI / 8.0f, 0.0f, 1.0f, 0.0f);
    return CATransform3DTranslate(transform, 0.0f, 0.0f, offset * carousel.itemWidth);
}
- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    
    
    
    BOOL hasUsed = NO;
    if ([[[PFUser currentUser] objectForKey:@"isCutOff"] integerValue] == 1 && [[[self.allCoupons objectAtIndex:index] valueForKey:@"isLiquorCoupon"] integerValue] == 1){
        hasUsed = YES;
        NSString *title = @"Yikes!";
        NSString *message = @"4 liqour coupons in one night! Try one of our food coupons to sober up!";
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
        
        
        [alertView show];
        
    }else{
        
        
        for (NSDictionary *used in self.usedCoupons) {
            if ([[[self.allCoupons objectAtIndex:index] valueForKey:@"objectId"] isEqualToString:[[used valueForKey:@"coupon"] valueForKey:@"objectId"]]) {
                hasUsed = YES;
                NSLog(@"Already Used Coupon!");
                return;
            }
        }
    }
    if(!hasUsed && [[[self.allCoupons objectAtIndex:index] valueForKey:@"isWelcomeMessage"] isEqualToNumber:[NSNumber numberWithBool:NO]]){
        self.selectedCoupon = [self.allCoupons objectAtIndex:index];
        [self performSegueWithIdentifier:@"toFullScreenCoupon" sender:self];
    }
}



-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    CouponRedeemViewController *destination = segue.destinationViewController;
    destination.couponObject = self.selectedCoupon;
    
    destination.establishmentId = [self.establishmentObject valueForKey:@"objectId"];
}


@end
