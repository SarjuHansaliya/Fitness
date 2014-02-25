//
//  ISLocation.m
//  Fitness
//
//  Created by ispluser on 2/21/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import "ISLocation.h"
#import "ISAppDelegate.h"

@implementation ISLocation


+(ISLocation*)locationWithTimeStamp:(NSDate *)ts latitude:(double)lat longitude:(double)lon
{
    ISLocation *temp=[[ISLocation alloc]initWithCoordinate:CLLocationCoordinate2DMake(lat, lon) altitude:0.0 horizontalAccuracy:0.0 verticalAccuracy:0.0 timestamp:ts];
    
    return temp;
    
}

+(BOOL)saveLocationArray:(NSArray*)locationArray
{
    return [[(ISAppDelegate*)[[UIApplication sharedApplication]delegate] dbManager] saveLocationArray:locationArray];
}

+(NSArray *)getLocationArrayWithStartTS:(NSDate *)startTS endTS:(NSDate*)endTS
{
    return [[(ISAppDelegate*)[[UIApplication sharedApplication]delegate] dbManager] fetchLocationWithStartTS:startTS endTS:endTS];
}

@end
