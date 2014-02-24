//
//  ISWorkOutHandler.h
//  Fitness
//
//  Created by ispluser on 2/21/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISWOGoal.h"
#import "ISWorkOut.h"
#import "ISUserDetails.h"

@interface ISWorkOutHandler : NSObject


@property BOOL isWOGoalEnable;
@property ISWOGoal *woGoal;

@property BOOL isUserProfileSet;
@property ISUserDetails *userDetails;

@property BOOL isDeviceConnected;

@property BOOL isWOStarted;
@property ISWorkOut *currentWO;

+(ISWorkOutHandler*)getSharedInstance;


-(void)startWO;
-(void)stopWO;

@end
