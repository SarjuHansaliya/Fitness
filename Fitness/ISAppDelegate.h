//
//  ISAppDelegate.h
//  Fitness
//
//  Created by ispluser on 2/6/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMDrawerController.h"
#import "ISBluetooth.h"

@interface ISAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property MMDrawerController *drawerController;
@property ISBluetooth *bluetoothManager;
-(ISBluetooth *)getBluetoothManager;
@end