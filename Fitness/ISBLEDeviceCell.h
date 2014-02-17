//
//  ISBLEDeviceCell.h
//  Fitness
//
//  Created by ispluser on 2/14/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import <UIKit/UIKit.h>

//-----------------defining helper class for handling cell events---------



@interface ISBLEDeviceCellHandler : NSObject
@property (weak, nonatomic) IBOutlet UILabel *deviceNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectedDeviceImageView;



@end


@interface ISBLEDeviceCell : UITableViewCell

@property ISBLEDeviceCellHandler *outletOwner;

-(void)setDeviceLabelText:(NSString *)deviceName;
-(void)setSelectedDeviceImageHidden:(BOOL)b;
@end
