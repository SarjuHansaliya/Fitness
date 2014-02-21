//
//  ISHRDistributor.m
//  Fitness
//
//  Created by ispluser on 2/20/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import "ISHRDistributor.h"

@implementation ISHRDistributor

-(void)didUpdateHeartRate:(UInt16)hr formate16bit:(BOOL)is16bit
{
    self.currentHR=[NSNumber numberWithInt:hr];
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

@end
