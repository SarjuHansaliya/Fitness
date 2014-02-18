//
//  ISProfileViewController.h
//  Fitness
//
//  Created by ispladmin on 11/02/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ISProfileViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;

@property (weak, nonatomic) IBOutlet UIButton *maleRB;
@property (weak, nonatomic) IBOutlet UIButton *femaleRB;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

- (IBAction)maleRBClicked:(id)sender;
- (IBAction)femaleRBClicked:(id)sender;

- (IBAction)saveUserData:(id)sender;
- (IBAction)viewDOBPicker:(id)sender;

@end








//-----------------------------custom view with keyboard dismiss-------------

@interface  UIViewDismissKB:UIView
@end
