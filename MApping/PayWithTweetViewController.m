//
//  PayWithTweetViewController.m
//  MApping
//
//  Created by Nigon's on 5/31/15.
//  Copyright (c) 2015 Adam Nigon. All rights reserved.
//

#import "PayWithTweetViewController.h"
#define kSuccessURL @"https://www.google.com/movement"
#define kErrorURL @"https://www.google.com/error"

@interface PayWithTweetViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation PayWithTweetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.webView reload];
    self.webView.delegate = self;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://107.170.232.77:8860/starttweeting.html?establishmentid=%@", self.establishmentId]];
   // NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.google.com"]];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    [self.webView loadRequest:urlRequest];
}
-(void)webViewDidStartLoad:(UIWebView *)webView {
    
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType{
    if ([webView.request.URL.absoluteURL isEqual:kSuccessURL]) {
        self.success = YES;
        
        [self performSegueWithIdentifier:@"unwindToCouponRedeem" sender:self];
        
        return NO;
        
    }else if([webView.request.URL.absoluteString isEqualToString:kErrorURL]){
        self.success = NO;
        [self performSegueWithIdentifier:@"unwindToCouponRedeem" sender:self];
        
    }
   return YES;
}
- (IBAction)backButtonPressed:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:NO];
}
    
@end
