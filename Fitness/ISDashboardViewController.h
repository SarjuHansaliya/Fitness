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
@property (weak, nonatomic) IBOutlet UIView *startWorkoutView;

-(void)didUpdateCurrentHeartRate:(NSNumber *)currHr maxHeartRate:(NSNumber *)maxHr minHeartRate:(NSNumber *)minHr;
@property (weak, nonatomic) IBOutlet UILabel *hrLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxHRLabel;
@property (weak, nonatomic) IBOutlet UILabel *minHRLabel;

@end
