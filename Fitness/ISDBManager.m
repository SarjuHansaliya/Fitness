//
//  ISDBManager.m
//  SampleCoreDataApplication
//
//  Created by ispluser on 2/4/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import "ISDBManager.h"

typedef enum USER_DETAILS
{
    USER_ID,
    USER_NAME,
    USER_DOB,
    USER_GENDER,
    USER_HEIGHT,
    USER_WEIGHT,
    USER_HR_MONITORING
    
}USER_DETAILS_Table;

typedef enum HR_DETAILS
{
    HR_TIMESTAMP,
    HR_HR
    
}HR_DETAILS_TABLE;

typedef enum WO_GOAL
{
    GOAL_ID,
    GOAL_TYPE,
    GOAL_VALUE
    
}WO_GOAL_TABLE;

typedef enum LOCATION_DETAILS
{
    LOCATION_TIMESTAMP,
    LOCATION_LATITUDE,
    LOCATION_LONGITUDE
    
}LOCATION_DETAILS_TABLE;

typedef enum WO_DETAILS
{
    WO_ID,
    WO_START_TIMESTAMP,
    WO_END_TIMESTAMP,
    WO_STEPS,
    WO_CALORIES_BURNED,
    WO_MIN_SPEED,
    WO_MAX_SPEED,
    WO_DISTANCE,
    WO_GOAL_ID
    
}WO_DETAILS_TABLE;




@implementation ISDBManager


static ISDBManager *sharedInstance = nil;
static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;



+(ISDBManager*)getSharedInstance{
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone:NULL]init];
        [sharedInstance createDB];
    }
    return sharedInstance;
}

-(BOOL)createDB{
    NSString *docsDir;
    NSArray *dirPaths;
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString:
                    [docsDir stringByAppendingPathComponent: @"fitness.db"]];
    BOOL isSuccess = YES;
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if ([filemgr fileExistsAtPath: databasePath ] == NO)
    {
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &database) == SQLITE_OK)
        {
            char *errMsg;
            //----------------------------user details table---------------------------
            const char *sql_stmt ="pragma foreign_keys=ON";
            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)
                != SQLITE_OK)
            {
                isSuccess = NO;
                NSLog(@"Failed to update pragma");
            }
            
            sql_stmt ="create table if not exists user_details (user_id integer primary key AUTOINCREMENT,name text not null,dob integer not null,gender integer not null, height real not null,weight real not null,hr_monitoring integer not null)";
            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)
                != SQLITE_OK)
            {
                isSuccess = NO;
                NSLog(@"Failed to create table user_details");
            }
            
            
            
            //----------------------------hr details table---------------------------
            sql_stmt ="pragma foreign_keys=ON";
            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)
                != SQLITE_OK)
            {
                isSuccess = NO;
                NSLog(@"Failed to update pragma");
            }
            sql_stmt ="create table if not exists hr_details (timestamp integer primary key,hr int not null)";
            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)
                != SQLITE_OK)
            {
                isSuccess = NO;
                NSLog(@"Failed to create table he_details");
            }
            
            //----------------------------wo goal details table---------------------------
            sql_stmt ="pragma foreign_keys=ON";
            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)
                != SQLITE_OK)
            {
                isSuccess = NO;
                NSLog(@"Failed to update pragma");
            }
            
            sql_stmt ="create table if not exists wo_goal_details (goal_id integer primary key AUTOINCREMENT,goal_type integer not null,goal_value real not null)";
            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)
                != SQLITE_OK)
            {
                isSuccess = NO;
                NSLog(@"Failed to create table wo_goal_details");
            }
            
            
            
            //----------------------------location details table---------------------------
            sql_stmt ="pragma foreign_keys=ON";
            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)
                != SQLITE_OK)
            {
                isSuccess = NO;
                NSLog(@"Failed to update pragma");
            }
            
            sql_stmt ="create table if not exists location_details (timestamp integer primary key ,latitude real not null,longitude real not null)";
            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)
                != SQLITE_OK)
            {
                isSuccess = NO;
                NSLog(@"Failed to create table location_details");
            }
            
            //----------------------------wo details table---------------------------
            sql_stmt ="pragma foreign_keys=ON";
            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)
                != SQLITE_OK)
            {
                isSuccess = NO;
                NSLog(@"Failed to update pragma");
            }
            
            sql_stmt ="create table if not exists wo_details (wo_id integer primary key AUTOINCREMENT,start_timestamp int not null,end_timestamp integer not null,steps integer not null, calories_burned real not null,min_speed real not null,max_speed real not null,distance real not null, goal_id integer)";
            //sql_stmt ="create table if not exists wo_details (wo_id integer primary key AUTOINCREMENT,start_timestamp int not null,end_timestamp integer not null,steps integer not null, calories_burned real not null,min_speed real not null,max_speed real not null,distance real not null, goal_id integer, foreign key(goal_id)  REFERENCES wo_goal_details(goal_id) on delete cascade)";
            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)
                != SQLITE_OK)
            {
                isSuccess = NO;
                NSLog(@"Failed to create table wo_details");
            }

            
            
            sqlite3_close(database);
            return  isSuccess;
        }
        else {
            isSuccess = NO;
            NSLog(@"Failed to open/create database");
        }
    }
    return isSuccess;
}



