//
//  BarHomePageViewController.m
//  MApping
//
//  Created by Nigon's on 10/11/15.
//  Copyright (c) 2015 Adam Nigon. All rights reserved.
//

#import "BarHomePageViewController.h"
#import "BarListTableViewController.h"
@interface BarHomePageViewController ()
@property (weak, nonatomic) IBOutlet UILabel *LiveUsersNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *couponsRedeemedNumberLabel;

@property (weak, nonatomic) IBOutlet UILabel *tweetsSentNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *barNameLabel;

@property (nonatomic, strong)NSMutableArray *currentVisitArray;

@end

@implementation BarHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.currentVisitArray = [[NSMutableArray alloc]init];
    
    self.barNameLabel.text = [NSString stringWithFormat:@"%@", self.establishmentObject[@"name"]];
    
    self.tweetsSentNumberLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)[self.establishmentObject[@"TweetsSent"]integerValue]];
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"Visit"];
    [query whereKeyDoesNotExist:@"end"];


    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        
        
        
        for (PFObject *object in objects){
            if ([[[object valueForKey:@"establishments"]valueForKey:@"objectId"] isEqualToString:self.establishmentObject.objectId] ) {
                
                [self.currentVisitArray addObject:object];
            }
            self.LiveUsersNumberLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.currentVisitArray.count];
        }
        
    
    }];
    
    PFQuery *usedCouponsQuery = [PFQuery queryWithClassName:@"CouponUsed"];
    [usedCouponsQuery whereKey:@"establishmentId" equalTo:self.establishmentObject[@"establishmentId"]];
    
    [usedCouponsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        
        self.couponsRedeemedNumberLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)objects.count];
        }];
    
    
    
    }
    

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)logOutButtonClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
