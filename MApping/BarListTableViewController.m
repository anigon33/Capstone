//
//  BarListTableViewController.m
//  MApping
//
//  Created by Nigon's on 3/16/15.
//  Copyright (c) 2015 Adam Nigon. All rights reserved.
//

#import "BarListTableViewController.h"
#import "DetailsViewController.h"
#import <Parse/Parse.h>
#import <UIKit/UIKit.h>
#import "CustomTableViewCell.h"

@interface BarListTableViewController ()

@property (strong, nonatomic) PFObject *bar;



@end
@implementation BarListTableViewController
- (void)customInit {
    self.parseClassName = @"Establishment";
    self.pullToRefreshEnabled = YES;
    self.paginationEnabled = YES;
    self.objectsPerPage = 25;
}

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        [self customInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self customInit];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    
    // The key of the PFObject to display in the label of the default cell style
   // self.textKey = @"title";
    
    // Uncomment the following line to specify the key of a PFFile on the PFObject to display in the imageView of the default cell style
  //  self.imageKey = @"image";
    
    // Whether the built-in pull-to-refresh is enabled
    self.pullToRefreshEnabled = YES;
    
    // Whether the built-in pagination is enabled
    self.paginationEnabled = YES;
 
    // The number of objects to show per page
  //  self.objectsPerPage = 10;

    [self.tableView registerNib:[UINib nibWithNibName:@"CustomCellView" bundle:nil] forCellReuseIdentifier:@"customCellReuse"];
    
    
    UIImageView *logoTitle = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 70, 40)];
    logoTitle.image = [UIImage imageNamed:@"logoBarList"];
    logoTitle.contentMode = UIViewContentModeScaleToFill;
    self.navigationItem.titleView.contentMode = UIViewContentModeScaleToFill;
    
    [self.navigationItem setTitleView:logoTitle];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    UIImageView *tableViewBackground = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 450)];
    tableViewBackground.image = [UIImage imageNamed:@"blackBackground"];
    [[UITableView appearance] setBackgroundView:tableViewBackground];
    
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor grayColor]];
    [self.navigationController.navigationBar setTranslucent:NO];
}
-(void)viewWillAppear:(BOOL)animated{
    [[self navigationController] setNavigationBarHidden:NO animated:NO];

}
-(void)viewWillDisappear:(BOOL)animated{
    
}
#pragma mark - Table view data source

// all objects ordered by createdAt descending.
- (PFQuery *)queryForTable {
//    self.parseClassName = @"Establishment";
//    
//    // The key of the PFObject to display in the label of the default cell style
//    self.textKey = @"title";
//    
//    // Uncomment the following line to specify the key of a PFFile on the PFObject to display in the imageView of the default cell style
//    self.imageKey = @"image";
//    
//    // Whether the built-in pull-to-refresh is enabled
    self.pullToRefreshEnabled = YES;
//    
//    // Whether the built-in pagination is enabled
    self.paginationEnabled = NO;
//    
//    // The number of objects to show per page
//    self.objectsPerPage = 10;

    
    
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    
    // If Pull To Refresh is enabled, query against the network by default.
    if (self.pullToRefreshEnabled) {
        query.cachePolicy = kPFCachePolicyNetworkOnly;
    }
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if (self.objects.count == 0) {
        query.cachePolicy = kPFCachePolicyNetworkOnly;
    }
    
    [query orderByDescending:@"createdAt"];
    
    return query;
}



 // Override to customize the look of a cell representing an object. The default is to display
 // a UITableViewCellStyleDefault style cell with the label being the textKey in the object,
 // and the imageView being the imageKey in the object.
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
     
     static NSString *CellIdentifier = @"customCellReuse";
 
 
     CustomTableViewCell *cell = (CustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
     if (cell == nil) {
         cell = [[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
     }
     
     [cell setUpCellWithObject:object];
          

 return cell;
 }

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"DetailsSegue" sender:nil];
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"DetailsSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PFObject *object = [self.objects objectAtIndex:indexPath.row];
        
        DetailsViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.establishmentObject = object;
        
        [self.tableView deselectRowAtIndexPath:indexPath animated:NO];

        
        }
}



@end
