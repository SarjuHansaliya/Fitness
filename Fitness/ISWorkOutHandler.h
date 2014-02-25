//
//  ISWorkOutHandler.h
//  Fitness
//
//  Created by ispluser on 2/21/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "ISWOGoal.h"
#import "ISWorkOut.h"
#import "ISUserDetails.h"
#import "ISDashboardViewController.h"

@interface ISWorkOutHandler : NSObject <CLLocationManagerDelegate>

@property CLLocationManager *locationManager;
@property NSMutableArray * locations;

@property BOOL isWOGoalEnable;
@property ISWOGoal *woGoal;

@property BOOL isUserProfileSet;
@property ISUserDetails *userDetails;

@property BOOL isDeviceConnected;

@property BOOL isWOStarted;

@property ISWorkOut *currentWO;
@property (weak) ISDashboardViewController * dashBoardDelegate;


+(ISWorkOutHandler*)getSharedInstance;


-(void)startWO;
-(void)stopWO;

@end
