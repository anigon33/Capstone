//
//  PayWithTweetViewController.m
//  MApping
//
//  Created by Nigon's on 5/31/15.
//  Copyright (c) 2015 Adam Nigon. All rights reserved.
//

#import "PayWithTweetViewController.h"
#define kSuccessURL @"http://www.barcoup.com/EndTweet.html"

#define kErrorURL @"https://api.twitter.com/login/error?username_or_email=taxmagicman&redirect_after_login=https%3A%2F%2Fapi.twitter.com%2Foauth%2Fauthenticate%3Foauth_token%3Dnpq44wAAAAAAf8YVAAABTiFQUj0"

@interface PayWithTweetViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation PayWithTweetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.webView reload];
    self.webView.delegate = self;

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.barcoup.com/starttweeting.html?establishmentid=%@", self.establishmentId]];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    [self.webView loadRequest:urlRequest];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView    {
    
    if ([webView.request.URL.absoluteString isEqual:kSuccessURL]) {
        self.success = YES;
        
        [self performSegueWithIdentifier:@"unwindToCouponRedeem" sender:self];
        
    }else if([webView.request.URL.absoluteString isEqualToString:kErrorURL]){
        self.success = NO;
        [self performSegueWithIdentifier:@"unwindToCouponRedeem" sender:self];
    }
    else if([webView.request.URL.absoluteString isEqualToString:kErrorURL]){
        NSString *title = @"Oops!";
        NSString *message = @"Please try again";
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        
        [alertView show];

        [self.navigationController popViewControllerAnimated:NO];

    }
    
    // This is the url that cause page to have "sorry that page doesnt exist"
    // https://api.twitter.com/login/error?username_or_email=taxmagicman&redirect_after_login=https%3A%2F%2Fapi.twitter.com%2Foauth%2Fauthenticate%3Foauth_token%3Dnpq44wAAAAAAf8YVAAABTiFQUj0
    
    
}
- (IBAction)backButtonPressed:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:NO];
}
    
@end
