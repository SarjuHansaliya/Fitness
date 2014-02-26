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


@property (weak, nonatomic) IBOutlet UILabel *alertLabel;


@property (weak, nonatomic) IBOutlet UITextField *toDateTextField;
@property (strong, nonatomic) IBOutlet UIToolbar *accessoryView;


- (IBAction)doneEditing:(id)sender;





@property (nonatomic) ISReminderRepeatViewController *repeatController;
@property (nonatomic) ISReminderAlertViewController *alertController;

@end
