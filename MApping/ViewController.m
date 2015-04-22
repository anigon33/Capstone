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
@property (nonatomic, strong) NSArray *locations;
@property (nonatomic, strong) PFObject *annotationTapped;
@property (nonatomic, strong) CLLocation *userLocation;
@end

@implementation ViewController
#define METERS_PER_MILE 1609.344

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // ** Don't forget to add NSLocationWhenInUseUsageDescription in MyApp-Info.plist and give it a string
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"login"]];
  
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updatedLocation:)
                                                 name:@"newLocationNotif"
                                               object:nil];
    
        self.myMapView.delegate = self;
    self.myMapView.showsUserLocation = YES;
    [self zoomToLocation];
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"Establishment"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.locations = [[NSArray alloc]initWithArray:objects];
            
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
                                      | PFLogInFieldsPasswordForgotten);
        
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
-(void) updatedLocation:(NSNotification*)notif {
    self.userLocation = (CLLocation*)[[notif userInfo] valueForKey:@"newLocationResult"];
}

-(void) logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [self.myMapView addAnnotations:[self createAnnotations]];

}
-(void) signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user{
    
    // pop a pushMODALView in a view controller
  //  AdditionalSurveyQuestionsViewController *additionalVC = [[AdditionalSurveyQuestionsViewController alloc] init];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
   
    [self performSegueWithIdentifier:@"surveySegue" sender:self];
    
}
- (NSMutableArray *)createAnnotations
{
    NSMutableArray *annotations = [[NSMutableArray alloc]init];
    
    
    for (int i = 0; i < self.locations.count; i++) {
        PFObject *row = [self.locations objectAtIndex:i];
        
        PFGeoPoint *barCoordinates = [row objectForKey:@"GeoCoordinates"];
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(barCoordinates.latitude, barCoordinates.longitude);
        
        
        NSString *subtitle = [row objectForKey:@"subtitle"];
        
        
     
        
        
        NSString *title = [row objectForKey:@"name"];
       
        PFImageView *imageView = [[PFImageView alloc] init];
        imageView.file = [row objectForKey:@"image"];
        [imageView loadInBackground];
        MapViewAnnotation *annotation = [[MapViewAnnotation alloc] initWithTitle:title AndCoordinate:coordinate andImage:imageView andSubtitle:subtitle andEstablishmentIndex:i];
        
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
    if ([view.annotation isKindOfClass:[MapViewAnnotation class]])
    {
        
        
        MapViewAnnotation *mapVA = view.annotation;
        self.annotationTapped = [self.locations objectAtIndex:mapVA.establishmentIndex];
        
        
        [self performSegueWithIdentifier:@"toDetails" sender:self];
    }
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"toDetails"]) {
        DetailsViewController *destination = [segue destinationViewController];
        destination.establishmentObject = self.annotationTapped;

        
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
        
        av.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
//        MapViewAnnotation *customAnnotation = annotation;
//        
//
//        PFImageView *imageView = [[PFImageView alloc] init];
//        imageView = customAnnotation.image;
//        [imageView loadInBackground];
//
//        av.leftCalloutAccessoryView = imageView;

       
        
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

                                 
                                 
                                 
                                 
                                 
                                 

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        // Send the user to the Settings for this app
        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:settingsURL];
    }
}

@end
