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

#define GOAL_SPEAK_VARIANCE 20.0
#define DISTANCE_SPEAK_VARIANCE 0.5
#define DURATION_SPEAK_VARIANCE 5
#define CALORIES_SPEAK_VARIANCE 50

@interface ISDashboardViewController ()

@end

@implementation ISDashboardViewController
{
    ISAppDelegate *appDel;
    double completed;
    double prevCompleted;
    
    double prevDistance;
    double prevCalories;
    double prevDuration;
    
    
    //------music player
    RNFrostedSidebar *callout;
    BOOL callouVisible;
    
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        appDel=(ISAppDelegate*)[[UIApplication sharedApplication]delegate];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupNavigationBar];
    [self setupMenuItemsTouchEvents];
    [self setupCallout];
    [appDel.woHandler.musicController setDelegate:self];
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
//------------------------------------music player support--------------------
-(void)setupCallout
{
    NSArray *images = @[
                        [UIImage imageNamed:@"artwork.jpeg"],
                        [UIImage imageNamed:@"prev.png"],
                        [UIImage imageNamed:@"play.png"],
                        [UIImage imageNamed:@"next.png"],
                        [UIImage imageNamed:@"add.png"]
                        ];
    NSArray *colors = @[
                        [UIColor colorWithRed:240/255.f green:159/255.f blue:254/255.f alpha:1],
                        [UIColor colorWithRed:240/255.f green:159/255.f blue:254/255.f alpha:1],
                        [UIColor colorWithRed:255/255.f green:137/255.f blue:167/255.f alpha:1],
                        [UIColor colorWithRed:126/255.f green:242/255.f blue:195/255.f alpha:1],
                        [UIColor colorWithRed:119/255.f green:152/255.f blue:255/255.f alpha:1]
                        ];
    
    
    callout = [[RNFrostedSidebar alloc] initWithImages:images selectedIndices:[NSMutableIndexSet indexSetWithIndex:PLAY_ITEM] borderColors:colors];
    callout.delegate = self;
    callout.showFromRight = YES;
    callouVisible=NO;
    
    
}
-(void)playerIsPlaying:(BOOL)b
{
    [callout.actionButtonImageView setHighlighted:b];
}

-(void)setArtworkImage:(UIImage*)img
{
    [callout.artworkImageView setImage:img];
}

- (IBAction)onBurger:(id)sender {
    
    
    if (!callouVisible) {
        [callout showInViewController:self animated:YES];
    }
    else
    {
        [callout dismissAnimated:YES];
    }
}
- (void)sidebar:(RNFrostedSidebar *)sidebar didShowOnScreenAnimated:(BOOL)animatedYesOrNo
{
    callouVisible=YES;
}

- (void)sidebar:(RNFrostedSidebar *)sidebar didDismissFromScreenAnimated:(BOOL)animatedYesOrNo
{
    callouVisible=NO;
}

#pragma mark - RNFrostedSidebarDelegate

