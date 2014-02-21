//
//  ISUserDetails.h
//  Fitness
//
//  Created by ispluser on 2/21/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ISUserDetails : NSObject


@property int userId;
@property NSString *name;
@property NSDate * DOB;
@property int gender;
@property NSNumber *height;
@property NSNumber *weight;
@property BOOL hrMonitoring;



+(ISUserDetails*)userDetailsWithUserId:(int)userId name:(NSString *)name dob:(NSDate*)dob gender:(int)gender height:(NSNumber *)height weight:(NSNumber *)weight hr:(BOOL)hrMonitoring;
+(ISUserDetails *)getUserDetails;
-(BOOL)saveUserDetails;


@end
