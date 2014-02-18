//
//  ISReportDetailCell.m
//  Fitness
//
//  Created by ispluser on 2/18/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import "ISReportDetailCell.h"
//---------------implementing helper class for handling cell events---------


@implementation ISReportDetailCellHandler


//---------------------------setting label values--------------------

-(void)setGoalTypeLabel:(NSString *)goalType workoutDateLabel:(NSDate *)date goalValueLabel:(NSString *)goalValue
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    formatter.dateFormat=@"dd MMM yy, hh:mm a";
    self.workoutDateLabel.text=[formatter stringFromDate:date];
    self.goalTypeLabel.text=goalType;
    self.goalValueLabel.text=goalValue;
}


@end





@implementation ISReportDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier

{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        ISReportDetailCellHandler * outletOwner=[[ISReportDetailCellHandler alloc]init];
        
        
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ISReportDetailsCell" owner:outletOwner options:nil];
        self = [topLevelObjects objectAtIndex:0];
        
        self.outletOwner=outletOwner;
        self.backgroundColor=[UIColor clearColor];
        
    }
    return self;
}


-(void)setGoalTypeLabel:(NSString *)goalType workoutDateLabel:(NSDate *)date goalValueLabel:(NSString *)goalValue
{
    [self.outletOwner setGoalTypeLabel:goalType workoutDateLabel:date goalValueLabel:goalValue];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
