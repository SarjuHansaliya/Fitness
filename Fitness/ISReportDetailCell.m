//
//  ISReportDetailCell.m
//  Fitness
//
//  Created by ispluser on 2/18/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import "ISReportDetailCell.h"

@implementation ISReportDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier

{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ISReportDetailsCell" owner:self options:nil];
        self = [topLevelObjects objectAtIndex:0];
        self.backgroundColor=[UIColor clearColor];
        
    }
    return self;
}

//---------------------------setting label values--------------------

-(void)setGoalTypeLabel:(NSString *)goalType workoutDateLabel:(NSDate *)date goalValueLabel:(NSString *)goalValue
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    formatter.dateFormat=@"dd MMM yy, hh:mm a";
    self.workoutDateLabel.text=[formatter stringFromDate:date];
    self.goalTypeLabel.text=goalType;
    self.goalValueLabel.text=goalValue;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
