//
//  ISMenuViewController.m
//  Fitness
//
//  Created by ispluser on 2/11/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import "ISMenuViewController.h"
#import "ISAppDelegate.h"
#import "ISSetWorkoutGoalViewController.h"
#import "ISHRMonitorViewController.h"
#import "ISConnectionManagerViewController.h"
#import "ISUserProfileViewController.h"
#import "macros.h"

@interface ISMenuViewController ()

@end

@implementation ISMenuViewController

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
   [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
    self.wantsFullScreenLayout=YES;

    [self setupMenuItemsTouchEvents];
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
    [[(ISAppDelegate *)[[UIApplication sharedApplication]delegate] drawerController] toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    [(UINavigationController*)[(ISAppDelegate *)[[UIApplication sharedApplication]delegate] drawerController].centerViewController pushViewController:[[ISConnectionManagerViewController alloc] initWithNibName:nil bundle:nil] animated:YES];
}


-(void) displayHRMonitor:(id)sender
{
    [[(ISAppDelegate *)[[UIApplication sharedApplication]delegate] drawerController] toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    [(UINavigationController*)[(ISAppDelegate *)[[UIApplication sharedApplication]delegate] drawerController].centerViewController pushViewController:[[ISHRMonitorViewController alloc] initWithNibName:nil bundle:nil] animated:YES];
}

-(void) displayWorkoutGoals:(id)sender
{
    [[(ISAppDelegate *)[[UIApplication sharedApplication]delegate] drawerController] toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    [(UINavigationController*)[(ISAppDelegate *)[[UIApplication sharedApplication]delegate] drawerController].centerViewController pushViewController:[[ISSetWorkoutGoalViewController alloc] initWithNibName:nil bundle:nil] animated:YES];
}
-(void) displayUserProfile:(id)sender
{
    [[(ISAppDelegate *)[[UIApplication sharedApplication]delegate] drawerController] toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    ISUserProfileViewController *userProfile=[[ISUserProfileViewController alloc]initWithNibName:nil bundle:nil];
    userProfile.wantsFullScreenLayout = YES;
    
    [self presentViewController:userProfile animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
