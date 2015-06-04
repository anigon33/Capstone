//
//  AvViewController.m
//  MApping
//
//  Created by Nigon's on 5/25/15.
//  Copyright (c) 2015 Adam Nigon. All rights reserved.
//

#import "AvViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "CouponViewController.h"
@interface AvViewController ()

@end

@implementation AvViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
  //  NSString *filepath = [[NSBundle mainBundle] pathForResource:@"spacetestSMALL_512kb" ofType:@"mp4"];
    NSURL *fileURL = [NSURL URLWithString:[[self.couponObject objectForKey:@"videoAd"] valueForKey:@"url"]];
    AVPlayerItem *playerItem = [[AVPlayerItem alloc]initWithURL:fileURL];
    self.player = [AVPlayer playerWithPlayerItem:playerItem];

[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
    [self.player play];
    
    

}

-(void)itemDidFinishPlaying:(NSNotification *) notification {
    // Will be called when AVPlayer finishes playing playerItem
    NSArray *viewControllers = [self.navigationController viewControllers];
    for (UIViewController *vc in viewControllers) {
        if ([vc isKindOfClass:[CouponViewController class]]) {
            [self.navigationController popToViewController:vc animated:NO];
        }
    }
}

@end
