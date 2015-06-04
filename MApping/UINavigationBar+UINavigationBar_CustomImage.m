//
//  UINavigationBar+UINavigationBar_CustomImage.m
//  MApping
//
//  Created by Nigon's on 5/25/15.
//  Copyright (c) 2015 Adam Nigon. All rights reserved.
//

#import "UINavigationBar+UINavigationBar_CustomImage.h"

@implementation UINavigationBar (UINavigationBar_CustomImage)
- (void) setBackgroundImage:(UIImage*)image {
    if (image == NULL) return;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(0, 0, 320, 44);
    [self insertSubview:imageView atIndex:0];
}

- (void) clearBackgroundImage {
    NSArray *subviews = [self subviews];
    for (int i=0; i<[subviews count]; i++) {
        if ([[subviews objectAtIndex:i]  isMemberOfClass:[UIImageView class]]) {
            [[subviews objectAtIndex:i] removeFromSuperview];
        }
    }
}
@end
