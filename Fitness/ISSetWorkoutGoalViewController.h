//
//  ISSetWorkoutGoalViewController.h
//  Fitness
//
//  Created by ispluser on 2/12/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISWOGoal.h"

@interface ISSetWorkoutGoalViewController : UIViewController

@property (weak) ISWOGoal *woGoal;

@property (weak, nonatomic) IBOutlet UIButton *milesRB;
@property (weak, nonatomic) IBOutlet UIButton *caloriesRB;
@property (weak, nonatomic) IBOutlet UIButton *durationRB;
@property (weak, nonatomic) IBOutlet UIView *openRemindersView;
@property (weak, nonatomic) IBOutlet UITextField *milesTextField;
@property (weak, nonatomic) IBOutlet UITextField *caloriesTextField;
@property (weak, nonatomic) IBOutlet UITextField *durationTextField;
@property (weak, nonatomic) IBOutlet UIView *enableWOGoal;


- (IBAction)durationRBClicked:(id)sender;
- (IBAction)caloriesRBClicked:(id)sender;
- (IBAction)milesRBClicked:(id)sender;
- (IBAction)durationTFClicked:(id)sender;
- (IBAction)caloriesTFClicked:(id)sender;
- (IBAction)milesTFClicked:(id)sender;
- (IBAction)setNewWOGoal:(id)sender;



@end
