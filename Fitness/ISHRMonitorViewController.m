//
//  ISHRMonitorViewController.m
//  Fitness
//
//  Created by ispluser on 2/14/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import "ISHRMonitorViewController.h"
#import "macros.h"

@interface ISHRMonitorViewController ()

@end

@implementation ISHRMonitorViewController

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
    [self setupNavigationBar];
    [self setupTextFields];
    
   
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//--------------------------------setting up textfields--------------------------------------

-(void)setupTextFields
{
    
    
    UIView *fromView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 15)];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 15 , 15)];
    [btn addTarget:self action:@selector(buttonFromDateClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"date.png"] forState:UIControlStateNormal];
    
    [fromView addSubview:btn];
    
    self.fromDateTextField.inputView = self.datePicker;
    self.fromDateTextField.inputAccessoryView=self.accessoryView;
    self.fromDateTextField.rightView = fromView;
    self.fromDateTextField.rightViewMode=UITextFieldViewModeAlways;

    
    
    UIView *toView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 15)];
   
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 15 , 15)];
    [btn1 addTarget:self action:@selector(buttonToDateClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn1 setImage:[UIImage imageNamed:@"date.png"] forState:UIControlStateNormal];
    
    [toView addSubview:btn1];
    
    self.toDateTextField.inputView=self.datePicker;
    self.toDateTextField.inputAccessoryView=self.accessoryView;
    self.toDateTextField.rightView = toView;
    self.toDateTextField.rightViewMode=UITextFieldViewModeAlways;

    
}
//--------------------------------setting up navigation bar--------------------------------------

-(void)setupNavigationBar
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
    self.wantsFullScreenLayout=YES;
    
    
    self.navigationController.navigationBar.translucent=NO;
    
    
    UILabel *titleLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 27)];
    
    titleLable.backgroundColor=[UIColor clearColor];
    titleLable.text=@"Heart Rate Monitoring";
    titleLable.font=[UIFont fontWithName:@"HelveticaWorld-Regular" size:20.0];
    titleLable.textColor= [UIColor colorWithHue:31.0/360.0 saturation:99.0/100.0 brightness:87.0/100.0 alpha:1];
    
    self.navigationItem.titleView=titleLable;
    self.navigationItem.titleView.backgroundColor=[UIColor clearColor];
    float xSpace=SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")?-10.0f:-0.0f;
    
    
    UIView *backView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [backView setBackgroundColor:[UIColor clearColor]];
    UITapGestureRecognizer *tapBack=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goBack:)];
    tapBack.numberOfTapsRequired=1;
    [backView addGestureRecognizer:tapBack];
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
//------------------------------------------------------------------------------------------------

- (IBAction)buttonToDateClicked:(id)sender {

    [self.toDateTextField becomeFirstResponder];
    
}

- (IBAction)buttonFromDateClicked:(id)sender {
    [self.fromDateTextField becomeFirstResponder];
    
}
- (IBAction)doneEditing:(id)sender {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH:mm dd/MM/yy"];
    
    if([self.toDateTextField isFirstResponder])
    {
        self.toDateTextField.text = [formatter stringFromDate: self.datePicker.date];
        [self.toDateTextField resignFirstResponder];

        
    }
    else if ([self.fromDateTextField isFirstResponder])
    {
        self.fromDateTextField.text = [formatter stringFromDate: self.datePicker.date];
        [self.fromDateTextField resignFirstResponder];

        
    }
    
    
    
}

@end
