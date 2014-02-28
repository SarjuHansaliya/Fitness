//
//  ISWorkoutRemindersViewController.h
//  Fitness
//
//  Created by ispluser on 2/14/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISReminderCell.h"
#import "MBProgressHUD.h"
#import "macros.h"

@interface ISWorkoutRemindersViewController : UITableViewController

@property  NSIndexPath *selectedReminderIndex;
@property NSMutableArray *reminders;
@property MBProgressHUD *HUD;

-(void)deleteCell;

@end
