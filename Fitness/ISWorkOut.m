//
//  ISWorkOut.m
//  Fitness
//
//  Created by ispluser on 2/21/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import "ISWorkOut.h"
#import "ISAppDelegate.h"

@implementation ISWorkOut


+(ISWorkOut*)workoutWithwoId:(int)woId startTimeStamp:(NSDate*)startTimeStamp endTimeStamp:(NSDate*)endTimeStamp steps:(NSNumber*)steps calBurned:(NSNumber*)calBurned minSpeed:(NSNumber*)minSpeed maxSpeed:(NSNumber*)maxSpeed distance:(NSNumber*)distance woGoalId:(int)woGoalId
{
    
    ISWorkOut *temp=[[ISWorkOut alloc]init];
    temp.woId=woId;
    temp.startTimeStamp=startTimeStamp;
    temp.endTimeStamp=endTimeStamp;
    temp.steps=steps;
    temp.calBurned=calBurned;
    temp.minSpeed=minSpeed;
    temp.maxSpeed=maxSpeed;
    temp.distance=distance;
    temp.woGoalId=woGoalId;
    
    return temp;
}

+(NSArray *)getWorkouts
{
    return [[(ISAppDelegate*)[[UIApplication sharedApplication]delegate] dbManager] fetchAllWorkouts];
}

-(BOOL)saveNewWorkout
{
    return [[(ISAppDelegate*)[[UIApplication sharedApplication]delegate] dbManager] saveWorkout:self];
}
-(BOOL)updateWorkout
{
    return [[(ISAppDelegate*)[[UIApplication sharedApplication]delegate] dbManager] updateWorkout:self];
}
-(BOOL)deleteWorkout
{
    return [[(ISAppDelegate*)[[UIApplication sharedApplication]delegate] dbManager] deleteWorkout:self];
}


@end
