//
//  ISReportDetailsViewController.h
//  Fitness
//
//  Created by ispluser on 2/18/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISWorkOut.h"
#import "FPPopoverController.h"
#import "SKBounceAnimation.h"

@interface ISReportDetailsViewController : UIViewController<FPPopoverControllerDelegate>


@property (weak, nonatomic) IBOutlet UIView *mapPathView;
@property (weak, nonatomic) IBOutlet UILabel *hrLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxHRLabel;
@property (weak, nonatomic) IBOutlet UILabel *minHRLabel;
@property (weak, nonatomic) IBOutlet UILabel *calBurnedLabel;
@property (weak, nonatomic) IBOutlet UILabel *woDurationLabel;
@property (weak, nonatomic) IBOutlet UILabel *goalLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *stepsLabel;
@property (weak, nonatomic) IBOutlet UILabel *minSpeedLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxSpeedLabel;
@property (weak, nonatomic) IBOutlet UILabel *speedLabel;
@property (weak, nonatomic) IBOutlet UIView *deleteReportView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak) ISWorkOut *workout;

@property FPPopoverController *popover;

-(UIImage*)imageToShare;

@end
