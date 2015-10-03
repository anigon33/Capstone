//
//  AppDelegate.m
//  MApping
//
//  Created by Nigon's on 3/13/15.
//  Copyright (c) 2015 Adam Nigon. All rights reserved.
//

#import "AppDelegate.h"
#import "CoreData+MagicalRecord.h"
#import "EstablishmentRegion.h"
#import "CustomerReviewViewController.h"
#import "ViewController.h"

@interface AppDelegate ();
@property (strong, nonatomic) CLCircularRegion *region;
@property (strong, nonatomic) NSArray *establishmentObjects;
@property (strong, nonatomic) NSMutableArray *barRegions;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
    
    //[Parse enableLocalDatastore];
    [Parse setApplicationId:@"sZre86lG4ulrSGqA50KmG9Fef1nv9IUKwmtc8aC6"
                  clientKey:@"EqZMxxzkIszmTyplXiDgRFiJZY5AyQCDXTR8nPlI"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    
    UITabBarController *tabController = (UITabBarController *)self.window.rootViewController;
    tabController.delegate = self;
    //[[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    //    [[UITabBar appearance] setBackgroundImage:[UIImage new]];
    
    
    
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    self.locationManager.pausesLocationUpdatesAutomatically = NO;
    [self.locationManager startUpdatingLocation];
    
    //  Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    }
    
        
    self.barRegions = [[NSMutableArray alloc]init];

    PFQuery *establishments = [PFQuery queryWithClassName:@"Establishment"];
    PFGeoPoint *currentLocation = [PFGeoPoint geoPointWithLocation:self.locationManager.location];
    
    [establishments whereKey:@"GeoCoordinates" nearGeoPoint:currentLocation];
    [establishments findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        self.establishmentObjects = [NSArray arrayWithArray:objects];
        
        for (PFObject *object in objects){
            PFGeoPoint *geopoint = [object objectForKey:@"GeoCoordinates"];
            
            
            CLLocationCoordinate2D center = CLLocationCoordinate2DMake(geopoint.latitude, geopoint.longitude);
            
            CLRegion *region = [[CLCircularRegion alloc] initWithCenter:center
                                                                 radius:30.00
                                                             identifier:[object objectForKey:@"name"]];
            self.region.notifyOnEntry = YES;
            self.region.notifyOnExit = YES;
            // Then cast the instance for use with your CLLocationManager instance
            
            [self.barRegions addObject:region];
            
        }
    }];
    
    // read unifinishedSurvey bool
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(surveyCompletionStatusUpdated:) name:@"com.barcoup.surveydatachanged" object:nil];
    
    NSString *filePath = [self dataFilePath];
    NSArray *pListDataArray;
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        pListDataArray = [[NSArray alloc] initWithContentsOfFile:filePath];
        
        if([[pListDataArray firstObject]boolValue] == NO){
            // Load survey View Controller
            
            self.incompleteSurvey = YES;
            
        }
    }
    return YES;
}

-(void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    NSLog(@"Region not monitored :(");
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *newLocation = [locations lastObject];
    CLLocationCoordinate2D currentLocationCoordinate = newLocation.coordinate;
    if (newLocation.horizontalAccuracy <= self.locationManager.desiredAccuracy){
        self.locationAccurate = YES;
        self.latestLocation = [[CLLocation alloc]initWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
        self.latestLocation = newLocation;
        
        
        NSLog(@"current location = %@", [locations lastObject]);
        if ([PFUser currentUser] ==nil) {
            
        }else{
        // looping through establishment region to see if user is in one of the bars
        for (CLCircularRegion *establishmentRegion in self.barRegions){
            if ([establishmentRegion containsCoordinate:currentLocationCoordinate]){
                //checking name of visit bar object is equal to the name of the region identifier
                if ([[[self.visitObject objectForKey:@"establishments"] objectForKey:@"name"] isEqualToString:establishmentRegion.identifier]) {
                    
                    //do nothing because they have already created visit
                    
                } else {
                    if (self.establishmentObjects != nil) {
                        
                        self.visitObject = [PFObject objectWithClassName:@"Visit"];
                        [self.visitObject setObject:[PFUser currentUser] forKey:@"user"];
                        [self.visitObject setObject:[NSDate date] forKey:@"start"];
                        
                        PFGeoPoint *userLocation = [PFGeoPoint geoPointWithLocation:self.latestLocation];
                        [self.visitObject setObject:userLocation forKey:@"startGeoPoint"];
                        
                        NSString *barName = establishmentRegion.identifier;
                        for (PFObject *establishmentObject in self.establishmentObjects){
                            
                            if ([barName isEqualToString:[establishmentObject valueForKey:@"name"]]) {
                                self.visitObject [@"establishments"] = establishmentObject;
                            }
                            
                            
                        }
                        
                        [self.visitObject saveInBackground];
                    }
                }
            } else {
                if (self.visitObject != nil && [[[self.visitObject objectForKey:@"establishments"] objectForKey:@"name"] isEqualToString:establishmentRegion.identifier]){
                    
                    NSLog(@"holla");
                    [self.visitObject setObject:[NSDate date] forKey:@"end"];
                    PFGeoPoint *userLocation = [PFGeoPoint geoPointWithLocation:self.latestLocation];
                    [self.visitObject setObject:userLocation forKey:@"endGeoPoint"];
                    [self.visitObject saveInBackground];
                    
                    self.visitObject = nil;
                    
                }
            }
            
        }
    }
    }
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


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
   
    [self.locationManager stopUpdatingLocation];
    [self.locationManager startMonitoringSignificantLocationChanges];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    self.locationAccurate = NO;
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [self.locationManager startUpdatingLocation];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
    if (![self.visitObject objectForKey:@"end"]) {
        [self.visitObject setObject:[NSDate date] forKey:@"end"];
        [self.visitObject save];

    }
    
}
-(void) tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    if ([viewController isKindOfClass:[UINavigationController class]])
    {
        [(UINavigationController *)viewController popToRootViewControllerAnimated:YES];
    }
}

-(NSString *)dataFilePath{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"data.plist"];
}

-(void)surveyCompletionStatusUpdated:(NSNotification *)notification{
    
    NSString *filePath = [self dataFilePath];
    NSNumber *completed = [notification.userInfo objectForKey:@"isCompleted"];
    NSArray *pListDataArray = @[completed];
    [pListDataArray writeToFile:filePath atomically:YES];
    
}

@end
