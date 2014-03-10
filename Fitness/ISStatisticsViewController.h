//
//  ISStatisticsViewController.h
//  Fitness
//
//  Created by ispluser on 3/10/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ISStatisticsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *workoutsLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxDurationLabel;
@property (weak, nonatomic) IBOutlet UILabel *avgDurationLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxDistanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *avgDistanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *caloriesLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxCaloriesLabel;
@property (weak, nonatomic) IBOutlet UILabel *avgCaloriesLabel;
@property (weak, nonatomic) IBOutlet UILabel *stepsLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxStepsLabel;
@property (weak, nonatomic) IBOutlet UILabel *avgStepsLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxSpeedLabel;
@property (weak, nonatomic) IBOutlet UILabel *avgSpeedLabel;


@end
