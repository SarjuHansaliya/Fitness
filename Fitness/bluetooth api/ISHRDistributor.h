//
//  ISHRDistributor.h
//  Fitness
//
//  Created by ispluser on 2/20/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISBluetooth.h"
#import "ISDashboardViewController.h"

@interface ISHRDistributor : NSObject <ISBluetoothNotificationDelegate>

@property NSNumber *currentHR;
@property NSNumber *maxHR;
@property NSNumber *minHR;
@property (weak) ISDashboardViewController * dashBoardDelegate;


@end
