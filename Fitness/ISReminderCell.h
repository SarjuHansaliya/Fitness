//
//  ISReminderCell.h
//  Fitness
//
//  Created by ispluser on 2/14/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>


@interface ISReminderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *reminderSelImage;
@property (weak, nonatomic) IBOutlet UISwitch *reminderSwitch;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UILabel *reminderTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *reminderDaysLabel;
@property (weak, nonatomic) IBOutlet UILabel *reminderLabel;

@property (weak) EKReminder *reminder;

- (IBAction)reminderSwitchValueChanged:(id)sender;
-(void)setReminderTime:(NSDate *)time reminderOnDays:(NSArray *)days;
-(void)setCellValuesForReminder:(EKReminder*)reminder;
@end


