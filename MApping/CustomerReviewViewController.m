//
//  ReviewViewController.m
//  MApping
//
//  Created by Nigon's on 9/17/15.
//  Copyright (c) 2015 Adam Nigon. All rights reserved.
//

#import "CustomerReviewViewController.h"
@interface CustomerReviewViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *questionsLabel;
@property (strong, nonatomic) NSArray *dataSourceArray;
@property (strong, nonatomic) PFObject *surveyAnswer;
@property (strong, nonatomic) NSDictionary *dataSourceDict;
@property int dataSourceIndex;

@end

@implementation CustomerReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
   
    NSArray *reviewQuestions = [[NSArray alloc]initWithObjects:@"How likely are you to tell your friends about us?", @"How was the service 1 being the worst and 5 being extrodanary?",@"Would you use this coupon again?", nil];
    
    
    NSArray *recommendAnswers = [[NSArray alloc]initWithObjects:@"Not Likely",@"Somewhat Likely", @"Very Likely", nil];
    
    NSArray *rankingService = [[NSArray alloc]initWithObjects:@"1",@"2",@"3",@"4",@"5", nil];

    NSArray *reuseCoupon = [[NSArray alloc]initWithObjects:@"Yes",@"Probably", @"No", nil];
    

    self.dataSourceArray = @[@{@"question":[reviewQuestions objectAtIndex:0], @"answers": recommendAnswers, @"order":@1, @"surveyKey":@"RecommendUs"},
                        @{@"question":[reviewQuestions objectAtIndex:1], @"answers": rankingService, @"order":@2, @"surveyKey":@"ServiceRank"},
  @{@"question":[reviewQuestions objectAtIndex:2], @"answers": reuseCoupon, @"order":@3, @"surveyKey":@"ReUseCoupon"}];

    self.dataSourceIndex = 0;
    
    self.dataSourceDict = [self.dataSourceArray objectAtIndex:self.dataSourceIndex];
    self.surveyAnswer = [PFObject objectWithClassName:@"EstablishmentReview"];
    PFQuery *establishmentQuery = [PFQuery queryWithClassName:@"Establishment" predicate:[NSPredicate predicateWithFormat:@"objectId == %@", self.establishmentId]];
    [establishmentQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            PFRelation *relation = [self.surveyAnswer relationForKey:@"establishment"];
            [relation addObject:[objects objectAtIndex:0]];
            [self.surveyAnswer saveInBackground];
            // The find succeeded. The first 100 objects are available in objects
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    self.questionsLabel.text = [self.dataSourceDict objectForKey:@"question"];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 0.01f)];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [[self.dataSourceDict objectForKey:@"answers"]count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = [[self.dataSourceDict objectForKey:@"answers"] objectAtIndex:indexPath.row];
    
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    // record answer
    [self.surveyAnswer setValue:[NSNumber numberWithInt:(int)indexPath.row] forKey:[self.dataSourceDict objectForKey:@"surveyKey"]];
    
    
    // change out the question and possible answers
    self.dataSourceIndex++;
    
    
    if (self.dataSourceArray.count == self.dataSourceIndex) {
        [self.surveyAnswer saveInBackground];

        [self performSegueWithIdentifier:@"backToCoupons" sender:self];
       
        
    }else{
    
    self.dataSourceDict = [self.dataSourceArray objectAtIndex:self.dataSourceIndex];
    self.questionsLabel.text = [self.dataSourceDict objectForKey:@"question"];

    [self.tableView reloadData];
    }
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
