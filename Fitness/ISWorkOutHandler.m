//
//  ISWorkOutHandler.m
//  Fitness
//
//  Created by ispluser on 2/21/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import "ISWorkOutHandler.h"


@implementation ISWorkOutHandler


static ISWorkOutHandler *sharedInstance = nil;

+(ISWorkOutHandler*)getSharedInstance{
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone:NULL]init];
        [sharedInstance firstTime];
    }
    return sharedInstance;
}

-(void)firstTime
{
   
    self.userDetails=[ISUserDetails getUserDetails];
    if (self.userDetails==nil) {
        self.isUserProfileSet=NO;
        self.userDetails=[[ISUserDetails alloc]init];
    }
    else
        self.isUserProfileSet=YES;
    
    self.woGoal=[ISWOGoal getWOGoal];
    if (self.woGoal==nil) {
        self.isWOGoalEnable=NO;
        self.woGoal=[[ISWOGoal alloc]init];
    }
    else
        self.isWOGoalEnable=YES;
    
    self.isDeviceConnected=NO;
    self.isWOStarted=NO;
    
    
}

-(void)startWO
{
    self.isWOStarted=YES;
    self.currentWO=[[ISWorkOut alloc]init];
    self.currentWO.startTimeStamp=[NSDate date];
    
}
-(void)stopWO
{
    self.isWOStarted=NO;
    self.currentWO.endTimeStamp=[NSDate date];
}







@end
