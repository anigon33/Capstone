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
#import "AppDelegate.h"
#import "CustomerReviewViewController.h"
#import "AdditionalQuestionsViewController.h"
@interface ViewController () <CLLocationManagerDelegate, MKMapViewDelegate,UINavigationControllerDelegate, PFSignUpViewControllerDelegate, PFLogInViewControllerDelegate>
@property (nonatomic, strong) NSArray *locations;
@property (nonatomic, strong) PFObject *annotationTapped;
@property (nonatomic, strong) CLLocation *userLocation;
@property (nonatomic, strong) AppDelegate *appDelegate;
@property int zoomCounter;
@end

@implementation ViewController
#define METERS_PER_MILE 1609.344

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // ** Don't forget to add NSLocationWhenInUseUsageDescription in MyApp-Info.plist and give it a string
   
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updatedLocation:)
                                                 name:@"newLocationNotif"
                                               object:nil];
    
    self.myMapView.clipsToBounds = YES;
    self.myMapView.layer.cornerRadius = 5;
    
    
    self.myMapView.delegate = self;
    
    self.appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    
//    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(self.myMapView.userLocation.coordinate, 25*METERS_PER_MILE,25*METERS_PER_MILE);
//    [self.myMapView regionThatFits:viewRegion];
//    
//    [self.myMapView setRegion:viewRegion animated:YES];
    
    //[self refreshAnnotations];
    
    
        
}
-(void)viewDidAppear:(BOOL)animated{
    self.myMapView.showsUserLocation = YES;

    [self refreshAnnotations];
    
    UIStoryboard *st = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    if (self.appDelegate.personalSurveyIsInComplete) {
        AdditionalQuestionsViewController *additionalQuestionsViewController = [st instantiateViewControllerWithIdentifier:@"AdditionQuestionsViewController"];
        [additionalQuestionsViewController view];
        additionalQuestionsViewController.presentedModally = YES;
        [additionalQuestionsViewController setModalPresentationStyle:UIModalPresentationOverCurrentContext];
        [self presentViewController:additionalQuestionsViewController animated:YES completion:nil];

    } else if (self.appDelegate.establishmentSurveyIsInComplete){
        
        CustomerReviewViewController *customerReviewController = [st instantiateViewControllerWithIdentifier:@"CustomerReviewViewController"];
        [customerReviewController view];
        customerReviewController.presentedModally = YES;
        [customerReviewController setModalPresentationStyle:UIModalPresentationOverCurrentContext];
        [self presentViewController:customerReviewController animated:YES completion:nil];
    }

}
-(void)viewWillAppear:(BOOL)animated{
    self.zoomCounter = 0;

}
-(void) viewDidDisappear:(BOOL)animated{
    [self.myMapView removeAnnotations:self.myMapView.annotations];

}
-(void) refreshAnnotations{
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
}
-(void) updatedLocation:(NSNotification*)notif {
    self.userLocation = (CLLocation*)[[notif userInfo] valueForKey:@"newLocationResult"];
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

    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(self.myMapView.userLocation.coordinate, 25*METERS_PER_MILE,25*METERS_PER_MILE);
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
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [aV setFrame:endFrame];
        [UIView commitAnimations];
        
    }
}


-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation   {
   
    
    if (self.appDelegate.locationAccurate && self.zoomCounter == 0) {
        [self zoomToLocation];
        self.zoomCounter++;
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
