//
//  ISNewReminderViewController.m
//  Fitness
//
//  Created by ispluser on 2/17/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import "ISNewReminderViewController.h"

@interface ISNewReminderViewController ()

@end

@implementation ISNewReminderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupGestureRecognizer];
    // Do any additional setup after loading the view from its nib.
}

//--------------------------setting up gesture recognizer----------------------------


-(void)setupGestureRecognizer
{
    UITapGestureRecognizer *tapOnCancel = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelClicked:)];
    tapOnCancel.numberOfTapsRequired=1;
    [self.cancelView addGestureRecognizer:tapOnCancel];
    
    UITapGestureRecognizer *tapOnSave = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(saveClicked:)];
    tapOnSave.numberOfTapsRequired=1;
    [self.saveView addGestureRecognizer:tapOnSave];
    
    UITapGestureRecognizer *tapOnStart = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(startClicked:)];
    tapOnStart.numberOfTapsRequired=1;
    [self.startView addGestureRecognizer:tapOnStart];
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





//------------------------------Events ------------------------------------



-(void)cancelClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)saveClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)startClicked:(id)sender
{
    [UIView animateWithDuration:1.0 animations:^{
        [self.datePicker setHidden:!self.datePicker.hidden];
    }];
    
    
}


@end
