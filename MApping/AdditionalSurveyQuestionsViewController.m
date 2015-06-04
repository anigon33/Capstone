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
@property (nonatomic, strong) NSArray *maritalStatus;
@property (nonatomic, strong) NSArray *maleFemale;
@property (nonatomic, strong) UIPickerView *goOutPicker;
@property (nonatomic, strong)UIDatePicker *datePicker;


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
    
    
    //create survey answers arrays for picker view 
    self.frequency = [NSArray arrayWithObjects:@"1 time a week or less", @"2-3 times a week", @"4-5 times a week", @"Party Animal", nil];
    self.drinks = [NSArray arrayWithObjects:@"Beer", @"Wine", @"Spirits", nil];
    self.maritalStatus =[NSArray arrayWithObjects:@"Single", @"Married", @"Not Interested", nil];
    self.maleFemale = [NSArray arrayWithObjects:@"Male", @"Female", nil];
    
    
    //create survey question array
    self.surveyQuestions = [NSArray arrayWithObjects:@"How many times a week do you go out?", @"What is your favorite type of drink?", @"Marital Status?", @"Are you male or female?", @"Whats your date of birth", nil];
    
    //initializing picker view
    self.goOutPicker = [[UIPickerView alloc]init];
    self.goOutPicker.dataSource = self;
    self.goOutPicker.delegate = self;
    [self.goOutFrequency setInputView:self.goOutPicker];
    self.goOutPicker.backgroundColor = [UIColor clearColor];
    
    self.datePicker = [[UIDatePicker alloc]init];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    [self.datePicker addTarget:self action:@selector(updateTextField:) forControlEvents:UIControlEventValueChanged];

    
    //initialize question 1
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
    
    
    if ([self.questionsLabel.text isEqualToString:[self.surveyQuestions objectAtIndex:0]]  && ![self.goOutFrequency.text isEqualToString:@""]){
        
        
        [PFUser currentUser][@"partyFrequency"] = self.goOutFrequency.text;
        
        
        self.questionsLabel.text = [self.surveyQuestions objectAtIndex:1];
        self.goOutFrequency.text = @"";
        self.inputArray = self.drinks;
        [self.goOutPicker reloadAllComponents];
        
    }
    else if ([self.questionsLabel.text isEqualToString:[self.surveyQuestions objectAtIndex:1]]  && ![self.goOutFrequency.text isEqualToString:@""]){
        
        [PFUser currentUser][@"perferredDrink"] = self.goOutFrequency.text;
        
        
        
        self.questionsLabel.text = [self.surveyQuestions objectAtIndex:2];
        self.goOutFrequency.text = @"";
        self.inputArray = self.maritalStatus;
        [self.goOutPicker reloadAllComponents];
    }
    else if ([self.questionsLabel.text isEqualToString:[self.surveyQuestions objectAtIndex:2]]  && ![self.goOutFrequency.text isEqualToString:@""]){
        
        [PFUser currentUser][@"maritalStatus"] = self.goOutFrequency.text;
        
        
        self.questionsLabel.text = [self.surveyQuestions objectAtIndex:3];
        self.goOutFrequency.text = @"";
        self.inputArray = self.maleFemale;
        self.nextButton.hidden = NO;
        [self.goOutPicker reloadAllComponents];
        
        
    }
    else if ([self.questionsLabel.text isEqualToString:[self.surveyQuestions objectAtIndex:3]]  && ![self.goOutFrequency.text isEqualToString:@""]){
        
        [PFUser currentUser][@"gender"] = self.goOutFrequency.text;
        self.questionsLabel.text = [self.surveyQuestions objectAtIndex:4];
        self.goOutFrequency.text = @"";
        self.nextButton.hidden = YES;
        self.submitButton.hidden = NO;
        self.goOutFrequency.inputView = self.datePicker;
    
        [self.goOutFrequency resignFirstResponder];
        


    }
}
-(void)updateTextField:(id)sender
{
    self.goOutFrequency.inputView = self.datePicker;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    NSString *stringDate = [dateFormatter stringFromDate:self.datePicker.date];
    self.goOutFrequency.text = stringDate;
}

- (IBAction)submitButtonClicked:(id)sender {
    if ([self.questionsLabel.text isEqualToString:[self.surveyQuestions objectAtIndex:4]]  && ![self.goOutFrequency.text isEqualToString:@""]){
        
    [PFUser currentUser][@"birthday"] = self.datePicker.date;
    [[PFUser currentUser] saveEventually];
    [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}



@end
