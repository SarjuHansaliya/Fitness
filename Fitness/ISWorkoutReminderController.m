//
//  ISWorkoutReminderController.m
//  Fitness
//
//  Created by ispluser on 2/20/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import "ISWorkoutReminderController.h"
#import "ISEditReminderViewController.h"
#import "ISNewReminderViewController.h"
#import "macros.h"
#import "ISAppDelegate.h"
#import "ILAlertView.h"

@interface ISWorkoutReminderController ()

@end

@implementation ISWorkoutReminderController
{
    ISAppDelegate *appDel;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        appDel=(ISAppDelegate*)[[UIApplication sharedApplication]delegate];
        [appDel checkEventStoreAccessForCalendar];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupNavigationBar];
    self.remindersTableVC=[[ISWorkoutRemindersViewController alloc]initWithStyle:UITableViewStylePlain];
    [self addChildViewController:self.remindersTableVC];
    [self.remindersView addSubview:self.remindersTableVC.tableView];
}
-(void)viewDidAppear:(BOOL)animated
{
    CGRect rect = self.remindersTableVC.tableView.frame;
    rect.size.height = self.remindersView.frame.size.height;
    rect.origin.y=0.0;
    [self.remindersTableVC.tableView setFrame:rect];

}
//--------------------------------setting up navigation bar--------------------------------------

-(void)setupNavigationBar
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
    self.wantsFullScreenLayout=YES;
    
    
    self.navigationController.navigationBar.translucent=NO;
    
    UILabel *titleLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 19)];
    
    titleLable.backgroundColor=[UIColor clearColor];
    titleLable.text=@"Workout Reminder";
    titleLable.font=[UIFont fontWithName:@"Arial" size:20.0];
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
    
    
    UIButton *addButtonCustom = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButtonCustom setFrame:CGRectMake(0.0f, 0.0f, 25.0f, 25.0f)];
    [addButtonCustom addTarget:self action:@selector(addNewReminder:) forControlEvents:UIControlEventTouchUpInside];
    [addButtonCustom setImage:[UIImage imageNamed:@"new.png"] forState:UIControlStateNormal];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithCustomView:addButtonCustom];
    
    // [backButton setTintColor: [UIColor colorWithHue:31.0/360.0 saturation:99.0/100.0 brightness:87.0/100.0 alpha:1]];
    [self.navigationItem setLeftBarButtonItem:backButton];
    if (appDel.isCalendarAccessGranted) {
        [self.navigationItem setRightBarButtonItem:addButton];
    }
    
    
}
-(void)addNewReminder:(id)sender
{
    ISNewReminderViewController *newReminder=[[ISNewReminderViewController alloc]initWithNibName:nil bundle:nil];
    newReminder.wantsFullScreenLayout = YES;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:newReminder];
    
    [self presentViewController:nav animated:YES completion:nil];
    
}
-(void)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)deleteReminderButtonClicked:(id)sender {
    
    if (self.remindersTableVC.selectedReminderIndex!=nil) {
    
        [ILAlertView showWithTitle:@"Delete" message:@"Are you sure, you want to delete reminder?" closeButtonTitle:@"NO" secondButtonTitle:@"YES" tappedSecondButton:^{
            [self.remindersTableVC deleteCell];
        }];
        
    }
    else
    {
        [ILAlertView showWithTitle:@"Warning" message:@"Please Select Reminder" closeButtonTitle:@"OK" secondButtonTitle:nil tappedSecondButton:nil];
        
    }
    
}

- (IBAction)editReminderButtonClicked:(id)sender {
    if (self.remindersTableVC.selectedReminderIndex!=nil) {
        
        ISEditReminderViewController *editReminder=[[ISEditReminderViewController alloc]initWithNibName:nil bundle:nil workoutReminder:[self.remindersTableVC.reminders objectAtIndex:self.remindersTableVC.selectedReminderIndex.row]];
        editReminder.wantsFullScreenLayout = YES;
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:editReminder];
        
        [self presentViewController:nav animated:YES completion:nil];
    }
    
    
}
@end
