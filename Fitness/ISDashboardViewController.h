//
//  ISDashboardViewController.h
//  Fitness
//
//  Created by ispluser on 2/11/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+MMDrawerController.h"

@interface ISDashboardViewController : UIViewController



@property (weak, nonatomic) IBOutlet UIView *mapPathView;
@property (weak, nonatomic) IBOutlet UIView *reportView;
@property (weak, nonatomic) IBOutlet UILabel *hrLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxHRLabel;
@property (weak, nonatomic) IBOutlet UILabel *minHRLabel;
@property (weak, nonatomic) IBOutlet UILabel *calBurnedLabel;
@property (weak, nonatomic) IBOutlet UIButton *startWOButton;
@property (weak, nonatomic) IBOutlet UILabel *woDurationLabel;
@property (weak, nonatomic) IBOutlet UILabel *goalLabel;

@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *stepsLabel;
@property (weak, nonatomic) IBOutlet UILabel *minSpeedLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxSpeedLabel;
@property (weak, nonatomic) IBOutlet UILabel *speedLabel;



- (IBAction)workoutStart:(id)sender;

-(void)didUpdateCurrentHeartRate:(NSNumber *)currHr maxHeartRate:(NSNumber *)maxHr minHeartRate:(NSNumber *)minHr;

-(void)didUpdateLocation;

@end
