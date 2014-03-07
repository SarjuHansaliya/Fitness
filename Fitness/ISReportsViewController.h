//
//  ISReportsViewController.h
//  Fitness
//
//  Created by ispluser on 2/18/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ISReportsViewController : UITableViewController <UIActionSheetDelegate>

@property BOOL showDatePicker;

@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;

- (IBAction)doneEditing:(id)sender;

@end
