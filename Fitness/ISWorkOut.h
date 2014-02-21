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

@end
