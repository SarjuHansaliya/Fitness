//
//  ISReminderCellViewController.m
//  Fitness
//
//  Created by ispluser on 2/13/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import "ISReminderCellViewController.h"

@interface ISReminderCellViewController ()

@end

@implementation ISReminderCellViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil reminderTime:(NSDate*)time reminderOnDays:(NSArray *)days
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
        formatter.dateFormat=@"hh:mm a";
        self.reminderTimeLabel.text=[formatter stringFromDate:time];
        
        NSMutableString *ms=[[NSMutableString alloc]init];
        for (NSString *s in days) {
            [ms appendString:s];
            [ms appendString:@", "];
        }
        
        
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)reminderSwitchValueChanged:(id)sender {
    
    self.backgroundImage.hidden=self.reminderSwitch.on;
    UIColor *color535353=[UIColor colorWithRed:83.0/255.0 green:83.0/253.0 blue:83.0/253.0 alpha:1];
    if (self.reminderSwitch.on) {
        self.reminderTimeLabel.textColor=[UIColor blackColor];
        self.reminderDaysLabel.textColor=[UIColor blackColor];
    }
    else
    {
        self.reminderTimeLabel.textColor=color535353;
        self.reminderDaysLabel.textColor=color535353;
        
    }
    
    
}
@end
