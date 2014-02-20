//
//  ISBLEDeviceCell.h
//  Fitness
//
//  Created by ispluser on 2/14/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface ISBLEDeviceCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *deviceNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectedDeviceImageView;


-(void)setDeviceLabelText:(NSString *)deviceName;
-(void)setSelectedDeviceImageHidden:(BOOL)b;
@end
