//
//  ViewController.m
//  MApping
//
//  Created by Nigon's on 3/13/15.
//  Copyright (c) 2015 Adam Nigon. All rights reserved.
//
#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>
#import "Annotations.h"
#import "MapViewAnnotation.h"
#import "BarListTableViewController.h"
#import "BarChatLogInViewController.h"
#import "BarChatSignUpViewController.h"
#import "AdditionalSurveyQuestionsViewController.h"
#import <ParseUI/ParseUI.h>
#import "DetailsViewController.h"

@interface ViewController () <CLLocationManagerDelegate, MKMapViewDelegate,UINavigationControllerDelegate, PFSignUpViewControllerDelegate, PFLogInViewControllerDelegate>
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic, strong) NSArray *locations;
@end

@implementation ViewController
#define METERS_PER_MILE 1609.344

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // ** Don't forget to add NSLocationWhenInUseUsageDescription in MyApp-Info.plist and give it a string
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"login"]];
  
    
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
   //  Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    }
    self.myMapView.delegate = self;
    self.myMapView.showsUserLocation = YES;
    [self zoomToLocation];
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"Establishment"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.locations = [[NSArray alloc]initWithArray:objects];
            [self.myMapView addAnnotations:[self createAnnotations]];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    


    if (![PFUser currentUser]) { // No user logged in
        // Create the log in view controller
        BarChatLogInViewController *logInViewController = [[BarChatLogInViewController alloc] init];
        [logInViewController setDelegate:self]; // Set ourselves as the delegate
        logInViewController.fields = (PFLogInFieldsUsernameAndPassword
                                      | PFLogInFieldsLogInButton
                                      | PFLogInFieldsSignUpButton
                                      | PFLogInFieldsPasswordForgotten
                                      | PFLogInFieldsFacebook
                                      | PFLogInFieldsTwitter);
        
        // Create the sign up view controller
        BarChatSignUpViewController *signUpViewController = [[BarChatSignUpViewController alloc] init];
        [signUpViewController setDelegate:self]; // Set ourselves as the delegate
        
        // Assign our sign up controller to be displayed from the login controller
        [logInViewController setSignUpController:signUpViewController];
    
        
        // Present the log in view controller
        [self presentViewController:logInViewController animated:YES completion:NULL];
        logInViewController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"login"]];
        
    }
    
}
-(void) logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];

}
-(void) signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user{
    
    // pop a pushMODALView in a view controller
  //  AdditionalSurveyQuestionsViewController *additionalVC = [[AdditionalSurveyQuestionsViewController alloc] init];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
   
    [self performSegueWithIdentifier:@"surveySegue" sender:self];
    
}
- (IBAction)segmentedPushed:(id)sender {
    if (self.BarList.selectedSegmentIndex == 0){
    }
    if (self.BarList.selectedSegmentIndex == 1) {
        BarListTableViewController *barController = [[BarListTableViewController alloc] init];
        
        UINavigationController *bar = [[UINavigationController alloc]init];
        [bar pushViewController:barController animated:YES];
    }
}
- (NSMutableArray *)createAnnotations
{
    NSMutableArray *annotations = [[NSMutableArray alloc] init];
    
    for (NSDictionary *row in self.locations) {
        PFGeoPoint *barCoordinates = [row objectForKey:@"GeoCoordinates"];
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(barCoordinates.latitude, barCoordinates.longitude);
        
        
        NSString *subtitle = [row objectForKey:@"subtitle"];
        
        
        
        NSString *title = [row objectForKey:@"name"];
       
        PFImageView *imageView = [[PFImageView alloc] init];
        imageView.file = [row objectForKey:@"image"];
        [imageView loadInBackground];
        MapViewAnnotation *annotation = [[MapViewAnnotation alloc] initWithTitle:title AndCoordinate:coordinate andImage:imageView andSubtitle:subtitle];
        
        [annotations addObject:annotation];
    }
    return annotations;
    //working annotations
}
- (void)zoomToLocation
{
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 39.750661;
    zoomLocation.longitude= -104.992028;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 3*METERS_PER_MILE,3*METERS_PER_MILE);
    [self.myMapView regionThatFits:viewRegion];

    [self.myMapView setRegion:viewRegion animated:YES];
}
- (void)mapView:(MKMapView *)mapView
 annotationView:(MKAnnotationView *)view
calloutAccessoryControlTapped:(UIControl *)control{
    
    [self performSegueWithIdentifier:@"toDetails" sender:self];
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"toDetails"]) {
//        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//        PFObject *object = [self.objects objectAtIndex:indexPath.row];
//        
//        DetailsViewController *detailsViewController = [segue destinationViewController];
//        detailsViewController.establishmentObject = object;
        NSLog(@"Yay!");
        
    }
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    static NSString *reuseId = @"reuseid";
    MKAnnotationView *av = [mapView dequeueReusableAnnotationViewWithIdentifier:reuseId];
    if (av == nil)
    {
        av = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseId];
        

   //     av.leftCalloutAccessoryView = [[PFImageView alloc]initWithImage:self.locations[@"image"]];
        
        av.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 20)];
        lbl.backgroundColor = [UIColor clearColor];
        lbl.textColor = [UIColor whiteColor];
        lbl.tag = 01;
        lbl.font = [UIFont fontWithName:@"TrebuchetMS-bold" size:10];
        [av addSubview:lbl];
        av.canShowCallout = YES;
        
        av.image = [UIImage imageNamed:@"beermug"];
        
    }
    else
    {
        av.annotation = annotation;
    }
    UILabel *lbl = (UILabel *)[av viewWithTag:01];
  // lbl.text = annotation.title;
    lbl.textAlignment = NSTextAlignmentJustified;
    
    return av;
}
                                 
 
- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    MKAnnotationView *aV;
    for (aV in views) {
        CGRect endFrame = aV.frame;
        
        aV.frame = CGRectMake(aV.frame.origin.x, aV.frame.origin.y - 230.0, aV.frame.size.width, aV.frame.size.height);
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.8];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [aV setFrame:endFrame];
        [UIView commitAnimations];
        
    }
}

                                 
                                 
                                 
                                 
                                 
                                 
// Location Manager Delegate Methods
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"%@", [locations lastObject]);
}
- (void)requestAlwaysAuthorization
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    // If the status is denied or only granted for when in use, display an alert
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusDenied) {
        NSString *title;
        title = (status == kCLAuthorizationStatusDenied) ? @"Location services are off" : @"Background location is not enabled";
        NSString *message = @"To use background location you must turn on 'Always' in the Location Services Settings";
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Settings", nil];
        [alertView show];
    }
    // The user has not enabled any location services. Request background authorization.
    else if (status == kCLAuthorizationStatusNotDetermined) {
        [self.locationManager requestAlwaysAuthorization];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        // Send the user to the Settings for this app
        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:settingsURL];
    }
}

@end
