//
//  DetailsViewController.m
//  MApping
//
//  Created by Nigon's on 3/18/15.
//  Copyright (c) 2015 Adam Nigon. All rights reserved.
//

#import "DetailsViewController.h"
#import "MapViewAnnotation.h"
#import <ParseUI/ParseUI.h>
#import "CouponViewController.h"
#import "AppDelegate.h"
@interface DetailsViewController ()<CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet PFImageView *BarLogo;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIButton *enterBarButton;
@property (nonatomic, strong) CLLocation *userLocation;
@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    
    self.BarLogo.file = [self.establishmentObject objectForKey:@"image"];
    [self.BarLogo loadInBackground];
    
    
   [[self navigationController] setNavigationBarHidden:YES animated:NO];

    
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.spinner.center = CGPointMake(160, 270);
    [self.view addSubview:self.spinner];
    
}
-(void) viewDidAppear:(BOOL)animated{
    
}
- (IBAction)enterBarButtonPressed:(UIButton *)sender {
    
    [UIView animateWithDuration:0.1 animations:^{
        self.enterBarButton.transform = CGAffineTransformMakeTranslation(10, 0);
    } completion:^(BOOL finished) {
        // Step 2
        [UIView animateWithDuration:0.1 animations:^{
            self.enterBarButton.transform = CGAffineTransformMakeTranslation(-10, 0);
        } completion:^(BOOL finished) {
            // Step 3
            [UIView animateWithDuration:0.1 animations:^{
                
            }completion:^(BOOL finished){
                self.enterBarButton.transform = CGAffineTransformMakeTranslation(0, 0);
                
                
                
            }];
        }];
    }];
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if (appDelegate.locationAccurate) {
        
        
        BOOL barFound = NO;
        CLLocation *currentLocation = appDelegate.latestLocation;
        
        [self.spinner startAnimating];

        PFQuery *query = [PFQuery queryWithClassName:@"Establishment"];
        // Interested in locations near user.
        PFGeoPoint *userLocation = [PFGeoPoint geoPointWithLocation:currentLocation];
        [query whereKey:@"GeoCoordinates" nearGeoPoint:userLocation withinMiles:.02f];
        NSArray *barsAroundCurrentLocation;
        barsAroundCurrentLocation = [query findObjects];
        [self.spinner stopAnimating];
        
        if (barsAroundCurrentLocation.count != 0){
            
            
            
            for (PFObject *bar in barsAroundCurrentLocation) {
                
                if ([self.establishmentObject[@"name"] isEqualToString:bar[@"name"]]) {
                    [self performSegueWithIdentifier:@"toCouponPage" sender:self];
                    
                    barFound = YES;
                    NSLog(@"Test");
                }
            }
            if(barFound == NO){
                NSString *title = @"Oops!";
                NSString *message = @"Coup' users must be inside each bar to see the specials, so get over there already!!";
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                                    message:message
                                                                   delegate:self
                                                          cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
                
                
                [alertView show];
            }
        }
        
        
        
        
        else{
            NSString *title = @"Oops!";
            NSString *message = @"Coup' users must be inside each bar to see the specials, so get over there already!!";
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                                message:message
                                                               delegate:self
                                                      cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
            
            
            [alertView show];
            
        }
        
        
    }else{
        NSString *title = @"Whoa!";
        NSString *message = @"Hold on let us catch up! Try again soon";
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
        
        
        [alertView show];
        
    }

  
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    CouponViewController *destination = segue.destinationViewController;
    destination.establishmentObject = self.establishmentObject;
}

@end
