//
//  ISMenuViewController.m
//  Fitness
//
//  Created by ispluser on 2/11/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import "ISMenuViewController.h"
#import "ISAppDelegate.h"
#import "macros.h"

@interface ISMenuViewController ()

@end

@implementation ISMenuViewController
{
    ISAppDelegate *appDel;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        appDel=(ISAppDelegate *)[[UIApplication sharedApplication]delegate];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
    self.wantsFullScreenLayout=YES;

    [self setupMenuItemsTouchEvents];
}
-(void)viewWillAppear:(BOOL)animated
{
    if (appDel.woHandler.isWOStarted) {
        self.userProfileView.hidden=YES;
    }
    else
        self.userProfileView.hidden=NO;
}

//----------------------------handling touch events on menu items---------------
-(void)setupMenuItemsTouchEvents
{
    UITapGestureRecognizer *tapOnWorkoutGoalView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(displayWorkoutGoals:)] ;
    tapOnWorkoutGoalView.numberOfTapsRequired=1;
    [self.workoutGoalsView addGestureRecognizer:tapOnWorkoutGoalView];
    
    UITapGestureRecognizer *tapOnHRView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(displayHRMonitor:)] ;
    tapOnHRView.numberOfTapsRequired=1;
    [self.hrMonitorView addGestureRecognizer:tapOnHRView];
    
    UITapGestureRecognizer *tapOnConnectionManagerView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(displayConnectionManager:)];
    tapOnConnectionManagerView.numberOfTapsRequired=1;
    [self.deviceConnectionManagerView addGestureRecognizer:tapOnConnectionManagerView];
    
    
    UITapGestureRecognizer *tapOnUserProfileView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(displayUserProfile:)];
    tapOnUserProfileView.numberOfTapsRequired=1;
    [self.userProfileView addGestureRecognizer:tapOnUserProfileView];
    
}
-(void) displayConnectionManager:(id)sender
{
    [[appDel drawerController] toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    [(UINavigationController*)[appDel drawerController].centerViewController pushViewController:[appDel getConnectionManagerViewController] animated:YES];
}


-(void) displayHRMonitor:(id)sender
{
    [[appDel drawerController] toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    [(UINavigationController*)[appDel drawerController].centerViewController pushViewController:[appDel getHRMonitorViewController] animated:YES];
}

-(void) displayWorkoutGoals:(id)sender
{
    [[appDel drawerController] toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    [(UINavigationController*)[appDel drawerController].centerViewController pushViewController:[appDel getSetWorkoutGoalViewController] animated:YES];
}
-(void) displayUserProfile:(id)sender
{
    [[appDel drawerController] toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
   
    [self presentViewController:[appDel getProfileViewController] animated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
