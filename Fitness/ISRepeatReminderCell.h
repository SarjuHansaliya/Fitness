//
//  ISRepeatReminderCell.h
//  Fitness
//
//  Created by ispluser on 2/19/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface ISRepeatReminderCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *label;

@property (weak, nonatomic) IBOutlet UIImageView *selectedImage;

-(void)setLabel:(NSString *)text isSelected:(BOOL )isSelected;


@end
