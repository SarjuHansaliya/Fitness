//
//  ISAppDelegate.m
//  Fitness
//
//  Created by ispluser on 2/6/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import "ISAppDelegate.h"
#import "ISProfileViewController.h"
#import "ISMenuViewController.h"
#import "ISDashboardViewController.h"
#import "MMExampleDrawerVisualStateManager.h"
#import "ISConnectionManagerViewController.h"
#import "ILAlertView.h"
#import "macros.h"
#import "MBProgressHUD.h"

#define DEVICE_RECONNECTION_TIMEOUT 5.0

@implementation ISAppDelegate

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    ISDashboardViewController *dashboardVC = [[ISDashboardViewController alloc]initWithNibName:nil bundle:nil];
    ISMenuViewController *menuVC = [[ISMenuViewController alloc]initWithNibName:nil bundle:nil];
    UINavigationController *dashboardNVC = [[UINavigationController alloc]initWithRootViewController:dashboardVC];
   
    
    self.drawerController= [[MMDrawerController alloc]initWithCenterViewController:dashboardNVC leftDrawerViewController:menuVC];
    
    
    [self.drawerController
     setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
         MMDrawerControllerDrawerVisualStateBlock block;
         block = [[MMExampleDrawerVisualStateManager sharedManager]
                  drawerVisualStateBlockForDrawerSide:drawerSide];
         if(block){
             block(drawerController, drawerSide, percentVisible);
         }
     }];
    
    // [[MMExampleDrawerVisualStateManager sharedManager] setLeftDrawerAnimationType:MMDrawerAnimationTypeSwingingDoor];
    
    [self.drawerController setShowsShadow:NO];
    [self.drawerController setMaximumLeftDrawerWidth:275.0];
    [self getBluetoothManager];
    self.dbManager=[ISDBManager getSharedInstance];
    self.woHandler=[ISWorkOutHandler getSharedInstance];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    if (![self.woHandler isUserProfileSet]) {
        ISProfileViewController *userProfile=[[ISProfileViewController alloc]initWithNibName:nil bundle:nil];
        userProfile.wantsFullScreenLayout = YES;
        [self.window setRootViewController:userProfile];
    }
    else
    {
        [self.window setRootViewController:self.drawerController];
    }
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") && [CMStepCounter isStepCountingAvailable]) {
        self.isStepsCountingAvailable=YES;
    }
    else
    {
        self.isStepsCountingAvailable=NO;
    }
    return YES;
}

-(void)resetAllObjects
{
    [ISWorkOutHandler reset];
    [self.eventStore removeCalendar:self.calendar commit:YES error:nil];
    self.drawerController=nil;
    self.bluetoothManager=nil;
    self.hrDistributor=nil;
    self.calendar=nil;
    self.eventStore=nil;
    self.setWorkoutGoalViewController=nil;
    self.hrMonitorViewController=nil;
    self.connectionManagerViewController=nil;
    self.profileViewController=nil;
    self.reportsViewController=nil;
    [self application:nil willFinishLaunchingWithOptions:nil];
    [self application:nil didFinishLaunchingWithOptions:nil];
    [MBProgressHUD hideAllHUDsForView:self.window animated:YES];
}

//------------------------initializing VC-------------------------------


