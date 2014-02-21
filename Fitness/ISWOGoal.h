//
//  ISWOGoal.h
//  Fitness
//
//  Created by ispluser on 2/21/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ISWOGoal : NSObject

@property int woGoalId;
@property int goalType;
@property NSNumber *goalValue;


+(ISWOGoal *)workOutGoalWithId:(int)woGoalId goalType:(int)goalType goalvalue:(NSNumber *)value;
+(ISWOGoal *)getWOGoal;

-(BOOL)saveWOGoal;
@end
