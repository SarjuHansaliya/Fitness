//
//  ISWOGoal.m
//  Fitness
//
//  Created by ispluser on 2/21/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import "ISWOGoal.h"
#import "ISAppDelegate.h"
#import "ISDBManager.h"

@implementation ISWOGoal

+(ISWOGoal *)workOutGoalWithId:(int)woGoalId goalType:(int)goalType goalvalue:(NSNumber *)value
{
    ISWOGoal* temp=[[ISWOGoal alloc]init];
    
    temp.woGoalId=woGoalId;
    temp.goalType=goalType;
    temp.goalValue=value;
    
    return temp;
}

+(ISWOGoal *)getWOGoal
{
    NSArray *fetchedDetails=[[(ISAppDelegate*)[[UIApplication sharedApplication]delegate] dbManager] fetchWOGoals];
    
    if (fetchedDetails==nil || [fetchedDetails count]<1) {
        return  nil;
    }
    else
        return [fetchedDetails lastObject];
}

+(ISWOGoal *)getWOGoalWithId:(int)woGoalID
{
    NSArray *fetchedDetails=[[(ISAppDelegate*)[[UIApplication sharedApplication]delegate] dbManager] fetchWOGoals];
    
    for (ISWOGoal *g in fetchedDetails) {
        if (g.woGoalId==woGoalID) {
            return g;
        }
    }
    return nil;
}


-(BOOL)saveWOGoal
{
    return [[(ISAppDelegate*)[[UIApplication sharedApplication]delegate] dbManager] saveWOGoal:self];
}

@end
