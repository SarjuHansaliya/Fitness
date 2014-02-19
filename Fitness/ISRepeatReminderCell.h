//
//  ISRepeatReminderCell.h
//  Fitness
//
//  Created by ispluser on 2/19/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import <UIKit/UIKit.h>


//-----------------defining helper class for handling cell events---------



@interface ISRepeatReminderCellHandler : NSObject


@property (weak, nonatomic) IBOutlet UILabel *label;

@property (weak, nonatomic) IBOutlet UIImageView *selectedImage;

-(void)setLabel:(NSString *)text isSelected:(BOOL )isSelected;



@end


@interface ISRepeatReminderCell : UITableViewCell

@property ISRepeatReminderCellHandler *outletOwner;

-(void)setLabel:(NSString *)text isSelected:(BOOL )isSelected;


@end
