//
//  ISHR.m
//  Fitness
//
//  Created by ispluser on 2/21/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import "ISHR.h"
#import "ISAppDelegate.h"

@implementation ISHR

+(ISHR*)hrWithHeartRate:(int)hr timestamp:(NSDate*)ts
{
    ISHR* temp=[[ISHR alloc]init];
    temp.hr=[NSNumber numberWithInt:hr];
    temp.timeStamp=ts;
    
    return temp;
}

+(BOOL)saveHRArray:(NSArray*)hrArray
{
    return [[(ISAppDelegate*)[[UIApplication sharedApplication]delegate] dbManager] saveHRArray:hrArray];
}

@end
