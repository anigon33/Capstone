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

@interface DetailsViewController ()

@property (weak, nonatomic) IBOutlet PFImageView *BarLogo;
@property (weak, nonatomic) IBOutlet UILabel *BarNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *BarImageView;
@property (weak, nonatomic) IBOutlet UILabel *BarSubtitleDetailsLabel;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) CLLocation *userLocation;
@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.BarSubtitleDetailsLabel.text = [self.establishmentObject objectForKey:@"subtitle"];
    self.BarNameLabel.text = self.establishmentObject[@"name"];
    
    self.BarLogo.file = [self.establishmentObject objectForKey:@"image"];
    [self.BarLogo loadInBackground];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updatedLocation:)
                                                 name:@"newLocationNotif"
                                               object:nil];

    
    
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.spinner.center = CGPointMake(160, 270);
    [self.view addSubview:self.spinner];
    
}
-(void) updatedLocation:(NSNotification*)notif {
    self.userLocation = (CLLocation*)[[notif userInfo] valueForKey:@"newLocationResult"];
}

- (IBAction)enterBarButtonPressed:(UIButton *)sender {
    
    //    [self performSegueWithIdentifier:@"toCouponPage" sender:self];
    PFGeoPoint *userLocation = [PFGeoPoint geoPointWithLocation:self.userLocation];
    
    [self.spinner startAnimating];
    PFQuery *query = [PFQuery queryWithClassName:@"Establishment"];
    // Interested in locations near user.
    [query whereKey:@"GeoCoordinates" nearGeoPoint:userLocation withinMiles:.02f];
    NSArray *barsAroundCurrentLocation;
    barsAroundCurrentLocation = [query findObjects];
    
    if (barsAroundCurrentLocation.count != 0){
        
    
    
        for (PFObject *bar in barsAroundCurrentLocation) {
        
        if ([self.establishmentObject[@"name"] isEqualToString:bar[@"name"]]) {
            [self performSegueWithIdentifier:@"toCouponPage" sender:self];
            NSLog(@"Test");
            [self.spinner stopAnimating];
        }
//        if (barsAroundCurrentLocation == nil){
//            NSString *title = @"Oops!";
//            NSString *message = @"Coup' users must be inside each bar to see the specials, so get over there already!!";
//            
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
//                                                                message:message
//                                                               delegate:self
//                                                      cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
//            
//            [self.spinner stopAnimating];
//            
//            [alertView show];
//        }
        else{
            NSString *title = @"Oops!";
            NSString *message = @"Coup' users must be inside each bar to see the specials, so get over there already!!";
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                                message:message
                                                               delegate:self
                                                      cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
            
            [self.spinner stopAnimating];
            
            [alertView show];

        }
//            39.94320113,-104.95623392
//            
//            39.943191,  -104.956193
            
        }
    }
    
    // do something with the new geoPoint
    
    
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    CouponViewController *destination = segue.destinationViewController;
    destination.establishmentObject = self.establishmentObject;
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
