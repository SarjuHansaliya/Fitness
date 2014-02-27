//
//  ISWorkoutReminderController.h
//  Fitness
//
//  Created by ispluser on 2/20/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISWorkoutRemindersViewController.h"

@interface ISWorkoutReminderController : UIViewController

@property ISWorkoutRemindersViewController *remindersTableVC;
@property (weak, nonatomic) IBOutlet UITableView *remindersView;
- (IBAction)deleteReminderButtonClicked:(id)sender;
- (IBAction)editReminderButtonClicked:(id)sender;

@end
