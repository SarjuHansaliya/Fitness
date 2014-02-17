//
//  ISEditReminderViewController.h
//  Fitness
//
//  Created by ispluser on 2/17/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ISEditReminderViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *cancelView;
@property (weak, nonatomic) IBOutlet UIView *saveView;

@property (weak, nonatomic) IBOutlet UIView *startView;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIView *repeatView;

@end
