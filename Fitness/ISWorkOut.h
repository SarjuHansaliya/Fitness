//
//  ISWorkOut.h
//  Fitness
//
//  Created by ispluser on 2/21/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ISWorkOut : NSObject

@property int woId;
@property NSDate *startTimeStamp;
@property NSDate *endTimeStamp;
@property NSNumber *steps;
@property NSNumber *calBurned;
@property NSNumber *minSpeed;
@property NSNumber *maxSpeed;
@property NSNumber *distance;
@property int woGoalId;

+(ISWorkOut*)workoutWithwoId:(int)woId startTimeStamp:(NSDate*)startTimeStamp endTimeStamp:(NSDate*)endTimeStamp steps:(NSNumber*)steps calBurned:(NSNumber*)calBurned minSpeed:(NSNumber*)minSpeed maxSpeed:(NSNumber*)maxSpeed distance:(NSNumber*)distance woGoalId:(int)woGoalId;
+(NSArray *)getWorkouts;
+(NSArray *)getWorkoutsWithDate:(NSDate*)date;
-(BOOL)saveNewWorkout;
-(BOOL)updateWorkout;
-(BOOL)deleteWorkout;

@end
