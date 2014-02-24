//
//  ISSetWorkoutGoalViewController.m
//  Fitness
//
//  Created by ispluser on 2/12/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import "ISSetWorkoutGoalViewController.h"
#import "ISWorkoutReminderController.h"
#import "ISAppDelegate.h"
#import "macros.h"
#import "ILAlertView.h"

#define MILES 1
#define CALORIES 2
#define DURATION 3

@interface ISSetWorkoutGoalViewController ()

@end

@implementation ISSetWorkoutGoalViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.woGoal=[[(ISAppDelegate *)[[UIApplication sharedApplication]delegate] woHandler] woGoal];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupGoalsRB];
    [self setupNavigationBar];
    [self setupViewWorkoutGoalsClickEvent];
    [self fillGoalTextField];
    [self toggleWOGoal:nil];
}



-(void)fillGoalTextField
{
    if (self.woGoal.goalType!=0) {
        switch (self.woGoal.goalType) {
            case MILES:
                [self milesTFClicked:nil];
                self.milesTextField.text=[NSString stringWithFormat:@"%.2f",[self.woGoal.goalValue doubleValue]];
                break;
                
            case CALORIES:
                [self caloriesTFClicked:nil];
                self.caloriesTextField.text=[NSString stringWithFormat:@"%.1f",[self.woGoal.goalValue doubleValue]];
                break;
            case DURATION:
                [self durationTFClicked:nil];
                self.durationTextField.text=[NSString stringWithFormat:@"%.0f",[self.woGoal.goalValue doubleValue]];
                break;
        }
    }
}

//---------------------------------------setup onclick events---------------------
-(void)setupViewWorkoutGoalsClickEvent
{
    UITapGestureRecognizer *tapOnRemView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(displayReminders:)] ;
    tapOnRemView.numberOfTapsRequired=1;
    [self.openRemindersView addGestureRecognizer:tapOnRemView];
    
    UITapGestureRecognizer *tapOnWOView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toggleWOGoal:)] ;
    tapOnWOView.numberOfTapsRequired=1;
    [self.enableWOGoal addGestureRecognizer:tapOnWOView];
    
}
-(void)toggleWOGoal:(id)sender
{
    UILabel *lbl=(UILabel*)[self.enableWOGoal viewWithTag:9];
    ISAppDelegate *appDel=(ISAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    if (!appDel.woHandler.isWOStarted) {
        
        if (sender !=nil) {
            
            appDel.woHandler.isWOGoalEnable=!appDel.woHandler.isWOGoalEnable;
        }
       
        if (appDel.woHandler.isWOGoalEnable ) {
            
            if (appDel.woHandler.woGoal.woGoalId!=0 || appDel.woHandler.woGoal.goalType!=0) {
                
                lbl.text=@"Disable WO Goal";
                [self fillGoalTextField];
            }
            else
            {
                [ILAlertView showWithTitle:@"Warning" message:@"Please Set Workout Goal First" closeButtonTitle:@"OK" secondButtonTitle:nil tappedSecondButton:nil];
                [self clearGoalType];
                self.milesRB.selected=YES;
                [self.milesTextField becomeFirstResponder];
            }
            
            
        }
        else
        {
            lbl.text=@"Enable WO Goal";
            
        }
    }
    else
    {
        [ILAlertView showWithTitle:@"Warning" message:@"Stop Current Workout First" closeButtonTitle:@"OK" secondButtonTitle:nil tappedSecondButton:nil];
    }
    
}
-(void) displayReminders:(id)sender
{

    [(UINavigationController*)[(ISAppDelegate *)[[UIApplication sharedApplication]delegate] drawerController].centerViewController pushViewController:[[ISWorkoutReminderController alloc] initWithNibName:nil bundle:nil] animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//--------------------------------setting up navigation bar--------------------------------------

-(void)setupNavigationBar
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
    self.wantsFullScreenLayout=YES;
    
    
    self.navigationController.navigationBar.translucent=NO;
    
    
    UILabel *titleLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 19)];
    
    titleLable.backgroundColor=[UIColor clearColor];
    titleLable.text=@"Workout Goals";
    titleLable.font=[UIFont fontWithName:@"Arial" size:20.0];
    titleLable.textColor= [UIColor colorWithHue:31.0/360.0 saturation:99.0/100.0 brightness:87.0/100.0 alpha:1];
    
    self.navigationItem.titleView=titleLable;
    self.navigationItem.titleView.backgroundColor=[UIColor clearColor];
    float xSpace=SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")?-10.0f:-0.0f;
    
    
    UIView *backView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    
    UITapGestureRecognizer *tapBack=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goBack:)];
    tapBack.numberOfTapsRequired=1;
    [backView addGestureRecognizer:tapBack];
    [backView setBackgroundColor:[UIColor clearColor]];
    UIButton *backButtonCustom = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButtonCustom setFrame:CGRectMake(xSpace, 3.0f, 25.0f, 25.0f)];
    [backButtonCustom addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
   
    [backButtonCustom setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backView addSubview:backButtonCustom];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backView];
    
    
       [self.navigationItem setLeftBarButtonItem:backButton];
    
    
}
-(void)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


