//
//  AppDelegate.h
//  MApping
//
//  Created by Nigon's on 3/13/15.
//  Copyright (c) 2015 Adam Nigon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate, CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocationManager *locationManager;
@property BOOL locationAccurate;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CLLocation *latestLocation;
@property (strong, nonatomic) PFObject *visitObject;
@property BOOL incompleteSurvey;

@end

