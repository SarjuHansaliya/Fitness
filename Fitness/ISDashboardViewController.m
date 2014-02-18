//
//  ISDashboardViewController.m
//  Fitness
//
//  Created by ispluser on 2/11/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import "ISDashboardViewController.h"
#import "ISAppDelegate.h"
#import "macros.h"
#import "MMDrawerBarButtonItem.h"
#import "ISPathViewController.h"
#import "ISReportsViewController.h"

@interface ISDashboardViewController ()

@end

@implementation ISDashboardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated
{
    ISAppDelegate *appDel=[[UIApplication sharedApplication]delegate];
    [appDel.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [appDel.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupNavigationBar];
    [self setupMenuItemsTouchEvents];
       
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
    
   
    
    UIView *backView =[[UIView alloc] initWithFrame:CGRectMake(0, 20, 200, 80)];
    [backView setBackgroundColor:[UIColor greenColor]];
    UILabel *titleLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 27)];
    titleLable.backgroundColor=[UIColor clearColor];
    titleLable.text=@"Dashboard";
    titleLable.font=[UIFont fontWithName:@"Arial" size:20.0];
    titleLable.textColor= [UIColor colorWithHue:31.0/360.0 saturation:99.0/100.0 brightness:87.0/100.0 alpha:1];
    
    
    
    [backView addSubview:titleLable];
    self.navigationItem.titleView=titleLable;
    self.navigationItem.titleView.backgroundColor=[UIColor clearColor];
    //self.navigationController.navigationBarHidden=YES;
    self.title=@"Dashboard";
    UIImage *backImage=[UIImage imageNamed:@"back.png"];
    [self.navigationItem.backBarButtonItem setImage:backImage];
    [self setupLeftMenuButton];
    
}
-(void)setupLeftMenuButton{
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:NO];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        [leftDrawerButton setTintColor: [UIColor colorWithHue:31.0/360.0 saturation:99.0/100.0 brightness:87.0/100.0 alpha:1]];
    }
    
}
-(void)leftDrawerButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    
}

//----------------------------handling touch events on items---------------
-(void)setupMenuItemsTouchEvents
{
    UITapGestureRecognizer *tapOnMapView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(displayPathOnMap:)] ;
    tapOnMapView.numberOfTapsRequired=1;
    [self.mapPathView addGestureRecognizer:tapOnMapView];
    
    UITapGestureRecognizer *tapOnReportView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(displayReport:)] ;
    tapOnReportView.numberOfTapsRequired=1;
    [self.reportView addGestureRecognizer:tapOnReportView];
    
    UITapGestureRecognizer *tapOnStartWorkOutView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(workoutButtonClicked:)];
    tapOnStartWorkOutView.numberOfTapsRequired=1;
    [self.startWorkoutView addGestureRecognizer:tapOnStartWorkOutView];
    
    
}
-(void) displayPathOnMap:(id)sender
{

    [(UINavigationController*)[(ISAppDelegate *)[[UIApplication sharedApplication]delegate] drawerController].centerViewController pushViewController:[[ISPathViewController alloc] initWithNibName:nil bundle:nil] animated:YES];
}
-(void) displayReport:(id)sender
{
    [(UINavigationController*)[(ISAppDelegate *)[[UIApplication sharedApplication]delegate] drawerController].centerViewController pushViewController:[[ISReportsViewController alloc] initWithNibName:nil bundle:nil] animated:YES];
}
-(void) workoutButtonClicked:(id)sender
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
