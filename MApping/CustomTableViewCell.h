//
//  CustomTableViewCell.h
//  MApping
//
//  Created by Nigon's on 10/10/15.
//  Copyright (c) 2015 Adam Nigon. All rights reserved.
//

#import <ParseUI/ParseUI.h>
#import <Parse/Parse.h>
@interface CustomTableViewCell : PFTableViewCell
-(void)setUpCellWithObject: (PFObject *)object;
@end
