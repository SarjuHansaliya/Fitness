//
//  ISAppDelegate.h
//  Fitness
//
//  Created by ispluser on 2/6/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import "MMDrawerController.h"
#import "ISBluetooth.h"
#import "ISHRDistributor.h"
#import "ISDBManager.h"
#import "ISWorkOutHandler.h"

#import "ISSetWorkoutGoalViewController.h"
#import "ISHRMonitorViewController.h"
#import "ISConnectionManagerViewController.h"
#import "ISProfileViewController.h"
#import "ISReportsViewController.h"
#import "ISStatisticsViewController.h"



@interface ISAppDelegate : UIResponder <UIApplicationDelegate,ISBluetoothConnectionDelegate>

@property (strong, nonatomic) UIWindow *window;
@property MMDrawerController *drawerController;
@property ISBluetooth *bluetoothManager;
@property ISHRDistributor *hrDistributor;
@property (weak,atomic) ISDBManager *dbManager;
@property (weak,atomic) ISWorkOutHandler *woHandler;
@property EKCalendar *calendar;
@property EKEventStore *eventStore;
@property BOOL isCalendarAccessGranted;
@property BOOL isStepsCountingAvailable;

@property ISSetWorkoutGoalViewController *setWorkoutGoalViewController;
@property ISHRMonitorViewController *hrMonitorViewController;
@property ISConnectionManagerViewController *connectionManagerViewController;
@property ISProfileViewController *profileViewController;
@property ISReportsViewController *reportsViewController;
@property ISStatisticsViewController *statisticsViewController;


-(ISReportsViewController*)getReportsViewControllerWithDateOptions:(BOOL)showDatePicker;
-(ISSetWorkoutGoalViewController*)getSetWorkoutGoalViewController;
-(ISHRMonitorViewController*)getHRMonitorViewController;
-(ISConnectionManagerViewController*)getConnectionManagerViewController;
-(ISProfileViewController*)getProfileViewController;
-(ISStatisticsViewController*)getStatisticsViewController;


-(void)checkEventStoreAccessForCalendar;
-(void)resetAllObjects;

-(ISHRDistributor *)getHRDistributor;
-(ISBluetooth *)getBluetoothManager;
@end