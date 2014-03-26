//
//  ISReminderRepeatViewController.h
//  Fitness
//
//  Created by ispluser on 2/19/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ISReminderRepeatViewController : UITableViewController

- (id)initWithStyle:(UITableViewStyle)style weekdays:(int *)w;



-(NSString *)getRepeatString;

@end
