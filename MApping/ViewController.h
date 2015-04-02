//
//  ViewController.h
//  MApping
//
//  Created by Nigon's on 3/13/15.
//  Copyright (c) 2015 Adam Nigon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <ParseUI/ParseUI.h>
@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISegmentedControl *BarList;
@property (weak, nonatomic) IBOutlet MKMapView *myMapView;

@end

