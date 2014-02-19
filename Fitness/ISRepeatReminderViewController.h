//
//  ISRepeatReminderViewController.h
//  Fitness
//
//  Created by ispluser on 2/17/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ISRepeatReminderViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *neverView;
@property (weak, nonatomic) IBOutlet UIView *everyDayView;
@property (weak, nonatomic) IBOutlet UIView *everyWeekView;
@property (weak, nonatomic) IBOutlet UIView *every2WeekView;
@property (weak, nonatomic) IBOutlet UIView *everyMonthView;
@property (weak, nonatomic) IBOutlet UIView *everyYearView;


@property (weak, nonatomic) IBOutlet UIImageView *neverViewImage;
@property (weak, nonatomic) IBOutlet UIImageView *everyDayViewImage;
@property (weak, nonatomic) IBOutlet UIImageView *everyWeekViewImage;
@property (weak, nonatomic) IBOutlet UIImageView *every2WeekViewImage;
@property (weak, nonatomic) IBOutlet UIImageView *everyMonthViewImage;
@property (weak, nonatomic) IBOutlet UIImageView *everyYearViewImage;


@end
