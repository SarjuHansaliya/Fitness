//
//  ISSocialViewController.h
//  Fitness
//
//  Created by ispluser on 3/20/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FPPopoverController.h"

@interface ISSocialViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *facebookView;
@property (weak, nonatomic) IBOutlet UIView *twitterView;

@property UIImage *imageToshare;
@property NSString *initialText;
@property (weak) FPPopoverController *popover;
@property (weak) UIViewController *delegate;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil delegate:(UIViewController*)delegate;

@end
