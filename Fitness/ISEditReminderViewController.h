//
//  ISEditReminderViewController.h
//  Fitness
//
//  Created by ispluser on 2/17/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISReminderRepeatViewController.h"
#import "macros.h"

#import "ISReminderAlertViewController.h"


@interface ISEditReminderViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *startView;
@property (weak, nonatomic) IBOutlet UIView *alertView;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIView *repeatView;

@property (weak, nonatomic) IBOutlet UILabel *dateTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeTextLabel;

@property (weak, nonatomic) IBOutlet UIView *doneButtonView;
@property (weak, nonatomic) IBOutlet UILabel *repeatLabel;
@property (weak, nonatomic) IBOutlet UILabel *alertLabel;



- (IBAction)datePickerValueChanged:(id)sender;

- (IBAction)doneButtonClicked:(id)sender;


@property (nonatomic) ISReminderRepeatViewController *repeatController;
@property (nonatomic) ISReminderAlertViewController *alertController;

@end
