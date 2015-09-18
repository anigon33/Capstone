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
@property (strong, nonatomic) NSMutableArray *establishments;
@end

@implementation PayWithTweetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.webView reload];
    self.webView.delegate = self;
    self.establishments = [[NSMutableArray alloc]init];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.barcoup.com/starttweeting.html?establishmentid=%@", self.establishmentId]];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    [self.webView loadRequest:urlRequest];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView    {
    
    if ([webView.request.URL.absoluteString isEqual:kSuccessURL]) {
        self.success = YES;
        
        PFQuery *establishmentQuery = [PFQuery queryWithClassName:@"Establishment"];
        [establishmentQuery whereKey:@"establishmentId" equalTo:self.couponObject[@"establishmentId"]];
        self.establishments = [[NSMutableArray alloc]initWithArray:[establishmentQuery findObjects]];
        PFObject *establishment = [self.establishments objectAtIndex:0];
        [establishment incrementKey:@"TweetsSent" byAmount:[NSNumber numberWithInt:1]];
        [establishment saveInBackground];
        
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
    
    
}
- (IBAction)backButtonPressed:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:NO];
}
    
@end
