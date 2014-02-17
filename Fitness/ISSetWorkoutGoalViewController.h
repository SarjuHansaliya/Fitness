//
//  ISSetWorkoutGoalViewController.h
//  Fitness
//
//  Created by ispluser on 2/12/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ISSetWorkoutGoalViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *milesRB;
@property (weak, nonatomic) IBOutlet UIButton *caloriesRB;
@property (weak, nonatomic) IBOutlet UIButton *durationRB;
- (IBAction)durationRBClicked:(id)sender;
- (IBAction)caloriesRBClicked:(id)sender;
- (IBAction)milesRBClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *openRemindersView;

@end