//-----------------------handling userdetails----------------------------------------------

- (BOOL) saveUserDetails:(ISUserDetails*)userDetails
{
    NSArray *resultArray=[self fetchUserProfileRecord];
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {

        NSString* statementStr;
        
        statementStr = @"BEGIN EXCLUSIVE TRANSACTION";
        
        if (sqlite3_prepare_v2(database, [statementStr UTF8String], -1, &statement, NULL) != SQLITE_OK) {
            NSLog(@"db error: %s\n", sqlite3_errmsg(database));
            return NO;
        }
        if (sqlite3_step(statement) != SQLITE_DONE) {
            sqlite3_finalize(statement);
            NSLog(@"db error: %s\n", sqlite3_errmsg(database));
            return NO;
        }
        
        
        sqlite3_stmt *compiledStatement;
        
        if (resultArray==nil || [resultArray count]<1) {
            
            statementStr=[NSString stringWithFormat:@"insert into user_details(name,dob,gender,height,weight,hr_monitoring) values(?1,?2,?3,?4,?5,?6)"];
            
        }
        else
        {
            statementStr=[NSString stringWithFormat:@"update   user_details set name=?1,dob=?2,gender=?3,height=?4,weight=?5,hr_monitoring=?6"];
            
            
        }
        if(sqlite3_prepare_v2(database, [statementStr UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            
           
            sqlite3_bind_text(compiledStatement, 1, [userDetails.name UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_int(compiledStatement, 2, (int)[userDetails.DOB timeIntervalSince1970]);
            sqlite3_bind_int(compiledStatement, 3, userDetails.gender);
            sqlite3_bind_double(compiledStatement, 4, [userDetails.height doubleValue]);
            sqlite3_bind_double(compiledStatement, 5, [userDetails.weight doubleValue]);
            sqlite3_bind_int(compiledStatement, 6, (int) userDetails.hrMonitoring);
            
            while(YES){
                NSInteger result = sqlite3_step(compiledStatement);
                if(result == SQLITE_DONE){
                    break;
                }
                else if(result != SQLITE_BUSY){
                    NSLog(@"db error: %s\n", sqlite3_errmsg(database));
                    break;
                }
            }
            sqlite3_reset(compiledStatement);
            
            
            
        }
        
        
        //------------------------commit-------------------
        statementStr = @"COMMIT TRANSACTION";
        sqlite3_stmt *commitStatement;
        if (sqlite3_prepare_v2(database, [statementStr UTF8String], -1, &commitStatement, NULL) != SQLITE_OK) {
            NSLog(@"db error: %s\n", sqlite3_errmsg(database));
            return NO;
        }
        if (sqlite3_step(commitStatement) != SQLITE_DONE) {
            NSLog(@"db error: %s\n", sqlite3_errmsg(database));
            return NO;
        }
        
        
        sqlite3_finalize(compiledStatement);
        sqlite3_finalize(commitStatement);
        sqlite3_finalize(statement);
        sqlite3_close(database);
        return YES;
    }
    return NO;
}
- (NSArray*) fetchUserProfileRecord
{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        
        const char *query_stmt = "select * from user_details";
        NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:1];
        if (sqlite3_prepare_v2(database,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                int userId=sqlite3_column_int(statement, USER_ID);
                NSString *name=[[NSString alloc] initWithUTF8String:(char*)sqlite3_column_text(statement, USER_NAME)];
                NSDate * DOB=[NSDate dateWithTimeIntervalSince1970:sqlite3_column_double(statement, USER_DOB)];
                int gender=sqlite3_column_int(statement, USER_GENDER);
                NSNumber *height=[NSNumber numberWithDouble: (double)sqlite3_column_double(statement, USER_HEIGHT)];
                NSNumber *weight=[NSNumber numberWithDouble: (double)sqlite3_column_double(statement, USER_WEIGHT)];
                BOOL hrMonitoring=sqlite3_column_int(statement, USER_HR_MONITORING);
                
                
                [resultArray addObject:[ISUserDetails userDetailsWithUserId:userId name:name dob:DOB gender:gender height:height weight:weight hr:hrMonitoring]];
            }
            sqlite3_finalize(statement);
            sqlite3_close(database);
            return resultArray;
            
            
        }
    }
    return nil;
}
//-----------------------handling WO Goals----------------------------------------------
- (BOOL) saveWOGoal:(ISWOGoal*)woGoal
{
    
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        
        NSString* statementStr;
        
        statementStr = @"BEGIN EXCLUSIVE TRANSACTION";
        
        if (sqlite3_prepare_v2(database, [statementStr UTF8String], -1, &statement, NULL) != SQLITE_OK) {
            NSLog(@"db error: %s\n", sqlite3_errmsg(database));
            return NO;
        }
        if (sqlite3_step(statement) != SQLITE_DONE) {
            sqlite3_finalize(statement);
            NSLog(@"db error: %s\n", sqlite3_errmsg(database));
            return NO;
        }
        
        
        sqlite3_stmt *compiledStatement;
        statementStr=[NSString stringWithFormat:@"insert into wo_goal_details(goal_type,goal_value) values(?1,?2) "];
        NSString *queryForLastRowIndex=@"SELECT last_insert_rowid() from wo_goal_details";
        sqlite3_stmt *stmt;
        if(sqlite3_prepare_v2(database, [statementStr UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            
            sqlite3_bind_int(compiledStatement, 1, woGoal.goalType);
            sqlite3_bind_double(compiledStatement, 2, [woGoal.goalValue doubleValue]);
            
            while(YES){
                NSInteger result = sqlite3_step(compiledStatement);
                if(result == SQLITE_DONE){
                    if (sqlite3_prepare_v2(database,
                                           [queryForLastRowIndex UTF8String], -1, &stmt, NULL) == SQLITE_OK)
                    {
                        
                        if (sqlite3_step(stmt) == SQLITE_ROW)
                        {
                            woGoal.woGoalId= sqlite3_column_int(stmt, GOAL_ID);
                        }
                        sqlite3_finalize(stmt);
                    }
                    
                    
                    break;
                }
                else if(result != SQLITE_BUSY){
                    NSLog(@"db error: %s\n", sqlite3_errmsg(database));
                    break;
                }
            }
            sqlite3_reset(compiledStatement);
        }
        
        
        //------------------------commit-------------------
        statementStr = @"COMMIT TRANSACTION";
        sqlite3_stmt *commitStatement;
        if (sqlite3_prepare_v2(database, [statementStr UTF8String], -1, &commitStatement, NULL) != SQLITE_OK) {
            NSLog(@"db error: %s\n", sqlite3_errmsg(database));
            return NO;
        }
        if (sqlite3_step(commitStatement) != SQLITE_DONE) {
            NSLog(@"db error: %s\n", sqlite3_errmsg(database));
            return NO;
        }
        
        
        sqlite3_finalize(compiledStatement);
        sqlite3_finalize(commitStatement);
        sqlite3_finalize(stmt);
        sqlite3_finalize(statement);
        sqlite3_close(database);
        return YES;
    }
    return NO;
}
- (NSArray*) fetchWOGoals
{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        
        const char *query_stmt = "select * from wo_goal_details";
        NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:1];
        if (sqlite3_prepare_v2(database,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                int woGoalId=sqlite3_column_int(statement, GOAL_ID);
                
                int woGoalType=sqlite3_column_int(statement, GOAL_TYPE);
                NSNumber *woGoalValue=[NSNumber numberWithDouble: (double)sqlite3_column_double(statement, GOAL_VALUE)];
                [resultArray addObject:[ISWOGoal workOutGoalWithId:woGoalId goalType:woGoalType goalvalue:woGoalValue]];
            }
            sqlite3_finalize(statement);
            sqlite3_close(database);
            return resultArray;
            
            
        }
    }
    return nil;
}
//-----------------------handling HR----------------------------------------------
- (BOOL) saveHRArray:(NSArray*)hrArray
{
    
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        
        NSString* statementStr;
        
        statementStr = @"BEGIN EXCLUSIVE TRANSACTION";
        
        if (sqlite3_prepare_v2(database, [statementStr UTF8String], -1, &statement, NULL) != SQLITE_OK) {
            NSLog(@"db error: %s\n", sqlite3_errmsg(database));
            return NO;
        }
        if (sqlite3_step(statement) != SQLITE_DONE) {
            sqlite3_finalize(statement);
            NSLog(@"db error: %s\n", sqlite3_errmsg(database));
            return NO;
        }
        sqlite3_stmt *compiledStatement;
        
        statementStr=[NSString stringWithFormat:@"insert into hr_details(timestamp,hr) values(?1,?2)"];
        
        if(sqlite3_prepare_v2(database, [statementStr UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            
            for (ISHR *hr  in hrArray) {
                
                sqlite3_bind_int(compiledStatement, 1,(int) [hr.timeStamp timeIntervalSince1970]);
                sqlite3_bind_int(compiledStatement, 2,[hr.hr intValue]);
                
                while(YES){
                    NSInteger result = sqlite3_step(compiledStatement);
                    if(result == SQLITE_DONE){
                        break;
                    }
                    else if(result != SQLITE_BUSY){
                        NSLog(@"db error: %s\n", sqlite3_errmsg(database));
                        break;
                    }
                }
                sqlite3_reset(compiledStatement);
                
                
            }
            
            
        }
        
        
        
        
        // COMMIT
        statementStr = @"COMMIT TRANSACTION";
        sqlite3_stmt *commitStatement;
        if (sqlite3_prepare_v2(database, [statementStr UTF8String], -1, &commitStatement, NULL) != SQLITE_OK) {
            NSLog(@"db error: %s\n", sqlite3_errmsg(database));
            return NO;
        }
        if (sqlite3_step(commitStatement) != SQLITE_DONE) {
            NSLog(@"db error: %s\n", sqlite3_errmsg(database));
            return NO;
        }
        
        //     sqlite3_finalize(beginStatement);
        sqlite3_finalize(compiledStatement);
        sqlite3_finalize(commitStatement);
        return YES;
        
    }
    
    
    return NO;
}



- (NSArray*) fetchHRWithStartTS:(NSDate *)startTS endTS:(NSDate*)endTS
{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        
        
        int sTS=[startTS timeIntervalSince1970];
        int eTS=[endTS timeIntervalSince1970];
        NSString *s=[NSString stringWithFormat:@"select * from hr_details where timestamp>=%d and timestamp<=%d",sTS,eTS];
        
        const char *query_stmt = [s UTF8String];
        NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:1];
        if (sqlite3_prepare_v2(database,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                NSDate * TS=[NSDate dateWithTimeIntervalSince1970:sqlite3_column_int(statement, HR_TIMESTAMP)];
                int hr=sqlite3_column_int(statement, HR_HR);
                
                [resultArray addObject:[ISHR hrWithHeartRate:hr timestamp:TS]];
            }
            sqlite3_finalize(statement);
            sqlite3_close(database);
            return resultArray;
            
            
        }
    }
    return nil;
}


