//
//  ISReminderCell.h
//  Fitness
//
//  Created by ispluser on 2/14/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import <UIKit/UIKit.h>


//-----------------defining helper class for handling cell events---------

@protocol ISReminderCellDelegate <NSObject>

-(void)deleteButtonClickedInCell:(id)sender;

@end

@interface ISReminderCellHandler : NSObject

@property (weak, nonatomic) IBOutlet UISwitch *reminderSwitch;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UILabel *reminderTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *reminderDaysLabel;
@property (weak, nonatomic) IBOutlet UILabel *reminderLabel;
@property (weak, nonatomic) IBOutlet UIView *editView;


@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

-(void)setReminderTime:(NSDate*)time reminderOnDays:(NSArray *)days;
- (IBAction)reminderSwitchValueChanged:(id)sender;


@end



@interface ISReminderCell : UITableViewCell


@property ISReminderCellHandler *outletOwner;
-(void)setReminderTime:(NSDate *)time reminderOnDays:(NSArray *)days viewController:(UIViewController*)vc;

@property (nonatomic,weak) id delegate;
@end


