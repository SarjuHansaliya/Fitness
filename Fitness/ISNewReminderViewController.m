//
//  ISNewReminderViewController.m
//  Fitness
//
//  Created by ispluser on 2/17/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import "ISNewReminderViewController.h"

@interface ISNewReminderViewController ()

@end

@implementation ISNewReminderViewController

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
    [self setupGestureRecognizer];
    // Do any additional setup after loading the view from its nib.
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
    titleLable.text=@"New Reminder";
    titleLable.font=[UIFont fontWithName:@"Arial" size:20.0];
    titleLable.textColor= [UIColor colorWithHue:31.0/360.0 saturation:99.0/100.0 brightness:87.0/100.0 alpha:1];
    
    self.navigationItem.titleView=titleLable;
    self.navigationItem.titleView.backgroundColor=[UIColor clearColor];
    
    
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 38, 15)];
    
    UITapGestureRecognizer *tapOnCancel = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelClicked:)];
    tapOnCancel.numberOfTapsRequired=1;
    [leftView addGestureRecognizer:tapOnCancel];
    
    UILabel *leftLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 38, 15)];
    
    leftLable.backgroundColor=[UIColor clearColor];
    leftLable.text=@"Cancel";
    leftLable.font=[UIFont fontWithName:@"Helvetica Neue" size:12.0];
    leftLable.textColor= [UIColor colorWithHue:31.0/360.0 saturation:99.0/100.0 brightness:87.0/100.0 alpha:1];
    
    [leftView addSubview:leftLable];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:leftView];
    [self.navigationItem setLeftBarButtonItem:leftButton];
    
    
    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 38, 15)];
    
    UITapGestureRecognizer *tapOnSave = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(saveClicked:)];
    tapOnSave.numberOfTapsRequired=1;
    [rightView addGestureRecognizer:tapOnSave];
    
    UILabel *rightLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 38, 15)];
    
    rightLable.backgroundColor=[UIColor clearColor];
    rightLable.text=@"Save";
    rightLable.font=[UIFont fontWithName:@"Helvetica Neue" size:12.0];
    rightLable.textColor= [UIColor colorWithHue:31.0/360.0 saturation:99.0/100.0 brightness:87.0/100.0 alpha:1];
    
    [rightView addSubview:rightLable];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    [self.navigationItem setRightBarButtonItem:rightButton];
    
    
}


//--------------------------setting up gesture recognizer----------------------------


-(void)setupGestureRecognizer
{
    
    
    UITapGestureRecognizer *tapOnStart = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(startClicked:)];
    tapOnStart.numberOfTapsRequired=1;
    [self.startView addGestureRecognizer:tapOnStart];
    
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
-(void)startClicked:(id)sender
{
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.datePicker.alpha = 1.0 - self.datePicker.alpha;
                         self.datePicker.frame = CGRectMake(0, 354, 320, 216);
                         
                     }
                     completion:nil];
    
    
}


@end
