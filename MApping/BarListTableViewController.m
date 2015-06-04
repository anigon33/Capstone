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
#import "UINavigationBar+UINavigationBar_CustomImage.h"
@interface BarListTableViewController ()

@property (strong, nonatomic) PFObject *bar;



@end
@implementation BarListTableViewController
- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom the table
        
        // The className to query on
           }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
    self.parseClassName = @"Establishment";
    
    // The key of the PFObject to display in the label of the default cell style
    self.textKey = @"title";
    
    // Uncomment the following line to specify the key of a PFFile on the PFObject to display in the imageView of the default cell style
    self.imageKey = @"image";
    
    // Whether the built-in pull-to-refresh is enabled
    self.pullToRefreshEnabled = YES;
    
    // Whether the built-in pagination is enabled
    self.paginationEnabled = YES;
    
    // The number of objects to show per page
    self.objectsPerPage = 10;

    
    UIImageView *logoTitle = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 70, 40)];
    logoTitle.image = [UIImage imageNamed:@"logoBarList"];
    logoTitle.contentMode = UIViewContentModeScaleToFill;
    self.navigationItem.titleView.contentMode = UIViewContentModeScaleToFill;
    
    [self.navigationItem setTitleView:logoTitle];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    UIImageView *tableViewBackground = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 450)];
    tableViewBackground.image = [UIImage imageNamed:@"blackBackground"];
    [[UITableView appearance] setBackgroundView:tableViewBackground];
    

}
-(void)viewWillAppear:(BOOL)animated{
    [[self navigationController] setNavigationBarHidden:NO animated:NO];

}
#pragma mark - Table view data source

// all objects ordered by createdAt descending.
- (PFQuery *)queryForTable {
    self.parseClassName = @"Establishment";
    
    // The key of the PFObject to display in the label of the default cell style
    self.textKey = @"title";
    
    // Uncomment the following line to specify the key of a PFFile on the PFObject to display in the imageView of the default cell style
    self.imageKey = @"image";
    
    // Whether the built-in pull-to-refresh is enabled
    self.pullToRefreshEnabled = NO;
    
    // Whether the built-in pagination is enabled
    self.paginationEnabled = YES;
    
    // The number of objects to show per page
    self.objectsPerPage = 10;

    
    
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    
    // If Pull To Refresh is enabled, query against the network by default.
    if (self.pullToRefreshEnabled) {
        query.cachePolicy = kPFCachePolicyNetworkOnly;
    }
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if (self.objects.count == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [query orderByDescending:@"createdAt"];
    
    return query;
}



 // Override to customize the look of a cell representing an object. The default is to display
 // a UITableViewCellStyleDefault style cell with the label being the textKey in the object,
 // and the imageView being the imageKey in the object.
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
     
     static NSString *CellIdentifier = @"reuse";
 
 
     PFTableViewCell *cell = (PFTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
     if (cell == nil) {
         cell = [[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
     }
     // Configure the cell...
     
     PFImageView *imageView = [[PFImageView alloc] initWithFrame:CGRectMake(0, 5, 80, 80)];
     imageView.file = [object objectForKey:self.imageKey];
     [imageView loadInBackground];
     
     UILabel *mainLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 20, 220, 25)];
     mainLabel.text = object[@"name"];
     mainLabel.textColor = [UIColor whiteColor];
     mainLabel.font = [UIFont systemFontOfSize:18];
     
     UILabel *detailsLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 40, 220, 30)];
     detailsLabel.text = object[@"subtitle"];
     detailsLabel.textColor = [UIColor whiteColor];
     detailsLabel.adjustsFontSizeToFitWidth = YES;
     detailsLabel.font = [UIFont systemFontOfSize:9];
     
    
     UIImageView *cellBackgroundView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 90)];
     cellBackgroundView.image = [UIImage imageNamed:@"cellImage"];
     
     cell.backgroundColor = [UIColor clearColor];
     [cell addSubview:cellBackgroundView];
     [cell addSubview:imageView];
     [cell addSubview:mainLabel];
     [cell addSubview:detailsLabel];
 return cell;
 }

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//   
//    [self performSegueWithIdentifier:@"DetailsSegue" sender:self];
//}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"DetailsSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PFObject *object = [self.objects objectAtIndex:indexPath.row];
        
        DetailsViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.establishmentObject = object;
        
        
        }
}



@end
