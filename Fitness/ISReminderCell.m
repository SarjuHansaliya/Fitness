//
//  ISReminderCell.m
//  Fitness
//
//  Created by ispluser on 2/14/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import "ISReminderCell.h"

//---------------implementing helper class for handling cell events---------


@implementation ISReminderCellHandler


//---------------------------setting label values--------------------

-(void)setReminderTime:(NSDate*)time reminderOnDays:(NSArray *)days
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
//-------------------------------reminder on/off handling--------------------

- (IBAction)reminderSwitchValueChanged:(id)sender {
    
    self.backgroundImage.hidden=self.reminderSwitch.on;
    UIColor *color535353=[UIColor colorWithRed:83.0/255.0 green:83.0/253.0 blue:83.0/253.0 alpha:1];
    if (self.reminderSwitch.on) {
        self.reminderTimeLabel.textColor=[UIColor blackColor];
        self.reminderDaysLabel.textColor=[UIColor blackColor];
    }
    else
    {
        self.reminderTimeLabel.textColor=color535353;
        self.reminderDaysLabel.textColor=color535353;
        
    }
    
    
}



@end





@implementation ISReminderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier

{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        ISReminderCellHandler * outletOwner=[[ISReminderCellHandler alloc]init];
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ISReminderTableCell" owner:outletOwner options:nil];
        self = [topLevelObjects objectAtIndex:0];
        
        self.outletOwner=outletOwner;
        self.backgroundColor=[UIColor clearColor];
        
    }

    
    return self;
}
-(void)setReminderTime:(NSDate *)time reminderOnDays:(NSArray *)days
{
    [self.outletOwner setReminderTime:time reminderOnDays:days];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}




@end





