//
//  AdditionalSurveyQuestionsViewController.m
//  MApping
//
//  Created by Nigon's on 3/26/15.
//  Copyright (c) 2015 Adam Nigon. All rights reserved.
//

#import "AdditionalSurveyQuestionsViewController.h"
#import <Parse/Parse.h>
#import "ViewController.h"
@interface AdditionalSurveyQuestionsViewController ()<UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic,strong) NSArray *frequency;
@property (nonatomic, strong) NSArray *drinks;
@property (nonatomic, strong) NSArray *musicType;
@property (nonatomic, strong) NSArray *maleFemale;
@property (nonatomic, strong) UIPickerView *goOutPicker;


@property (nonatomic, strong) PFObject *surveyAnswers;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UITextField *goOutFrequency;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UILabel *questionsLabel;
@property (nonatomic, strong) NSArray *surveyQuestions;
@property (nonatomic, strong) NSArray *inputArray;
@property (nonatomic, strong) PFObject *demographicsSurvey;
@end

@implementation AdditionalSurveyQuestionsViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   self.demographicsSurvey = [PFObject objectWithClassName:@"DemographicSurvey"];
    
    self.frequency = [NSArray arrayWithObjects:@"1 time a week or less", @"2-3 times a week", @"4-5 times a week", @"Party Animal", nil];
    self.drinks = [NSArray arrayWithObjects:@"Beer", @"Wine", @"Spirits", nil];
    self.musicType =[NSArray arrayWithObjects:@"Hip Hop", @"RnB", @"Country",@"Electronic", @"Rock", @"Classical", nil];
    self.maleFemale = [NSArray arrayWithObjects:@"Male", @"Female", nil];
    
    
    
    self.surveyQuestions = [NSArray arrayWithObjects:@"How many times a week do you go out?", @"What is your favorite type of drink?", @"What is your favorite type of music", @"Are you male or female?", nil];
    
    self.goOutPicker = [[UIPickerView alloc]init];
    self.goOutPicker.dataSource = self;
    self.goOutPicker.delegate = self;
    [self.goOutFrequency setInputView:self.goOutPicker];
   
    
    self.inputArray = [[NSArray alloc]init];
    self.inputArray = self.frequency;
    self.questionsLabel.text = [self.surveyQuestions objectAtIndex:0];
    self.submitButton.hidden = YES;
    
}


-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [self.inputArray count];
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.goOutFrequency.text = [self.inputArray objectAtIndex:row];
    
    
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    return [self.inputArray objectAtIndex:row];
   
}
- (IBAction)nextButtonPressed:(UIButton *)sender {
    
    if ([self.questionsLabel.text isEqualToString:[self.surveyQuestions objectAtIndex:0]]){
        

        self.demographicsSurvey[@"PartyFrequency"] = self.goOutFrequency.text;
        
        
                self.questionsLabel.text = [self.surveyQuestions objectAtIndex:1];
                self.goOutFrequency.text = @"";
                self.inputArray = self.drinks;
                [self.goOutPicker reloadAllComponents];
        
    }
    else if ([self.questionsLabel.text isEqualToString:[self.surveyQuestions objectAtIndex:1]]){
        
        self.demographicsSurvey[@"PreferredDrink"] = self.goOutFrequency.text;
        
        
                
                self.questionsLabel.text = [self.surveyQuestions objectAtIndex:2];
                self.goOutFrequency.text = @"";
                self.inputArray = self.musicType;
                [self.goOutPicker reloadAllComponents];
              }
    else if ([self.questionsLabel.text isEqualToString:[self.surveyQuestions objectAtIndex:2]]){
        
        self.demographicsSurvey[@"FavoriteMusic"] = self.goOutFrequency.text;
        
        
                self.questionsLabel.text = [self.surveyQuestions objectAtIndex:3];
                self.goOutFrequency.text = @"";
                self.inputArray = self.maleFemale;
                self.nextButton.hidden = YES;
                self.submitButton.hidden = NO;
                [self.goOutPicker reloadAllComponents];
        
        
    }
}

- (IBAction)submitButtonClicked:(id)sender {
    self.demographicsSurvey[@"Gender"] = self.goOutFrequency.text;
    [self.demographicsSurvey saveEventually];
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
