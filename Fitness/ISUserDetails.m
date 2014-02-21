//
//  ISUserDetails.m
//  Fitness
//
//  Created by ispluser on 2/21/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import "ISUserDetails.h"
#import "ISAppDelegate.h"

@implementation ISUserDetails


+(ISUserDetails*)userDetailsWithUserId:(int)userId name:(NSString *)name dob:(NSDate*)dob gender:(int)gender height:(NSNumber *)height weight:(NSNumber *)weight hr:(BOOL)hrMonitoring
{
    
    ISUserDetails *temp=[[ISUserDetails alloc]init];
    temp.userId=userId;
    temp.name=name;
    temp.DOB=dob;
    temp.gender=gender;
    temp.height=height;
    temp.weight=weight;
    temp.hrMonitoring=hrMonitoring;
    
    return temp;
}

+(ISUserDetails *)getUserDetails
{
    NSArray *fetchedDetails=[[(ISAppDelegate*)[[UIApplication sharedApplication]delegate] dbManager] fetchUserProfileRecord];
    
    if (fetchedDetails==nil || [fetchedDetails count]<1) {
        return  nil;
    }
    else
        return [fetchedDetails objectAtIndex:0];
}

-(BOOL)saveUserDetails
{
   return [[(ISAppDelegate*)[[UIApplication sharedApplication]delegate] dbManager] saveUserDetails:self];
}

@end
