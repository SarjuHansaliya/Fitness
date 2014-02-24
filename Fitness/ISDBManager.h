//
//  ISDBManager.h
//  SampleCoreDataApplication
//
//  Created by ispluser on 2/4/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "ISUserDetails.h"
#import "ISWOGoal.h"
#import "ISHR.h"

@interface ISDBManager : NSObject
{
    NSString *databasePath;
}

+(ISDBManager*)getSharedInstance;
-(BOOL)createDB;
- (NSArray*) fetchUserProfileRecord;
- (NSArray*) fetchWOGoals;

-(BOOL) saveUserDetails:(ISUserDetails*)userDetails;
- (BOOL) saveWOGoal:(ISWOGoal*)woGoal;
- (BOOL) saveHRArray:(NSArray*)hrArray;
@end
