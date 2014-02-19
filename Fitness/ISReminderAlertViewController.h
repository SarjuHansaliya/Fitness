//
//  ISReminderAlertViewController.h
//  Fitness
//
//  Created by ispluser on 2/19/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "macros.h"
#import "ISRepeatReminderCell.h"

@interface ISReminderAlertViewController : UITableViewController
@property (nonatomic) NSString *label;
@property (nonatomic) NSInteger selectedRow;
@end
