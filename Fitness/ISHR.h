//
//  ISHR.h
//  Fitness
//
//  Created by ispluser on 2/21/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ISHR : NSObject

@property NSDate *timeStamp;
@property NSNumber *hr;


+(ISHR*)hrWithHeartRate:(int)hr timestamp:(NSDate*)ts;
+(BOOL)saveHRArray:(NSArray*)hrArray;
@end
