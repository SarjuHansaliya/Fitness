//
//  ISHRDistributor.m
//  Fitness
//
//  Created by ispluser on 2/20/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import "ISHRDistributor.h"
#import "ISHR.h"
#import "ISWorkOutHandler.h"
#import "ISAppDelegate.h"

#define HR_SAVE_DELAY_SECONDS 29

@implementation ISHRDistributor
{
    NSTimeInterval lastHRArraySaveTimestamp;
    
}

-(void)didUpdateHeartRate:(UInt16)hr formate16bit:(BOOL)is16bit
{
    self.currentHR=[NSNumber numberWithInt:hr];
    
    ISAppDelegate *appDel=(ISAppDelegate*)[[UIApplication sharedApplication]delegate];
    
    if (appDel.woHandler.userDetails.hrMonitoring || appDel.woHandler.isWOStarted) {
        
        NSDate *ts=[NSDate date];
       // NSLog(@"ts:%f",[ts timeIntervalSince1970]);
        [self.hrArray addObject:[ISHR hrWithHeartRate:hr timestamp:ts]];
        if ([self.hrArray count]==1) {
            lastHRArraySaveTimestamp=[ts timeIntervalSince1970];
    //         NSLog(@"ts save--------------------:%f",[ts timeIntervalSince1970]);
        }
        if (([ts timeIntervalSince1970]-lastHRArraySaveTimestamp)>HR_SAVE_DELAY_SECONDS) {
            
            if (appDel.woHandler.isWOStarted) {
                
                [self calculateEnergyExp];
            }
            [self saveData];
            
            
        }
       
    }
    if ([self.minHR intValue]> [self.currentHR intValue]) {
        self.minHR=[NSNumber numberWithInt:[self.currentHR intValue]];
    }
    if ([self.maxHR intValue]<[self.currentHR intValue])
    {
        self.maxHR=[NSNumber numberWithInt:[self.currentHR intValue]];
    }
    
    if ([self.dashBoardDelegate respondsToSelector:@selector(didUpdateCurrentHeartRate:maxHeartRate:minHeartRate:)]) {
        [self.dashBoardDelegate didUpdateCurrentHeartRate:self.currentHR maxHeartRate:self.maxHR minHeartRate:self.minHR ];
    }
    
    
    
}
-(void)calculateEnergyExp
{
    ISAppDelegate *appDel=(ISAppDelegate*)[[UIApplication sharedApplication]delegate];
    double currCalBurn=[appDel.woHandler.currentWO.calBurned doubleValue];
    double gender=(double)appDel.woHandler.userDetails.gender;
    double hrAvg=0.0;
    for (ISHR* hr in self.hrArray) {
        hrAvg+=[hr.hr doubleValue];
    }
    hrAvg=hrAvg/(double)[self.hrArray count];
    
    double weight=[appDel.woHandler.userDetails.weight doubleValue];
    double age=(double)[self ageFromBirthday:appDel.woHandler.userDetails.DOB];
    
    
    double newCalBurn=gender*(-55.0969+0.6309*hrAvg+0.1988*weight+0.2017*age)+(1-gender)*(-20.4022+0.4472*hrAvg-0.1263*weight+0.074*age);
    
    
    appDel.woHandler.currentWO.calBurned=[NSNumber numberWithDouble:(currCalBurn+newCalBurn)];
    
}
- (NSInteger)ageFromBirthday:(NSDate *)birthdate {
    NSDate *today = [NSDate date];
    NSDateComponents *ageComponents = [[NSCalendar currentCalendar]
                                       components:NSYearCalendarUnit
                                       fromDate:birthdate
                                       toDate:today
                                       options:0];
    return ageComponents.year;
}

-(void)reset
{
    self.maxHR=@0;
    self.minHR=@1000;
    self.hrArray=[NSMutableArray arrayWithCapacity:1];
}

-(void)saveData
{
    [ISHR saveHRArray:self.hrArray];
    self.hrArray =[NSMutableArray arrayWithCapacity:1];
}

@end
