//
//  ISReminderCellViewController.h
//  Fitness
//
//  Created by ispluser on 2/13/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ISReminderCellViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISwitch *reminderSwitch;
- (IBAction)reminderSwitchValueChanged:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UILabel *reminderTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *reminderDaysLabel;


@end
