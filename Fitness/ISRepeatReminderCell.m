//
//  ISRepeatReminderCell.m
//  Fitness
//
//  Created by ispluser on 2/19/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import "ISRepeatReminderCell.h"

@implementation ISRepeatReminderCellHandler


-(void)setLabel:(NSString *)text isSelected:(BOOL )isSelected
{
    [self.label setText:text];
    [self.selectedImage setHidden:!isSelected];
}


@end



@implementation ISRepeatReminderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        ISRepeatReminderCellHandler * outletOwner=[[ISRepeatReminderCellHandler alloc]init];
        
        
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ISRepeatReminderCell" owner:outletOwner options:nil];
        self = [topLevelObjects objectAtIndex:0];
        
        self.outletOwner=outletOwner;
        self.backgroundColor=[UIColor clearColor];
        
    }
    return self;
}

-(void)setLabel:(NSString *)text isSelected:(BOOL )isSelected
{
    [self.outletOwner setLabel:text isSelected:isSelected];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
