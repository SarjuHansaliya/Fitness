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
#import "ISProfileViewController.h"
#import "ILAlertView.h"




@interface ISDashboardViewController ()

@end

@implementation ISDashboardViewController
{
    ISAppDelegate *appDel;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        appDel=(ISAppDelegate*)[[UIApplication sharedApplication]delegate];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupNavigationBar];
    [self setupMenuItemsTouchEvents];
   
//    [appDel.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    [appDel.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    [[appDel getHRDistributor] setDashBoardDelegate:self];
    [appDel.woHandler setDashBoardDelegate:self];
    if (![[appDel woHandler] isUserProfileSet]) {
        ISProfileViewController *userProfile=[[ISProfileViewController alloc]initWithNibName:nil bundle:nil];
        userProfile.wantsFullScreenLayout = YES;
        
        [self presentViewController:userProfile animated:YES completion:nil];
    }
    [self resetLabels];
}
-(void)resetLocationRelatedLabels
{
    if ([CLLocationManager locationServicesEnabled]) {
        self.distanceLabel.text=@"- -";
        self.speedLabel.text=@"- -";
    }
    else
    {
        self.distanceLabel.text=@"n/a";
        self.speedLabel.text=@"n/a";
    }

}

-(void)resetLabels
{
    self.woDurationLabel.text=@"- -";
    [self resetLocationRelatedLabels];
    if (appDel.woHandler.stepCounter!=nil) {
        self.stepsLabel.text=@"- -";
    }
    else
    {
        self.stepsLabel.text=@"n/a";
    }
    
    
    self.minSpeedLabel.text=@"Min : - -";
    self.maxSpeedLabel.text=@"Max : - -";
    if (appDel.woHandler.isDeviceConnected) {
     
        self.hrLabel.text=@"- -";
        self.maxHRLabel.text=@"Max : - -";
        self.minHRLabel.text=@"Min : - -";
        self.calBurnedLabel.text=@"- -";
    }
    else
    {
        self.hrLabel.text=@"n/a";
        self.calBurnedLabel.text=@"n/a";
        self.maxHRLabel.text=@"";
        self.minHRLabel.text=@"";
    }
    if (appDel.woHandler.isWOGoalEnable) {
        self.goalLabel.text=@"0 %";
    }
    else
    {
        self.goalLabel.text=@"- -";
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    
    if (![[appDel woHandler] isUserProfileSet]) {
        ISProfileViewController *userProfile=[[ISProfileViewController alloc]initWithNibName:nil bundle:nil];
        userProfile.wantsFullScreenLayout = YES;
         [(UINavigationController*)[(ISAppDelegate *)[[UIApplication sharedApplication]delegate] drawerController] presentViewController:userProfile animated:YES completion:nil];
    }
    if (appDel.woHandler.isWOStarted) {
        [self didUpdateLocation];
    }
    
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
    
    
    
}
-(void) displayPathOnMap:(id)sender
{

    [(UINavigationController*)[appDel drawerController].centerViewController pushViewController:[[ISPathViewController alloc] initWithNibName:nil bundle:nil workout:appDel.woHandler.currentWO] animated:YES];
}
-(void) displayReport:(id)sender
{
    [(UINavigationController*)[appDel drawerController].centerViewController pushViewController:[appDel getReportsViewController] animated:YES];
}
//---------------------------------handling steps value change-------------------------
-(void)didUpdateStepsValue:(int)steps
{
    self.stepsLabel.text=[NSString stringWithFormat:@"%d",steps];
}

//---------------------------------handling heart value change-------------------------
-(void)didUpdateCurrentHeartRate:(NSNumber *)currHr maxHeartRate:(NSNumber *)maxHr minHeartRate:(NSNumber *)minHr
{
    self.hrLabel.text=[NSString stringWithFormat:@"%@ bpm",[currHr stringValue] ];
    self.maxHRLabel.text=[NSString stringWithFormat:@"Max - %@ bpm",[maxHr stringValue] ];
    self.minHRLabel.text=[NSString stringWithFormat:@"Min - %@ bpm",[minHr stringValue] ];
    
    if (appDel.woHandler.isWOStarted) {
        self.calBurnedLabel.text= [NSString stringWithFormat:@"%.2f kcal" ,[appDel.woHandler.currentWO.calBurned doubleValue]/1000];
    }
    
    [self calculateGoalCompletion];
    
}

//-----------------------------handling location updates-------------------------------------
-(void)didUpdateLocation
{
   
    self.distanceLabel.text= [NSString stringWithFormat:@"%.2f Miles" ,[appDel.woHandler.currentWO.distance doubleValue]];
    if ([appDel.woHandler.currentWO.minSpeed doubleValue]>999.0 || [appDel.woHandler.currentWO.minSpeed doubleValue]< 0.00) {
        self.minSpeedLabel.text=[NSString stringWithFormat:@"Min - mph"];
    }
    else
    {
        self.minSpeedLabel.text=[NSString stringWithFormat:@"Min - %.1f mph",[appDel.woHandler.currentWO.minSpeed doubleValue] ];
    }
    if ([appDel.woHandler.currentWO.maxSpeed doubleValue]<=0.00) {
        self.maxSpeedLabel.text=[NSString stringWithFormat:@"Max - mph"];
    }
    else
    {
        self.maxSpeedLabel.text=[NSString stringWithFormat:@"Max - %.1f mph",[appDel.woHandler.currentWO.maxSpeed doubleValue] ];
    }
    
    [self calculateSpeed];
    

    [self calculateGoalCompletion];
}
-(void)calculateSpeed
{
    NSDateComponents *ageComponents = [[NSCalendar currentCalendar]
                                       components:NSMinuteCalendarUnit
                                       fromDate:appDel.woHandler.currentWO.startTimeStamp
                                       toDate:[NSDate date]
                                       options:0];

   // NSLog(@"%@ %f",appDel.woHandler.currentWO.distance,ageComponents.minute/60.0);
    double speed=[appDel.woHandler.currentWO.distance doubleValue]/(ageComponents.minute/60.0);
    if (speed>=0.0 && ageComponents.minute!=0.0) {
        self.speedLabel.text=[NSString stringWithFormat:@"%.2f mph", speed];
    }
    else
        self.speedLabel.text=@"- -";
}

//--------------------------------------handling duration updates--------------------------
-(void)calculateWODuration
{
    
    if (!appDel.woHandler.isWOStarted) {
        return;
    }
    
    NSDateComponents *ageComponents = [[NSCalendar currentCalendar]
                                       components:NSMinuteCalendarUnit
                                       fromDate:appDel.woHandler.currentWO.startTimeStamp
                                       toDate:[NSDate date]
                                       options:0];
    
    self.woDurationLabel.text=[NSString stringWithFormat:@"%d Min",ageComponents.minute];
    [self calculateGoalCompletion];
    if (appDel.woHandler.isWOStarted) {
        
        //[self calculateSpeed];
        [self performSelector:@selector(calculateWODuration) withObject:nil afterDelay:60.0];
    }
}


//-----------------------------------calculating goal completion-------------------------------

-(void)calculateGoalCompletion
{
    if (!appDel.woHandler.isWOStarted) {
        return;
    }
    
    if (appDel.woHandler.isWOGoalEnable) {
        
        double completed=0.0;
        NSDateComponents *ageComponents = [[NSCalendar currentCalendar]
                                           components:NSMinuteCalendarUnit
                                           fromDate:appDel.woHandler.currentWO.startTimeStamp
                                           toDate:[NSDate date]
                                           options:0];
        
        switch (appDel.woHandler.woGoal.goalType) {
            case MILES:
                
                break;
                
            case CALORIES:
                
                completed=([appDel.woHandler.currentWO.calBurned doubleValue]/1000)/[appDel.woHandler.woGoal.goalValue doubleValue]*100.0;
                break;
                
            case DURATION:
                
                completed=(double)ageComponents.minute /[appDel.woHandler.woGoal.goalValue doubleValue]*100.0;
                break;
                
        }
        
        
        if (completed>100.0) {
            completed=100.0;
        }
        
        self.goalLabel.text=[NSString stringWithFormat:@"%.0f %%",completed];
       
        if (completed>=100) {
            
            UIApplicationState state = [[UIApplication sharedApplication] applicationState];
            if (state == UIApplicationStateBackground || state==UIApplicationStateInactive)
            {
                
                UILocalNotification* localNotification = [[UILocalNotification alloc] init];
                localNotification.fireDate = [NSDate date];
                localNotification.alertBody = @"Workout Goal Completed";
                localNotification.timeZone = [NSTimeZone defaultTimeZone];
                localNotification.alertAction = @"View Details";
                localNotification.soundName = UILocalNotificationDefaultSoundName;
                localNotification.applicationIconBadgeNumber = 1;
                [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
            }
            else if(state==UIApplicationStateActive)
            {
                [ILAlertView showWithTitle:[NSString stringWithFormat:@"Success"]
                                   message:@"Workout Goal Completed"
                          closeButtonTitle:@"OK"
                         secondButtonTitle:nil
                        tappedSecondButton:nil];
            }
            
            [self.startWOButton setTitle:@"Start Workout" forState:UIControlStateNormal];
            [appDel.woHandler stopWO];
        }
        
    }
    else
    {
        self.goalLabel.text=@"- -";
    }
}

- (IBAction)workoutStart:(id)sender {
    
    if ([self.startWOButton.titleLabel.text isEqualToString:@"Start Workout"]) {
        [self resetLabels];
        [self.startWOButton setTitle:@"Stop Workout" forState:UIControlStateNormal];
        [appDel.woHandler startWO];
        [self calculateWODuration];
        [self calculateGoalCompletion];
    }
    else
    {
        [self.startWOButton setTitle:@"Start Workout" forState:UIControlStateNormal];
        [appDel.woHandler stopWO];
    }
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}






















@end
