//
//  ISReminderCell.m
//  Fitness
//
//  Created by ispluser on 2/14/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import "ISReminderCell.h"
#import "ISEditReminderViewController.h"
#import "ISAppDelegate.h"





@implementation ISReminderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier

{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ISReminderTableCell" owner:self options:nil];
        self = [topLevelObjects objectAtIndex:0];
        
        self.backgroundColor=[UIColor clearColor];
        
    }
    return self;
}



//---------------------------setting label values--------------------

-(void)setCellValuesForReminder:(EKReminder*)reminder
{
    self.reminder=reminder;
    self.reminderLabel.text=reminder.title;
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    formatter.dateFormat=@"hh:mm a";
    self.reminderTimeLabel.text=[formatter stringFromDate:reminder.dueDateComponents.date];
    EKRecurrenceRule *rr=(EKRecurrenceRule*)[self.reminder.recurrenceRules objectAtIndex:0];
    
    
    UIColor *color535353=[UIColor colorWithRed:83.0/255.0 green:83.0/253.0 blue:83.0/253.0 alpha:1];
    UIColor *colordf7503=[UIColor colorWithRed:223.0/255.0 green:117.0/253.0 blue:3.0/253.0 alpha:1];
    if ([self.reminder.alarms count]>0) {
        self.reminderSwitch.on=YES;
        self.reminderTimeLabel.textColor=[UIColor blackColor];
        self.reminderDaysLabel.textColor=[UIColor blackColor];
        self.reminderLabel.textColor= colordf7503;
    }
    else
    {
        self.reminderSwitch.on=NO;
        self.reminderTimeLabel.textColor=color535353;
        self.reminderDaysLabel.textColor=color535353;
        self.reminderLabel.textColor=color535353;
        
    }
    self.backgroundImage.hidden=self.reminderSwitch.on;
    
    if (rr.frequency ==EKRecurrenceFrequencyDaily) {
        self.reminderDaysLabel.text=@"Sun, Mon, Tue, Wed, Thu, Fri, Sat";
    }
    else
    {
        NSMutableString *s=[[NSMutableString alloc]initWithCapacity:1];
        for (EKRecurrenceDayOfWeek *d in rr.daysOfTheWeek) {
            switch (d.dayOfTheWeek) {
                case EKSunday:
                    [s appendString:@"Sun, "];
                    break;
                case EKMonday:
                    [s appendString:@"Mon, "];
                    break;
                case EKTuesday:
                    [s appendString:@"Tue, "];
                    break;
                case EKWednesday:
                    [s appendString:@"Wed, "];
                    break;
                case EKThursday:
                    [s appendString:@"Thu, "];
                    break;
                case EKFriday:
                    [s appendString:@"Fri, "];
                    break;
                case EKSaturday:
                    [s appendString:@"Sat, "];
                    break;
            }
        }
        self.reminderDaysLabel.text=[s substringToIndex:s.length-2];
    }
    
}


-(void)setReminderTime:(NSDate *)time reminderOnDays:(NSArray *)days
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    formatter.dateFormat=@"hh:mm a";
    self.reminderTimeLabel.text=[formatter stringFromDate:time];
    
    NSMutableString *ms=[[NSMutableString alloc]init];
    for (NSString *s in days) {
        [ms appendString:s];
        //[ms appendString:@", "];
    }
    self.reminderDaysLabel.text=ms;
        
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//-------------------------------reminder on/off handling--------------------

- (IBAction)reminderSwitchValueChanged:(id)sender {
    
    self.backgroundImage.hidden=self.reminderSwitch.on;
    UIColor *color535353=[UIColor colorWithRed:83.0/255.0 green:83.0/253.0 blue:83.0/253.0 alpha:1];
    UIColor *colordf7503=[UIColor colorWithRed:223.0/255.0 green:117.0/253.0 blue:3.0/253.0 alpha:1];
    ISAppDelegate *appDel=(ISAppDelegate*)[[UIApplication sharedApplication]delegate];
    if (self.reminderSwitch.on) {
        self.reminderTimeLabel.textColor=[UIColor blackColor];
        self.reminderDaysLabel.textColor=[UIColor blackColor];
        self.reminderLabel.textColor= colordf7503;
        
        EKAlarm *alarm=[EKAlarm alarmWithRelativeOffset:0.0];
        [self.reminder addAlarm:alarm];
    }
    else
    {
        self.reminderTimeLabel.textColor=color535353;
        self.reminderDaysLabel.textColor=color535353;
        self.reminderLabel.textColor=color535353;
        for (EKAlarm *a in self.reminder.alarms ) {
         [self.reminder removeAlarm:a];
        }
    }
    [appDel.eventStore saveReminder:self.reminder commit:YES error:nil];
    
}


@end





