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
#import "ILAlertView.h"
#import "MBProgressHUD.h"

@interface ISMenuViewController ()

@end

@implementation ISMenuViewController
{
    ISAppDelegate *appDel;
    MBProgressHUD *HUD;
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
        self.resetView.hidden=YES;
    }
    else
    {
        self.userProfileView.hidden=NO;
        self.resetView.hidden=NO;
    }
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
    
    
    UITapGestureRecognizer *tapOnWOReportsView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(displayReports:)];
    tapOnWOReportsView.numberOfTapsRequired=1;
    [self.woReportsView addGestureRecognizer:tapOnWOReportsView];
    
    UITapGestureRecognizer *tapOnResetView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resetAll)];
    tapOnResetView.numberOfTapsRequired=1;
    [self.resetView addGestureRecognizer:tapOnResetView];
    
    UITapGestureRecognizer *tapOnStatisticsView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewStatistics)];
    tapOnStatisticsView.numberOfTapsRequired=1;
    [self.statisticsView addGestureRecognizer:tapOnStatisticsView];
    
}
-(void)viewStatistics
{
    [[appDel drawerController] toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    [(UINavigationController*)[appDel drawerController].centerViewController pushViewController:[appDel getStatisticsViewController] animated:YES];
}

-(void)resetAll
{
    [ILAlertView showWithTitle:@"Confirmation Required" message:@"Do you really want to delete all data?" closeButtonTitle:@"NO" secondButtonTitle:@"YES" tappedSecondButton:^{
        
        HUD = [[MBProgressHUD alloc] initWithView:appDel.window];
        UIView * v=[[UIView alloc]initWithFrame:appDel.window.frame];
        [v setBackgroundColor:[UIColor colorWithWhite:0.4 alpha:0.7]];
        [appDel.window addSubview:v];
        [appDel.window addSubview:HUD];
        HUD.labelText = @"Deleting";
        [HUD showAnimated:YES whileExecutingBlock:^{
            [appDel.dbManager deleteAlldata];
            [self myMixedTask];
        } completionBlock:^{
            [appDel resetAllObjects];
        }];

        
    }];
}

- (void)myMixedTask {
	sleep(2);
	// Switch to determinate mode
	HUD.mode = MBProgressHUDModeDeterminate;
	HUD.labelText = @"Resetting";
	float progress = 0.0f;
	while (progress < 1.0f)
	{
		progress += 0.01f;
		HUD.progress = progress;
		usleep(20000);
	}
    // UIImageView is a UIKit class, we have to initialize it on the main thread
	__block UIImageView *imageView;
	dispatch_sync(dispatch_get_main_queue(), ^{
		UIImage *image = [UIImage imageNamed:@"37x-Checkmark.png"];
		imageView = [[UIImageView alloc] initWithImage:image];
	});
	HUD.customView = imageView ;
	HUD.mode = MBProgressHUDModeCustomView;
	HUD.labelText = @"Completed";
	sleep(2);
}


-(void) displayReports:(id)sender
{
    [[appDel drawerController] toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    [(UINavigationController*)[appDel drawerController].centerViewController pushViewController:[appDel getReportsViewControllerWithDateOptions:YES] animated:YES];
    
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
