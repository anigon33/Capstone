//
//  MapViewAnnotation.h
//  MApping
//
//  Created by Nigon's on 3/13/15.
//  Copyright (c) 2015 Adam Nigon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
@interface MapViewAnnotation : NSObject <MKAnnotation>
@property (nonatomic,copy) NSString *title;
@property (nonatomic, copy)NSString *subtitle;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly) PFImageView *image;
@property (nonatomic, readonly) NSInteger establishmentIndex;
-(id) initWithTitle:(NSString *) title AndCoordinate:(CLLocationCoordinate2D)coordinate andImage:(PFImageView *)image andSubtitle:(NSString *)subtitle andEstablishmentIndex:(NSInteger)establishmentIndex;
@end