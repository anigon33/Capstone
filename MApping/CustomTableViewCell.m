//
//  CustomTableViewCell.m
//  MApping
//
//  Created by Nigon's on 10/10/15.
//  Copyright (c) 2015 Adam Nigon. All rights reserved.
//

#import "CustomTableViewCell.h"

@interface CustomTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *mainLabel;
@property (weak, nonatomic) IBOutlet PFImageView *barImage;
@property (weak, nonatomic) IBOutlet UILabel *subtitle;

@end

@implementation CustomTableViewCell
-(void) setUpCellWithObject:(PFObject *)object{
    self.mainLabel.text = object[@"name"];
    self.barImage.file = object[@"image"];
    self.subtitle.text = object[@"subtitle"];
    self.backgroundColor = [UIColor clearColor];
    
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


@end
