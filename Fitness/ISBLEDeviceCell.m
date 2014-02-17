//
//  ISBLEDeviceCell.m
//  Fitness
//
//  Created by ispluser on 2/14/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import "ISBLEDeviceCell.h"

//---------------implementing helper class for handling cell events---------


@implementation ISBLEDeviceCellHandler


@end


@implementation ISBLEDeviceCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        ISBLEDeviceCellHandler * outletOwner=[[ISBLEDeviceCellHandler alloc]init];
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ISConnectionManagerTableCell" owner:outletOwner options:nil];
        self = [topLevelObjects objectAtIndex:0];
        self.outletOwner=outletOwner;
        self.backgroundColor=[UIColor clearColor];
    }
    return self;
}

-(void)setDeviceLabelText:(NSString *)deviceName
{
    self.outletOwner.deviceNameLabel.text=deviceName;
}
-(void)setSelectedDeviceImageHidden:(BOOL)b
{
    self.outletOwner.selectedDeviceImageView.hidden=b;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