-(ISSetWorkoutGoalViewController*)getSetWorkoutGoalViewController
{
    if (self.setWorkoutGoalViewController==nil) {
        self.setWorkoutGoalViewController=[[ISSetWorkoutGoalViewController alloc]initWithNibName:nil bundle:nil];
    }
    
    return self.setWorkoutGoalViewController;
}
-(ISHRMonitorViewController*)getHRMonitorViewController
{
    if (self.hrMonitorViewController==nil) {
        self.hrMonitorViewController=[[ISHRMonitorViewController alloc]initWithNibName:nil bundle:nil];
    }
    
    return self.hrMonitorViewController;
}
-(ISConnectionManagerViewController*)getConnectionManagerViewController
{
    if (self.connectionManagerViewController==nil) {
        self.connectionManagerViewController=[[ISConnectionManagerViewController alloc]initWithNibName:nil bundle:nil];
    }
    
    return self.connectionManagerViewController;
}
-(ISProfileViewController*)getProfileViewController
{
    if (self.profileViewController==nil) {
        self.profileViewController=[[ISProfileViewController alloc]initWithNibName:nil bundle:nil];
        self.profileViewController.wantsFullScreenLayout=YES;
         [self.profileViewController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    }
    
    return self.profileViewController;
}
-(ISReportsViewController*)getReportsViewControllerWithDateOptions:(BOOL)showDatePicker
{
    if (self.reportsViewController==nil) {
        self.reportsViewController=[[ISReportsViewController alloc]initWithStyle:UITableViewStylePlain];
    }
    self.reportsViewController.showDatePicker=showDatePicker;
    return self.reportsViewController;
}
-(ISStatisticsViewController*)getStatisticsViewController
{
    if (self.statisticsViewController==nil) {
        self.statisticsViewController=[[ISStatisticsViewController alloc]initWithNibName:nil bundle:nil];
    }
    
    return self.statisticsViewController;
}

-(ISHRDistributor *)getHRDistributor
{
    if (self.hrDistributor==nil) {
        self.hrDistributor=[[ISHRDistributor alloc]init];
        //setting intial hr values to avoid wrong interpretations
        [self.hrDistributor reset];
    }
    
    return self.hrDistributor;
}


-(ISBluetooth *)getBluetoothManager
{
    if (self.bluetoothManager==nil) {
        self.bluetoothManager=[[ISBluetooth alloc]init];
        self.bluetoothManager.connectionDelegate=self;
        self.bluetoothManager.notificationDelegate=[self getHRDistributor];
    }
    
    return self.bluetoothManager;
}
-(void)peripheralDidConnect
{
    self.woHandler.isDeviceConnected=YES;
}
-(void)peripheralDidDisconnect:(NSError *)error
{
    
    [self.hrDistributor saveData];
    self.woHandler.isDeviceConnected=NO;
    UIApplicationState state = [[UIApplication sharedApplication] applicationState];
    if (state == UIApplicationStateBackground || state==UIApplicationStateInactive)
    {
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = [NSDate date];
        localNotification.alertBody = @"Device Disconnected";
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.alertAction = @"View Details";
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.applicationIconBadgeNumber = 1;
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
    else if(state==UIApplicationStateActive)
    {
        [ILAlertView showWithTitle:[NSString stringWithFormat:@"Device Disconnected"]
                           message:@"Connect Another Device?"
                  closeButtonTitle:@"NO"
                 secondButtonTitle:@"Yes"
                tappedSecondButton:^{
                    [(UINavigationController*)self.drawerController.centerViewController popToRootViewControllerAnimated:NO];
                    [(UINavigationController*)[self drawerController].centerViewController pushViewController:[[ISConnectionManagerViewController alloc] initWithNibName:nil bundle:nil] animated:YES];
                }];
    }
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [self.woHandler saveCurrentWorkOut];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
     application.applicationIconBadgeNumber = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(EKEventStore *)getEventStore
{
    if (self.eventStore==nil) {
        self.eventStore=[[EKEventStore alloc]init];
       
    }
     self.isCalendarAccessGranted=NO;
    return self.eventStore;
}

// Check the authorization status of our application for Calendar
-(void)checkEventStoreAccessForCalendar
{
    [self getEventStore];
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeReminder];
    
    switch (status)
    {
            // Update our UI if the user has granted access to their Calendar
        case EKAuthorizationStatusAuthorized: [self accessGrantedForCalendar];
            break;
            // Prompt the user for access to Calendar if there is no definitive answer
        case EKAuthorizationStatusNotDetermined: [self requestCalendarAccess];
            break;
            // Display a message if the user has denied or restricted access to Calendar
        case EKAuthorizationStatusDenied:
        case EKAuthorizationStatusRestricted:
        {
            [ILAlertView showWithTitle:@"Privacy Warning" message:@"Permission was not granted for Calendar" closeButtonTitle:@"OK" secondButtonTitle:nil tappedSecondButton:nil];
        }
            break;
        default:
            break;
    }
}


// Prompt the user for access to their Calendar
-(void)requestCalendarAccess
{
    [self.eventStore requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError *error)
     {
         if (granted)
         {
             ISAppDelegate * __weak weakSelf = self;
             // Let's ensure that our code will be executed from the main queue
             dispatch_async(dispatch_get_main_queue(), ^{
                 [weakSelf accessGrantedForCalendar];
             });
         }
     }];
}


// This method is called when the user has granted permission to Calendar
-(void)accessGrantedForCalendar
{
    NSString *calendarIdentifier = [[NSUserDefaults standardUserDefaults] objectForKey:@"Calendar"];
    if (self.calendar==nil) {
        self.calendar = [self.eventStore calendarWithIdentifier:calendarIdentifier];
    }
    if (self.calendar==nil) {
        self.calendar=[self createCalendar];
    }
    self.isCalendarAccessGranted=YES;
}

-(EKCalendar*)createCalendar
{
    EKCalendar *calendar = [EKCalendar calendarForEntityType:EKEntityTypeReminder eventStore:self.eventStore];
    calendar.title = @"Fitness Calendar";
    
    EKSource *localSource = nil;
    EKSource *defaultSource = [self.eventStore defaultCalendarForNewReminders].source;
    
    if (defaultSource.sourceType == EKSourceTypeExchange) {
        localSource = defaultSource;
    } else {
        
        for (EKSource *source in self.eventStore.sources) {
            if (source.sourceType == EKSourceTypeLocal) {
                localSource = source;
                break;
            }
        }
        
    }
    
    if (localSource) {
        calendar.source = localSource;
    } else {
        NSLog(@"Error: no local sources available");
    }
    
    NSError *error = nil;
    BOOL result = [self.eventStore saveCalendar:calendar commit:YES error:&error];
    
    if (result) {
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:calendar.calendarIdentifier forKey:@"Calendar"];
        [userDefaults synchronize];
        
        NSLog(@"Saved calendar to event store");
        return calendar;
        
    } else {
        NSLog(@"Error saving Calendar");
    }
    return nil;
}


@end
