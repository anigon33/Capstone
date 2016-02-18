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
#import <QuartzCore/QuartzCore.h>
#import "BarAdminLoginViewController.h"
#import "BarChatLogInViewController.h"
#import "BarChatSignUpViewController.h"
@interface DetailsViewController ()<CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet PFImageView *BarLogo;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIButton *enterBarButton;
@property (nonatomic, strong) CLLocation *userLocation;
@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.enterBarButton.clipsToBounds = YES;
    self.enterBarButton.layer.cornerRadius = 1;
    
    self.BarLogo.clipsToBounds = YES;
    self.BarLogo.layer.cornerRadius  = 2;
    
    
    self.BarLogo.file = [self.establishmentObject objectForKey:@"image"];
    [self.BarLogo loadInBackground];
    
    self.BarLogo.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *pgr = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self action:@selector(handleTap:)];
    pgr.delegate = self;
    [self.BarLogo addGestureRecognizer:pgr];
    
    
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    
    
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.spinner.center = CGPointMake(160, 270);
    [self.view addSubview:self.spinner];
    
}
-(void) viewDidAppear:(BOOL)animated{
    
}
-(void)handleTap:(id)sender{
    [self enterBarButtonPressed:sender];
}
- (IBAction)barLoginClicked:(id)sender {
    [self performSegueWithIdentifier:@"toBarAdminLogin" sender:nil];
    
}

- (IBAction)enterBarButtonPressed:(UIButton *)sender {
//    
//    if ([self.establishmentObject[@"name"] isEqualToString:@"The Chateaux at Fox Meadows"]) {
//        [self performSegueWithIdentifier:@"toCouponPage" sender:self];
//
//    }else{
    
    
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
        signUpViewController.fields = (PFSignUpFieldsUsernameAndPassword
                                       | PFSignUpFieldsSignUpButton);
        
        // Assign our sign up controller to be displayed from the login controller
        [logInViewController setSignUpController:signUpViewController];
        
        
        // Present the log in view controller
        [self presentViewController:logInViewController animated:YES completion:NULL];
        
        
        
        
        
    }else{

    

    
    
    
    [[PFUser currentUser] fetch];
    
    if ([[[PFUser currentUser] valueForKey:@"emailVerified"] integerValue] == 0){
        NSString *title = @"Whoops";
        NSString *message = @"Please verify your email before getting great deals!";
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
        
        
        [alertView show];
        
    }else{
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        if (appDelegate.locationAccurate) {
            
            
            BOOL barFound = NO;
            CLLocation *currentLocation = appDelegate.latestLocation;
            
            [self.spinner startAnimating];
            
            PFQuery *query = [PFQuery queryWithClassName:@"Establishment"];
            // Interested in locations near user.
            PFGeoPoint *userLocation = [PFGeoPoint geoPointWithLocation:currentLocation];
            [query whereKey:@"GeoCoordinates" nearGeoPoint:userLocation withinMiles:.2];
            NSArray *barsAroundCurrentLocation;
            barsAroundCurrentLocation = [query findObjects];
            [self.spinner stopAnimating];
            
            if (barsAroundCurrentLocation.count != 0){
                
                
                
                for (PFObject *bar in barsAroundCurrentLocation) {
                    
                    if ([self.establishmentObject[@"name"] isEqualToString:bar[@"name"]]) {
                        barFound = YES;
                        NSLog(@"Test");
                        if (appDelegate.visitObject == nil) {
                            appDelegate.visitObject = [PFObject objectWithClassName:@"Visit"];
                            [appDelegate.visitObject setObject:[NSDate date] forKey:@"start"];
                            [appDelegate.visitObject setObject:userLocation forKey:@"startGeoPoint"];
                            [appDelegate.visitObject setObject:[PFUser currentUser] forKey:@"user"];
                            [appDelegate.visitObject setObject:self.establishmentObject forKey:@"establishments"];
                            [appDelegate.visitObject saveInBackground];
                        }
                        
                        [self performSegueWithIdentifier:@"toCouponPage" sender:self];
                        
                        
                        
                    }
                    if(barFound == NO){
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
                                    NSString *title = @"Oops!";
                                    NSString *message = @"Coup' users must be inside each bar to see the specials, so get over there already!!";
                                    
                                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                                                        message:message
                                                                                       delegate:self
                                                                              cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
                                    
                                    
                                    [alertView show];
                                    
                                    
                                    
                                    
                                }];
                            }];
                        }];
                        
                        
                    }
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
    }

    }
//}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"toCouponPage"]) {
        
    CouponViewController *destination = segue.destinationViewController;
    destination.establishmentObject = self.establishmentObject;
        
    }
    if ([segue.identifier isEqualToString:@"toBarAdminLogin"]) {
        BarAdminLoginViewController *destination = segue.destinationViewController;
        destination.establishmentObject = self.establishmentObject;
    }
    
}
-(void) logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user{
    if ([[[PFUser currentUser] valueForKey:@"emailVerified"] isEqualToNumber:[NSNumber numberWithBool:NO]]) {
        NSString *title = @"Oops!";
        NSString *message = @"Please verify email before procedding";
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
        [alertView show];
        
    }else {
        
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void) signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user{
    if ([[[PFUser currentUser] valueForKey:@"emailVerified"] isEqualToNumber:[NSNumber numberWithBool:NO]]) {
        NSString *title = @"Oops!";
        NSString *message = @"Please verify email before procedding";
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
        [alertView show];
        
    }else {
        
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        
    }
}

@end
