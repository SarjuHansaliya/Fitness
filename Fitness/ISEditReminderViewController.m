//
//  ISEditReminderViewController.m
//  Fitness
//
//  Created by ispluser on 2/17/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import "ISEditReminderViewController.h"

@interface ISEditReminderViewController ()

@end

@implementation ISEditReminderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        
    }
    return self;
}
-(ISReminderRepeatViewController*)getRepeatController
{
    if (self.repeatController==nil) {
        self.repeatController=[[ISReminderRepeatViewController alloc]initWithStyle:UITableViewStylePlain];
    }
    
    return self.repeatController;
}
-(ISReminderAlertViewController*)getAlertController
{
    if (self.alertController==nil) {
        self.alertController=[[ISReminderAlertViewController alloc]initWithStyle:UITableViewStylePlain];
    }
    
    return self.alertController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupGestureRecognizer];
    [self setupNavigationBar];
    
    self.toDateTextField.inputView=self.datePicker;
    self.toDateTextField.inputAccessoryView=self.accessoryView;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MMM dd , yyyy\t   hh:mm a"];
    
    self.toDateTextField.text=[formatter stringFromDate:[NSDate date]];
    
    
   
    
    
    
    
    
   
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    self.alertLabel.text = self.alertController.label;

}

//--------------------------------setting up navigation bar--------------------------------------



-(void)setupNavigationBar
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
    self.wantsFullScreenLayout=YES;
    
    
    self.navigationController.navigationBar.translucent=NO;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:254.0/255.0 green:247.0/255.0 blue:235.0/255.0 alpha:1.0]];
    }
    else
    {
        [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:254.0/255.0 green:247.0/255.0 blue:235.0/255.0 alpha:1.0]];
        
    }
    
    UILabel *titleLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 25)];
    
    titleLable.backgroundColor=[UIColor clearColor];
    titleLable.text=@"Edit Reminder";
    titleLable.font=[UIFont fontWithName:@"Arial" size:20.0];
    titleLable.textColor= [UIColor colorWithHue:31.0/360.0 saturation:99.0/100.0 brightness:87.0/100.0 alpha:1];
    
    self.navigationItem.titleView=titleLable;
    self.navigationItem.titleView.backgroundColor=[UIColor clearColor];
    
    
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 5, 38, 18)];
    
    UITapGestureRecognizer *tapOnCancel = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelClicked:)];
    tapOnCancel.numberOfTapsRequired=1;
    [leftView addGestureRecognizer:tapOnCancel];
    
    UILabel *leftLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 5, 38, 18)];
    
    leftLable.backgroundColor=[UIColor clearColor];
    leftLable.text=@"Cancel";
    leftLable.font=[UIFont fontWithName:@"Helvetica Neue" size:12.0];
    leftLable.textColor= [UIColor colorWithHue:31.0/360.0 saturation:99.0/100.0 brightness:87.0/100.0 alpha:1];

    [leftView addSubview:leftLable];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:leftView];
    [self.navigationItem setLeftBarButtonItem:leftButton];

    
    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 5, 38, 18)];
    
    UITapGestureRecognizer *tapOnSave = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(saveClicked:)];
    tapOnSave.numberOfTapsRequired=1;
    [rightView addGestureRecognizer:tapOnSave];
    
    UILabel *rightLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 5, 38, 18)];
    
    rightLable.backgroundColor=[UIColor clearColor];
    rightLable.text=@"Save";
    rightLable.font=[UIFont fontWithName:@"Helvetica Neue" size:12.0];
    rightLable.textColor= [UIColor colorWithHue:31.0/360.0 saturation:99.0/100.0 brightness:87.0/100.0 alpha:1];
    rightLable.textAlignment=NSTextAlignmentRight;
    
    [rightView addSubview:rightLable];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    [self.navigationItem setRightBarButtonItem:rightButton];
    
    
}



//--------------------------setting up gesture recognizer----------------------------

-(void)setupGestureRecognizer
{
    

    
    UITapGestureRecognizer *tapOnRepeat = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(repeatClicked:)];
    tapOnRepeat.numberOfTapsRequired=1;
    [self.repeatView addGestureRecognizer:tapOnRepeat];
    
    UITapGestureRecognizer *tapOnAlert = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(alertClicked:)];
    tapOnAlert.numberOfTapsRequired=1;
    [self.alertView addGestureRecognizer:tapOnAlert];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//------------------------------Events ------------------------------------



-(void)cancelClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)saveClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)repeatClicked:(id)sender
{
    
    [self.navigationController pushViewController:[self getRepeatController] animated:YES ];
}

-(void)alertClicked:(id)sender
{
    
    [self.navigationController pushViewController:[self getAlertController] animated:YES ];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
   
    [self.view endEditing:YES];
}

- (IBAction)doneEditing:(id)sender{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
   [formatter setDateFormat:@"MMM dd , yyyy\t   hh:mm a"];
    
   
        self.toDateTextField.text = [formatter stringFromDate: self.datePicker.date];
        [self.toDateTextField resignFirstResponder];
        
   
    
}


@end
