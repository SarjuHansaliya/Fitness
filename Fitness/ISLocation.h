//
//  ISLocation.h
//  Fitness
//
//  Created by ispluser on 2/21/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ISLocation : CLLocation

+(ISLocation*)locationWithTimeStamp:(NSDate *)ts latitude:(double)lat longitude:(double)lon;
+(BOOL)saveLocationArray:(NSArray*)locationArray;
+(NSArray *)getLocationArrayWithStartTS:(NSDate *)startTS endTS:(NSDate*)endTS;

@end
