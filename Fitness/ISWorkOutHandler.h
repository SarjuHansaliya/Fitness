//
//  ISWorkOutHandler.h
//  Fitness
//
//  Created by ispluser on 2/21/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISWOGoal.h"
#import "ISUserDetails.h"

@interface ISWorkOutHandler : NSObject


@property BOOL isWOGoalEnable;
@property ISWOGoal *woGoal;
@property BOOL isUserProfileSet;
@property ISUserDetails *userDetails;


+(ISWorkOutHandler*)getSharedInstance;

@end
