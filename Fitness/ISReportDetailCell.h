//
//  ISReportDetailCell.h
//  Fitness
//
//  Created by ispluser on 2/18/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface ISReportDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *goalTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *workoutDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *goalValueLabel;



-(void)setGoalTypeLabel:(NSString *)goalType workoutDateLabel:(NSDate *)date goalValueLabel:(NSString *)goalValue;

@end
