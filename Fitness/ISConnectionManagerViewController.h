//
//  ISConnectionManagerViewController.h
//  Fitness
//
//  Created by ispluser on 2/14/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISBLEConnectionManagerViewController.h"
#import "ISAppDelegate.h"


@interface ISConnectionManagerViewController : UIViewController 

@property (weak, nonatomic) IBOutlet UIView *devicesTableView;
- (IBAction)discoverDevices:(id)sender;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *scanningActivityIndicator;
@property ISBLEConnectionManagerViewController *tableViewController;

@property (weak, nonatomic) IBOutlet UIButton *scanButton;


@end