//--------------------------hiding keyboard---------------------------------
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //    for (UIView * txt in self.subviews){
    //        if (!([txt isKindOfClass:[UITextField class]] && [txt isFirstResponder])) {
    //            [self.view endEditing:YES];
    //        }
    //
    //    }
    
    [self.view endEditing:YES];
}



//-------------------------------Handle Goals RB checked change---------------------------------


-(void)setupGoalsRB
{
    //UIImage *imageUnchecked = [UIImage imageNamed:@"radoi.png"];
    UIImage *imageChecked = [UIImage imageNamed:@"radio-sel.png"];
    
    [self.milesRB setImage:imageChecked forState:UIControlStateSelected];
    [self.caloriesRB setImage:imageChecked forState:UIControlStateSelected];
    [self.durationRB setImage:imageChecked forState:UIControlStateSelected];
    
}
-(void)clearGoalType
{
    self.milesRB.selected=NO;
    self.caloriesRB.selected=NO;
    self.durationRB.selected=NO;
    [self clearText];
}
-(void)clearText
{
    self.milesTextField.text=@"";
    self.caloriesTextField.text=@"";
    self.durationTextField.text=@"";
}


- (IBAction)durationTFClicked:(id)sender
{
    [self clearText];
    [self clearGoalType];
    [self.durationRB setSelected:YES];
}
- (IBAction)caloriesTFClicked:(id)sender
{
    [self clearText];
    [self clearGoalType];
     [self.caloriesRB setSelected:YES];
}
- (IBAction)milesTFClicked:(id)sender
{
    [self clearText];
    [self clearGoalType];
     [self.milesRB setSelected:YES];
}


- (IBAction)durationRBClicked:(id)sender {
    
    if (!self.durationRB.selected) {
        
        
        [self clearGoalType];
        self.durationRB.selected=YES;
        [self.durationTextField becomeFirstResponder];
    }

}

- (IBAction)caloriesRBClicked:(id)sender {
    if (!self.caloriesRB.selected) {
        
        
        [self clearGoalType];
        self.caloriesRB.selected=YES;
        [self.caloriesTextField becomeFirstResponder];
    }
}

- (IBAction)milesRBClicked:(id)sender {
    
    if (!self.milesRB.selected) {
        [self clearGoalType];
        self.milesRB.selected=YES;
        [self.milesTextField becomeFirstResponder];
    }
}
- (IBAction)setNewWOGoal:(id)sender {
    
    if (self.milesRB.selected) {
        self.woGoal.goalType=MILES;
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        self.woGoal.goalValue=[f numberFromString:self.milesTextField.text];
        if ([self.woGoal.goalValue doubleValue]==0.0) {
            [ILAlertView showWithTitle:@"Error" message:@"Enter Proper Data" closeButtonTitle:@"OK" secondButtonTitle:nil tappedSecondButton:nil];
            [self.milesTextField becomeFirstResponder];
            return;
        }
        
    }
    else if (self.caloriesRB.selected)
    {
        self.woGoal.goalType=CALORIES;
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        self.woGoal.goalValue=[f numberFromString:self.caloriesTextField.text];
        if ([self.woGoal.goalValue doubleValue]==0.0) {
            [ILAlertView showWithTitle:@"Error" message:@"Enter Proper Data" closeButtonTitle:@"OK" secondButtonTitle:nil tappedSecondButton:nil];
            [self.caloriesTextField becomeFirstResponder];
            return;
        }
    }
    else if (self.durationRB.selected)
    {
        self.woGoal.goalType=DURATION;
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        self.woGoal.goalValue=[f numberFromString:self.durationTextField.text];
        if ([self.woGoal.goalValue doubleValue]==0.0) {
            [ILAlertView showWithTitle:@"Error" message:@"Enter Proper Data" closeButtonTitle:@"OK" secondButtonTitle:nil tappedSecondButton:nil];
            [self.durationTextField becomeFirstResponder];
            return;
        }
    }
    if ([self.woGoal saveWOGoal]) {
        [ILAlertView showWithTitle:@"Success" message:@"Goal Saved Successfully" closeButtonTitle:@"OK" secondButtonTitle:nil tappedSecondButton:nil];
    }
    else
    {
        [ILAlertView showWithTitle:@"Error" message:@"Error in Saving Goal" closeButtonTitle:@"OK" secondButtonTitle:nil tappedSecondButton:nil];
    }
    
}

@end
