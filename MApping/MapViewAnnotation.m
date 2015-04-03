//
//  MapViewAnnotation.m
//  MApping
//
//  Created by Nigon's on 3/13/15.
//  Copyright (c) 2015 Adam Nigon. All rights reserved.
//

#import "MapViewAnnotation.h"

@implementation MapViewAnnotation
@synthesize coordinate=_coordinate;
@synthesize title=_title;
@synthesize image=_image;
@synthesize subtitle = _subtitle;
-(id) initWithTitle:(NSString *)title AndCoordinate:(CLLocationCoordinate2D)coordinate andImage:(PFImageView *)image andSubtitle:(NSString *)subtitle;
{
    self = [super init];
    _title = title;
    _coordinate = coordinate;
    _image = image;
    _subtitle = subtitle;
    return self;
}
@end