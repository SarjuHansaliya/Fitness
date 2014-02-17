//
//  ISConnectionManagerViewController.h
//  Fitness
//
//  Created by ispluser on 2/14/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISBLEConnectionManagerViewController.h"

@interface ISConnectionManagerViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *devicesTableView;
@property ISBLEConnectionManagerViewController *tableViewController;
@end
