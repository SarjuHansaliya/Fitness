//
//  ISBLEConnectionManagerViewController.h
//  Fitness
//
//  Created by ispluser on 2/14/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISAppDelegate.h"



@interface ISBLEConnectionManagerViewController : UITableViewController<ISBluetoothDelegate>


@property ISBluetooth *bluetoothManager;
@property (weak) id parentController;


@end
