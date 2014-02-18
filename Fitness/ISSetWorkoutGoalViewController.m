//
//  ISSetWorkoutGoalViewController.m
//  Fitness
//
//  Created by ispluser on 2/12/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import "ISSetWorkoutGoalViewController.h"
#import "ISWorkoutRemindersViewController.h"
#import "ISAppDelegate.h"
#import "macros.h"

@interface ISSetWorkoutGoalViewController ()

@end

@implementation ISSetWorkoutGoalViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupGoalsRB];
    [self setupNavigationBar];
    [self setupViewWorkoutGoalsClickEvent];
    
    
   // self.navigationController.navigationBarHidden=YES;
    // Do any additional setup after loading the view from its nib.
}

//---------------------------------------setup onclick events---------------------
-(void)setupViewWorkoutGoalsClickEvent
{
    UITapGestureRecognizer *tapOnView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(displayReminders:)] ;
    tapOnView.numberOfTapsRequired=1;
    [self.openRemindersView addGestureRecognizer:tapOnView];
}
-(void) displayReminders:(id)sender
{

    [(UINavigationController*)[(ISAppDelegate *)[[UIApplication sharedApplication]delegate] drawerController].centerViewController pushViewController:[[ISWorkoutRemindersViewController alloc] initWithNibName:nil bundle:nil] animated:YES];
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
    [backView setBackgroundColor:[UIColor clearColor]];
    
    UIButton *backButtonCustom = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButtonCustom setFrame:CGRectMake(xSpace, 3.0f, 25.0f, 25.0f)];
    [backButtonCustom addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    [backButtonCustom setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backView addSubview:backButtonCustom];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backView];
    
   
   // [backButton setTintColor: [UIColor colorWithHue:31.0/360.0 saturation:99.0/100.0 brightness:87.0/100.0 alpha:1]];
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
@end