//-----------------------handling workout ----------------------------------------------

- (BOOL) saveWorkout:(ISWorkOut*)woDetails
{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        
        NSString* statementStr;
        
        statementStr = @"BEGIN EXCLUSIVE TRANSACTION";
        
        if (sqlite3_prepare_v2(database, [statementStr UTF8String], -1, &statement, NULL) != SQLITE_OK) {
            NSLog(@"db error: %s\n", sqlite3_errmsg(database));
            return NO;
        }
        if (sqlite3_step(statement) != SQLITE_DONE) {
            sqlite3_finalize(statement);
            NSLog(@"db error: %s\n", sqlite3_errmsg(database));
            return NO;
        }
        
        
        sqlite3_stmt *compiledStatement;
        
        
            
        statementStr=[NSString stringWithFormat:@"insert into wo_details(start_timestamp ,end_timestamp ,steps , calories_burned ,min_speed ,max_speed ,distance,goal_id) values(?1,?2,?3,?4,?5,?6,?7,?8)"];
        NSString *queryForLastRowIndex=@"SELECT last_insert_rowid() from wo_details";
        sqlite3_stmt *stmt;
            
        if(sqlite3_prepare_v2(database, [statementStr UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            
            sqlite3_bind_int(compiledStatement, 1, (int)[woDetails.startTimeStamp timeIntervalSince1970]);
            sqlite3_bind_int(compiledStatement, 2, (int)[woDetails.endTimeStamp timeIntervalSince1970]);
            sqlite3_bind_int(compiledStatement, 3, [woDetails.steps intValue]);
            sqlite3_bind_double(compiledStatement, 4, [woDetails.calBurned doubleValue]);
            sqlite3_bind_double(compiledStatement, 5, [woDetails.minSpeed doubleValue]);
            sqlite3_bind_double(compiledStatement, 6, [woDetails.maxSpeed doubleValue]);
            sqlite3_bind_double(compiledStatement, 7, [woDetails.distance doubleValue]);
            sqlite3_bind_int(compiledStatement, 8, woDetails.woGoalId);
            
            
            while(YES){
                NSInteger result = sqlite3_step(compiledStatement);
                if(result == SQLITE_DONE){
                    if (sqlite3_prepare_v2(database,
                                           [queryForLastRowIndex UTF8String], -1, &stmt, NULL) == SQLITE_OK)
                    {
                        
                        if (sqlite3_step(stmt) == SQLITE_ROW)
                        {
                            woDetails.woId=sqlite3_column_int(stmt, WO_ID);
                        }
                        sqlite3_finalize(stmt);
                    }
                    break;
                }
                else if(result != SQLITE_BUSY){
                    NSLog(@"db error: %s\n", sqlite3_errmsg(database));
                    break;
                }
            }
            sqlite3_reset(compiledStatement);
            
            
            
            
        }
        
        
        //------------------------commit-------------------
        statementStr = @"COMMIT TRANSACTION";
        sqlite3_stmt *commitStatement;
        if (sqlite3_prepare_v2(database, [statementStr UTF8String], -1, &commitStatement, NULL) != SQLITE_OK) {
            NSLog(@"db error: %s\n", sqlite3_errmsg(database));
            return NO;
        }
        if (sqlite3_step(commitStatement) != SQLITE_DONE) {
            NSLog(@"db error: %s\n", sqlite3_errmsg(database));
            return NO;
        }
        
        
        sqlite3_finalize(compiledStatement);
        sqlite3_finalize(commitStatement);
        sqlite3_finalize(stmt);
        sqlite3_finalize(statement);
        sqlite3_close(database);
        return YES;
    }
    return NO;
}

- (BOOL) updateWorkout:(ISWorkOut*)woDetails
{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        
        NSString* statementStr;
        
        statementStr = @"BEGIN EXCLUSIVE TRANSACTION";
        
        if (sqlite3_prepare_v2(database, [statementStr UTF8String], -1, &statement, NULL) != SQLITE_OK) {
            NSLog(@"db error: %s\n", sqlite3_errmsg(database));
            return NO;
        }
        if (sqlite3_step(statement) != SQLITE_DONE) {
            sqlite3_finalize(statement);
            NSLog(@"db error: %s\n", sqlite3_errmsg(database));
            return NO;
        }
        
        
        sqlite3_stmt *compiledStatement;
        
        statementStr=[NSString stringWithFormat:@"update wo_details set start_timestamp=?1 ,end_timestamp=?2 ,steps=?3 , calories_burned=?4 ,min_speed=?5 ,max_speed=?6 ,distance=?7,goal_id=?8  where wo_id=?9 "];
        
        if(sqlite3_prepare_v2(database, [statementStr UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            
            sqlite3_bind_int(compiledStatement, 1, (int)[woDetails.startTimeStamp timeIntervalSince1970]);
            sqlite3_bind_int(compiledStatement, 2, (int)[woDetails.endTimeStamp timeIntervalSince1970]);
            sqlite3_bind_int(compiledStatement, 3, [woDetails.steps intValue]);
            sqlite3_bind_double(compiledStatement, 4, [woDetails.calBurned doubleValue]);
            sqlite3_bind_double(compiledStatement, 5, [woDetails.minSpeed doubleValue]);
            sqlite3_bind_double(compiledStatement, 6, [woDetails.maxSpeed doubleValue]);
            sqlite3_bind_double(compiledStatement, 7, [woDetails.distance doubleValue]);
            sqlite3_bind_int(compiledStatement, 8, woDetails.woGoalId);
            sqlite3_bind_int(compiledStatement, 9, woDetails.woId);
            
            while(YES){
                NSInteger result = sqlite3_step(compiledStatement);
                if(result == SQLITE_DONE){
                    break;
                }
                else if(result != SQLITE_BUSY){
                    NSLog(@"db error: %s\n", sqlite3_errmsg(database));
                    break;
                }
            }
            sqlite3_reset(compiledStatement);
            
        }
        
        
        
        //------------------------commit-------------------
        statementStr = @"COMMIT TRANSACTION";
        sqlite3_stmt *commitStatement;
        if (sqlite3_prepare_v2(database, [statementStr UTF8String], -1, &commitStatement, NULL) != SQLITE_OK) {
            NSLog(@"db error: %s\n", sqlite3_errmsg(database));
            return NO;
        }
        if (sqlite3_step(commitStatement) != SQLITE_DONE) {
            NSLog(@"db error: %s\n", sqlite3_errmsg(database));
            return NO;
        }
        
        
        sqlite3_finalize(compiledStatement);
        sqlite3_finalize(commitStatement);
        sqlite3_finalize(statement);
        sqlite3_close(database);
        return YES;
    }
    return NO;
}

- (BOOL) deleteWorkout:(ISWorkOut*)woDetails
{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        
        NSString* statementStr;
        
        statementStr = @"BEGIN EXCLUSIVE TRANSACTION";
        
        if (sqlite3_prepare_v2(database, [statementStr UTF8String], -1, &statement, NULL) != SQLITE_OK) {
            NSLog(@"db error: %s\n", sqlite3_errmsg(database));
            return NO;
        }
        if (sqlite3_step(statement) != SQLITE_DONE) {
            sqlite3_finalize(statement);
            NSLog(@"db error: %s\n", sqlite3_errmsg(database));
            return NO;
        }
        
        
        sqlite3_stmt *compiledStatement;
        
        statementStr=@"delete from wo_details where wo_id = ?1";
        
        if(sqlite3_prepare_v2(database, [statementStr UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            
            sqlite3_bind_int(compiledStatement, 1, woDetails.woId);
            
            
            while(YES){
                NSInteger result = sqlite3_step(compiledStatement);
                if(result == SQLITE_DONE){
                    break;
                }
                else if(result != SQLITE_BUSY){
                    NSLog(@"db error: %s\n", sqlite3_errmsg(database));
                    break;
                }
            }
            sqlite3_reset(compiledStatement);
            
        }
        
        
        
        //------------------------commit-------------------
        statementStr = @"COMMIT TRANSACTION";
        sqlite3_stmt *commitStatement;
        if (sqlite3_prepare_v2(database, [statementStr UTF8String], -1, &commitStatement, NULL) != SQLITE_OK) {
            NSLog(@"db error: %s\n", sqlite3_errmsg(database));
            return NO;
        }
        if (sqlite3_step(commitStatement) != SQLITE_DONE) {
            NSLog(@"db error: %s\n", sqlite3_errmsg(database));
            return NO;
        }
        
        
        sqlite3_finalize(compiledStatement);
        sqlite3_finalize(commitStatement);
        sqlite3_finalize(statement);
        sqlite3_close(database);
        return YES;
    }
    return NO;
}


- (NSArray*) fetchAllWorkouts
{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        
        const char *query_stmt = "select * from wo_details";
        NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:1];
        if (sqlite3_prepare_v2(database,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                 int woId=sqlite3_column_int(statement, WO_ID);
                 NSDate *startTimeStamp=[NSDate dateWithTimeIntervalSince1970:sqlite3_column_double(statement, WO_START_TIMESTAMP)];
                 NSDate *endTimeStamp=[NSDate dateWithTimeIntervalSince1970:sqlite3_column_double(statement, WO_END_TIMESTAMP)];
                 NSNumber *steps=[NSNumber numberWithInt: sqlite3_column_int(statement, WO_STEPS)];
                 NSNumber *calBurned=[NSNumber numberWithDouble: (double)sqlite3_column_double(statement, WO_CALORIES_BURNED)];
                 NSNumber *minSpeed=[NSNumber numberWithDouble: (double)sqlite3_column_double(statement, WO_MIN_SPEED)];
                 NSNumber *maxSpeed=[NSNumber numberWithDouble: (double)sqlite3_column_double(statement, WO_MAX_SPEED)];
                 NSNumber *distance=[NSNumber numberWithDouble: (double)sqlite3_column_double(statement, WO_DISTANCE)];
                 int woGoalId=sqlite3_column_int(statement, WO_GOAL_ID);
                
                
                [resultArray addObject:[ISWorkOut workoutWithwoId:woId startTimeStamp:startTimeStamp endTimeStamp:endTimeStamp steps:steps calBurned:calBurned minSpeed:minSpeed maxSpeed:maxSpeed distance:distance woGoalId:woGoalId]];
            }
            sqlite3_finalize(statement);
            sqlite3_close(database);
            return resultArray;
            
            
        }
    }
    return nil;
}



//
//-(BOOL) insertBatchData:(NSArray*)dataArray
//{
//
//    const char *dbpath = [databasePath UTF8String];
//    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
//    {
//
//        NSString* statementStr;
//
//        statementStr = @"BEGIN EXCLUSIVE TRANSACTION";
//        
//        if (sqlite3_prepare_v2(database, [statementStr UTF8String], -1, &statement, NULL) != SQLITE_OK) {
//            NSLog(@"db error: %s\n", sqlite3_errmsg(database));
//            return NO;
//        }
//        if (sqlite3_step(statement) != SQLITE_DONE) {
//            sqlite3_finalize(statement);
//            NSLog(@"db error: %s\n", sqlite3_errmsg(database));
//            return NO;
//        }
//        sqlite3_stmt *compiledStatement;
//        if ([[dataArray objectAtIndex:0] isKindOfClass:[State class]]) {
//            
//            statementStr=[NSString stringWithFormat:@"insert into state(title,subtitle,mapcenterx,mapcentery,mapzooming) values(?1,?2,?3,?4,?5)"];
//            
//            if(sqlite3_prepare_v2(database, [statementStr UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
//            {
//                
//                for (State *s  in dataArray) {
//                    
//                   const char *title=[s.title UTF8String];
//                   const char *subTitle=[s.subTitle UTF8String];
//                   const double mapcenterX=[s.mapCenterX doubleValue];
//                   const double mapcenterY=[s.mapCenterY doubleValue];
//                   const double zoom=[s.mapZooming doubleValue];
//                    
//                    sqlite3_bind_text(compiledStatement, 1, title, -1, SQLITE_TRANSIENT);
//                    sqlite3_bind_text(compiledStatement, 2, subTitle, -1, SQLITE_TRANSIENT);
//                    sqlite3_bind_double(compiledStatement, 3, mapcenterX);
//                    sqlite3_bind_double(compiledStatement, 4, mapcenterY);
//                    sqlite3_bind_double(compiledStatement, 5, zoom);
//                    
//                    while(YES){
//                        NSInteger result = sqlite3_step(compiledStatement);
//                        if(result == SQLITE_DONE){
//                            break;
//                        }
//                        else if(result != SQLITE_BUSY){
//                            NSLog(@"db error: %s\n", sqlite3_errmsg(database));
//                            break;
//                        }
//                    }
//                    sqlite3_reset(compiledStatement);
//                    
//                    
//                }
//                
//            }
//            
//            
//            
//            
//        }
//        else if ([[dataArray objectAtIndex:0] isKindOfClass:[City class]])
//        {
//            statementStr=[NSString stringWithFormat:@"insert into city(title,subtitle,state_id) values(?1,?2,?3) "];
//            
//            if(sqlite3_prepare_v2(database, [statementStr UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
//            {
//                for (City *s in dataArray) {
//                    
//                    const char *title=[s.title UTF8String];
//                    const char *subTitle=[s.subTitle UTF8String];
//                    const int sId=s.state.stateId ;
//                    
//                    sqlite3_bind_text(compiledStatement, 1, title, -1, SQLITE_TRANSIENT);
//                    sqlite3_bind_text(compiledStatement, 2, subTitle, -1, SQLITE_TRANSIENT);
//                    sqlite3_bind_int(compiledStatement, 3, sId);
//                    
//                    while(YES){
//                        NSInteger result = sqlite3_step(compiledStatement);
//                        if(result == SQLITE_DONE){
//                            break;
//                        }
//                        else if(result != SQLITE_BUSY){
//                            NSLog(@"db error: %s\n", sqlite3_errmsg(database));
//                            break;
//                        }
//                    }
//                    sqlite3_reset(compiledStatement);
//                    
//                    
//                }
//                
//            }
//            
//        }
//        
//        
//        // COMMIT
//        statementStr = @"COMMIT TRANSACTION";
//        sqlite3_stmt *commitStatement;
//        if (sqlite3_prepare_v2(database, [statementStr UTF8String], -1, &commitStatement, NULL) != SQLITE_OK) {
//            NSLog(@"db error: %s\n", sqlite3_errmsg(database));
//            return NO;
//        }
//        if (sqlite3_step(commitStatement) != SQLITE_DONE) {
//            NSLog(@"db error: %s\n", sqlite3_errmsg(database));
//            return NO;
//        }
//        
//        //     sqlite3_finalize(beginStatement);
//        sqlite3_finalize(compiledStatement);
//        sqlite3_finalize(commitStatement);
//        return YES;
//    }
//    
//
//
//return NO;
//}
//



//- (BOOL) saveData:(NSString*)query
//{
//    const char *dbpath = [databasePath UTF8String];
//    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
//    {
//        
//        const char *insert_stmt = [query UTF8String];
//        const char *sql_stmt ="pragma foreign_keys=ON";
//        char *errMsg;
//        if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)
//            != SQLITE_OK)
//        {
//            NSLog(@"Failed to update pragma:%s",errMsg);
//        }
//        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
//        if (sqlite3_step(statement) == SQLITE_DONE)
//        {
//            return YES;
//        }
//        
//        else {
//            return NO;
//        }
//        sqlite3_finalize(statement);
//        sqlite3_close(database);
//    }
//    return NO;
//}
//
//-(BOOL)deleteAllTables
//{
//    [self saveData:@"drop state"];
//    return [self saveData:@"drop city"];
//}
//




@end