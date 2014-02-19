//
//  ISHRMonitorViewController.h
//  Fitness
//
//  Created by ispluser on 2/14/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ISHRMonitorViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *buttonFromDate;
- (IBAction)buttonToDateClicked:(id)sender;
- (IBAction)buttonFromDateClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;


@property (weak, nonatomic) IBOutlet UITextField *fromDateTextField;

@property (weak, nonatomic) IBOutlet UITextField *toDateTextField;
@property (strong, nonatomic) IBOutlet UIToolbar *accessoryView;


- (IBAction)doneEditing:(id)sender;



@end
