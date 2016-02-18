//
//  AdditionalQuestionsViewController.m
//  MApping
//
//  Created by Nigon's on 10/21/15.
//  Copyright (c) 2015 Adam Nigon. All rights reserved.
//

#import "AdditionalQuestionsViewController.h"
#import <Parse/Parse.h>

@interface AdditionalQuestionsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *questionsLabel;
@property (strong, nonatomic) NSArray *dataSourceArray;
//@property (strong, nonatomic) PFObject *surveyAnswer;
@property (strong, nonatomic) NSDictionary *dataSourceDict;
@property int dataSourceIndex;
@property (weak, nonatomic) IBOutlet UILabel *counterLabel;


@end

@implementation AdditionalQuestionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 0.01f)];
    
    
    NSArray *reviewQuestions = [[NSArray alloc]initWithObjects:@"How many times a week do you go out?", @"What is your favorite type of drink?", @"Marital Status?", @"Are you male or female?", @"How old are you?", nil];
    NSArray *ageRanges =[[NSArray alloc]initWithObjects:@"21-31", @"31-41", @"41-51", @"51 and over", nil];
    
    NSArray *drinkAnswers = [[NSArray alloc]initWithObjects:@"Beer", @"Wine", @"Spirits", nil];
    
    NSArray *maritalStatus = [[NSArray alloc]initWithObjects:@"Single", @"Married", @"Not Interested", nil];
    
    NSArray *nightlyGoOut = [[NSArray alloc]initWithObjects:@"1 time a week or less", @"2-3 times a week", @"Party Animal", nil];
    
    NSArray *gender = [[NSArray alloc]initWithObjects: @"male", @"female", @"", nil];
    
    self.dataSourceArray = @[@{@"question":[reviewQuestions objectAtIndex:0], @"answers": nightlyGoOut, @"order":@1, @"surveyKey":@"goOutFrequency"},
                             @{@"question":[reviewQuestions objectAtIndex:1], @"answers": drinkAnswers, @"order":@2, @"surveyKey":@"preferredBeverage"},
                             @{@"question":[reviewQuestions objectAtIndex:2], @"answers": maritalStatus, @"order":@3, @"surveyKey":@"relationshipStatus"},
                             @{@"question":[reviewQuestions objectAtIndex:3], @"answers": gender, @"order":@3, @"surveyKey":@"maleFemale"},
                             @{@"question":[reviewQuestions objectAtIndex:4], @"answers": ageRanges, @"order":@3, @"surveyKey":@"ageRanges"}];
    
    self.dataSourceIndex = 0;
    
    self.dataSourceDict = [self.dataSourceArray objectAtIndex:self.dataSourceIndex];
  //  self.surveyAnswer = [PFObject objectWithClassName:@"EstablishmentReview"];

    
    self.questionsLabel.text = [self.dataSourceDict objectForKey:@"question"];
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
    [[PFUser currentUser] setValue:@(indexPath.row) forKey:[self.dataSourceDict objectForKey:@"surveyKey"]];
    
    
    // change out the question and possible answers
    self.dataSourceIndex++;
    if (self.dataSourceIndex < self.dataSourceArray.count) {
        self.counterLabel.text = [NSString stringWithFormat:@"%d/%lu", self.dataSourceIndex + 1, (unsigned long)self.dataSourceArray.count];
    }
    
    
    if (self.dataSourceArray.count == self.dataSourceIndex) {
        [[PFUser currentUser] saveInBackground];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"com.barcoup.introSurvey" object:nil userInfo:@{@"isCompleted":@YES}];
        
        if (self.presentedModally) {
            self.presentedModally = NO;
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        }
        [self performSegueWithIdentifier:@"unwindFromPersonalQuestions" sender:self];
        
        
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
