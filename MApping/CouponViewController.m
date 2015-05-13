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
@interface CouponViewController ()
@property (weak, nonatomic) IBOutlet iCarousel *carousel;

@property (weak, nonatomic) IBOutlet UILabel *singleMenLabel;
@property (weak, nonatomic) IBOutlet UILabel *singleWomenLabel;

@property (weak, nonatomic) IBOutlet PFImageView *BarHomePage;
@property (strong, nonatomic) PFObject *selectedCoupon;

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
    self.carousel.delegate = self;
    self.carousel.dataSource = self;
    self.carousel.type = iCarouselTypeCoverFlow2;
    self.carousel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.carousel.backgroundColor = [UIColor clearColor];
    
    self.BarHomePage.file = [self.establishmentObject objectForKey:@"image"];
    [self.BarHomePage loadInBackground];
    
    PFQuery *maleStatus = [PFQuery queryWithClassName:@"DemographicSurvey"];
    [maleStatus whereKey:@"Gender" equalTo:@"Male"];
    [maleStatus findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.singleMenLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)objects.count];
        }
    }];
    
    PFQuery *femaleStatus = [PFQuery queryWithClassName:@"DemographicSurvey"];
    [femaleStatus whereKey:@"Gender" equalTo:@"Female"];
    [femaleStatus findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.singleWomenLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)objects.count];
        }
    }];
    
    
    [self.view addSubview:self.BarHomePage];
    PFQuery *couponQuery = [PFQuery queryWithClassName:@"TavernCoupons"];
    [couponQuery whereKey:@"establishmentId" equalTo:self.establishmentObject[@"establishmentId"]];
    NSMutableArray *availableCoupons = [[NSMutableArray alloc] initWithArray:[couponQuery findObjects]];
    
    PFQuery *couponsUsed = [PFQuery queryWithClassName:@"CouponUsed"];
    [couponsUsed whereKey:@"user" equalTo:[PFUser currentUser]];
    self.usedCoupons = [[NSArray alloc] initWithArray:[couponsUsed findObjects]];
    
    
    
    self.couponImages = [[NSMutableArray alloc] initWithArray:availableCoupons];
    
    [self.carousel reloadData];
}
-(void)viewWillAppear:(BOOL)animated{
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    
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
    return self.couponImages.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UILabel *label = nil;
    
    //create new view if no view is available for recycling
    if (view == nil)
    {
        view = [[PFImageView alloc] initWithFrame:CGRectMake(0, 0, 240.0f, 240.0f)];
        ((PFImageView *)view).file = [self.couponImages objectAtIndex:index][@"Coupon"];
        [((PFImageView *)view) loadInBackground];
        view.contentMode = UIViewContentModeScaleAspectFill;
        for (NSDictionary *used in self.usedCoupons) {
            if ([[[self.couponImages objectAtIndex:index] valueForKey:@"objectId"] isEqualToString:[[used valueForKey:@"coupon"] valueForKey:@"objectId"]]) {
                view.alpha = .6 ;
                
                
            }
        }
        
    }
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
        return value = .65f;
    }
    if (option == iCarouselOptionWrap){
        return YES;
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
    if (self.usedCoupons.count ==0) {
        self.selectedCoupon = [self.couponImages objectAtIndex:index];
        [self performSegueWithIdentifier:@"toFullScreenCoupon" sender:self];
    }
    else{
    
    for (NSDictionary *used in self.usedCoupons) {
        if ([[[self.couponImages objectAtIndex:index] valueForKey:@"objectId"] isEqualToString:[[used valueForKey:@"coupon"] valueForKey:@"objectId"]]) {
            
            NSLog(@"Already Used Coupon!");
        }
        else {
            self.selectedCoupon = [self.couponImages objectAtIndex:index];
            [self performSegueWithIdentifier:@"toFullScreenCoupon" sender:self];
        }
        
        
    }
    }
    
}
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    CouponRedeemViewController *destination = segue.destinationViewController;
    destination.couponObject = self.selectedCoupon;
}


@end