- (void)sidebar:(RNFrostedSidebar *)sidebar didTapItemAtIndex:(NSUInteger)index {
    // NSLog(@"Tapped item at index %i",index);
    switch (index) {
        case ARTWORK_ITEM:
            break;
        case PREVIOUS_ITEM:
            [appDel.woHandler.musicController prevSong:nil];
            break;
        case PLAY_ITEM:
            [appDel.woHandler.musicController playOrPauseMusic:nil];
            break;
        case NEXT_ITEM:
            [appDel.woHandler.musicController nextSong:nil];
            break;
        case ADD_ITEM:
            [callout dismissAnimated:YES];
            [appDel.woHandler.musicController AddMusicOrShowMusic:nil];
            break;
        default:
            break;
    }
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
    prevCompleted=0.0;
    completed=0.0;
    prevDistance=0.0;
    prevCalories=0.0;
    prevDuration=0.0;
    self.woDurationLabel.text=@"- -";
    [self resetLocationRelatedLabels];
    if (appDel.woHandler.stepCounter!=nil) {
        self.stepsLabel.text=@"- -";
    }
    else
    {
        self.stepsLabel.text=@"n/a";
    }
    
    
    self.minSpeedLabel.text=@"- -";
    self.maxSpeedLabel.text=@"- -";
    if (appDel.woHandler.isDeviceConnected) {
     
        self.hrLabel.text=@"- -";
        self.maxHRLabel.text=@"- -";
        self.minHRLabel.text=@"- -";
        self.calBurnedLabel.text=@"- -";
    }
    else
    {
        self.hrLabel.text=@"n/a";
        self.calBurnedLabel.text=@"n/a";
        self.maxHRLabel.text=@"- -";
        self.minHRLabel.text=@"- -";
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
   
    UIButton *addButtonCustom = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButtonCustom setFrame:CGRectMake(0.0f, 0.0f, 25.0f, 25.0f)];
    [addButtonCustom addTarget:self action:@selector(onBurger:) forControlEvents:UIControlEventTouchUpInside];
    [addButtonCustom setImage:[UIImage imageNamed:@"music.png"] forState:UIControlStateNormal];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithCustomView:addButtonCustom];
    
    [self.navigationItem setRightBarButtonItem:addButton];

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
    [(UINavigationController*)[appDel drawerController].centerViewController pushViewController:[appDel getReportsViewControllerWithDateOptions:NO] animated:YES];
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
    self.maxHRLabel.text=[NSString stringWithFormat:@"%@ bpm",[maxHr stringValue] ];
    self.minHRLabel.text=[NSString stringWithFormat:@"%@ bpm",[minHr stringValue] ];
    
    if (appDel.woHandler.isWOStarted) {
        
        
        self.calBurnedLabel.text= [NSString stringWithFormat:@"%.2f kcal" ,[appDel.woHandler.currentWO.calBurned doubleValue]/1000];
        
        if (([appDel.woHandler.currentWO.calBurned doubleValue]-prevCalories)>=CALORIES_SPEAK_VARIANCE) {
            prevCalories=[appDel.woHandler.currentWO.calBurned doubleValue];
            [appDel.woHandler speakCalBurned:prevCalories];
        }
    }
    
    [self calculateGoalCompletion];
    
}

//-----------------------------handling location updates-------------------------------------
-(void)didUpdateLocation
{
   
    self.distanceLabel.text= [NSString stringWithFormat:@"%.2f Miles" ,[appDel.woHandler.currentWO.distance doubleValue]];
    if ([appDel.woHandler.currentWO.minSpeed doubleValue]>999.0 || [appDel.woHandler.currentWO.minSpeed doubleValue]< 0.00) {
        self.minSpeedLabel.text=[NSString stringWithFormat:@"- -"];
    }
    else
    {
        self.minSpeedLabel.text=[NSString stringWithFormat:@"%.1f mph",[appDel.woHandler.currentWO.minSpeed doubleValue] ];
    }
    if ([appDel.woHandler.currentWO.maxSpeed doubleValue]<=0.00) {
        self.maxSpeedLabel.text=[NSString stringWithFormat:@"- -"];
    }
    else
    {
        self.maxSpeedLabel.text=[NSString stringWithFormat:@"%.1f mph",[appDel.woHandler.currentWO.maxSpeed doubleValue] ];
    }
    
    if (([appDel.woHandler.currentWO.distance doubleValue]-prevDistance)>=DISTANCE_SPEAK_VARIANCE) {
        prevDistance=[appDel.woHandler.currentWO.distance doubleValue];
        [appDel.woHandler speakDistance:prevDistance];
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
        
        if ((ageComponents.minute -prevDuration)>=DURATION_SPEAK_VARIANCE) {
            prevDuration=ageComponents.minute;
            [appDel.woHandler speakDuration:prevDuration];
        }
        
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
        
        NSDateComponents *ageComponents = [[NSCalendar currentCalendar]
                                           components:NSMinuteCalendarUnit
                                           fromDate:appDel.woHandler.currentWO.startTimeStamp
                                           toDate:[NSDate date]
                                           options:0];
        
        switch (appDel.woHandler.woGoal.goalType) {
            case MILES:
                completed=([appDel.woHandler.currentWO.distance doubleValue])/[appDel.woHandler.woGoal.goalValue doubleValue]*100.0;
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
            [appDel.woHandler speakGoalValue:100];
            
        }
        
        else if ((completed-prevCompleted)>=GOAL_SPEAK_VARIANCE) {
            prevCompleted=completed;
            [appDel.woHandler speakGoalValue:completed];
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
