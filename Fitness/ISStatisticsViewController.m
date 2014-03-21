//
//  ISStatisticsViewController.m
//  Fitness
//
//  Created by ispluser on 3/10/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import "ISStatisticsViewController.h"
#import "macros.h"
#import "ISAppDelegate.h"
#import "ISWorkOut.h"
#import <Social/Social.h>
#import "ILAlertView.h"
#import "MBProgressHUD.h"
#import "ISSocialViewController.h"


@implementation UIView (Screenshot)

- (UIImage *)screenshot:(BOOL)stepCounting {
    //UIGraphicsBeginImageContext(self.bounds.size);
    if (stepCounting) {
         UIGraphicsBeginImageContext(CGSizeMake(self.bounds.size.width, self.bounds.size.height-140.0));
    }
    else if(!IS_IPHONE_5)
    {
        UIGraphicsBeginImageContext(CGSizeMake(self.bounds.size.width, self.bounds.size.height-115.0));
    }
    else
    {
        UIGraphicsBeginImageContext(CGSizeMake(self.bounds.size.width, self.bounds.size.height-200.0));
    }
   
    if([self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]){
        [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
    }
    else{
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
//    NSData *imageData = UIImageJPEGRepresentation(image, 0.75);
//    image = [UIImage imageWithData:imageData];
    return image;
}

@end

@interface ISStatisticsViewController ()

@end

@implementation ISStatisticsViewController
{
    ISAppDelegate *appDel;
    double workouts;
    double duration;
    double maxDuration;
    double avgDuration;
    double distance;
    double maxDistance;
    double avgDistance;
    double calories;
    double maxCalories;
    double avgCalories;
    double steps;
    double maxSteps;
    double avgSteps;
    double maxSpeed;
    double avgSpeed;
    
    UIView *blurView;
    
    
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        appDel=(ISAppDelegate*)[[UIApplication sharedApplication]delegate];
       
        
    }
    return self;
}
-(void)initialize
{
    workouts = 0;
    duration = 0;
     workouts = 0;
    duration = 0;
    maxDuration = 0;
    avgDuration = 0;
    distance = 0;
    maxDistance = 0;
    avgDistance = 0;
    calories = 0;
    maxCalories = 0;
    avgCalories = 0;
    steps = 0;
    maxSteps = 0;
    avgSteps = 0;
    maxSpeed = 0;
    avgSpeed = 0;
}

-(void)viewWillAppear:(BOOL)animated
{
    if (animated) {
        [self initialize];
        [self calculateStatastics];
        [self fillLabelValues];
    }
    
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [blurView setFrame:self.view.bounds];
}




-(void)setUpPopover:(id)sender
{
    //NSLog(@"popover retain count: %d",[popover retainCount]);
    
    SAFE_ARC_RELEASE(popover);
    self.popover=nil;
    
    //the controller we want to present as a popover
    [self.view addSubview:blurView];
    blurView.alpha=0.0;
    
//    [UIView transitionWithView:blurView duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
//        blurView.alpha=0.7;
//    } completion:^(BOOL finished) {
//        ISSocialViewController *controller = [[ISSocialViewController alloc] initWithNibName:nil bundle:nil delegate:self];
//        
//        controller.initialText=@"Checkout my workout statistics from 'Stay Fit'...";
//        
//        self.popover = [[FPPopoverController alloc] initWithViewController:controller delegate:self];
//        self.popover.tint=FPPopoverRedTint;
//        self.popover.arrowDirection = FPPopoverArrowDirectionUp;
//        //self.popover.title=@"Select";
//        
//        self.popover.contentSize = CGSizeMake(150 ,120);
//        
//        self.popover.border=NO;
//        [self.popover setShadowsHidden:YES];
//        controller.popover=self.popover;
//        //[self.popover presentPopoverFromPoint: CGPointMake(self.view.center.x, self.view.center.y - self.popover.contentSize.height/2)];
//        [self.popover presentPopoverFromView:sender];
//    }];
//    
    [UIView animateWithDuration:0.2 animations:^{
        
        blurView.alpha=1.0;
        
    } completion:^(BOOL finished) {
        ISSocialViewController *controller = [[ISSocialViewController alloc] initWithNibName:nil bundle:nil delegate:self];
        
        controller.initialText=@"Checkout my workout statistics from 'Stay Fit'...";
        
        self.popover = [[FPPopoverController alloc] initWithViewController:controller delegate:self];
        self.popover.tint=FPPopoverRedTint;
        self.popover.arrowDirection = FPPopoverArrowDirectionUp;
        //self.popover.title=@"Select";
        
        self.popover.contentSize = CGSizeMake(150 ,120);
        
        self.popover.border=NO;
        [self.popover setShadowsHidden:YES];
        controller.popover=self.popover;
        //[self.popover presentPopoverFromPoint: CGPointMake(self.view.center.x, self.view.center.y - self.popover.contentSize.height/2)];
        [self.popover presentPopoverFromView:sender];
    }];
    
    
   

    
}
- (void)popoverControllerDidDismissPopover:(FPPopoverController *)popoverController
{
//    [UIView animateWithDuration:0.2 animations:^{
//        blurView.alpha=0.0;
//    } completion:^(BOOL finished) {
//         [blurView removeFromSuperview];
//    }];
    [blurView removeFromSuperview];
   
}
- (void)presentedNewPopoverController:(FPPopoverController *)newPopoverController
          shouldDismissVisiblePopover:(FPPopoverController*)visiblePopoverController
{
    
}
-(UIImage*)imageToShare
{
    
    [blurView removeFromSuperview];
    return [self.view screenshot:appDel.isStepsCountingAvailable];
}



-(void)calculateStatastics
{
    NSMutableArray *wo=[NSMutableArray arrayWithArray:[ISWorkOut getWorkouts]];
    
    if (appDel.woHandler.isWOStarted) {
        
        for (ISWorkOut *w in wo) {
            if (w.woId==appDel.woHandler.currentWO.woId) {
                [wo removeObject:w];
                break;
            }
        }
    }

    
    
    workouts=[wo count];
    
    if (workouts==0) {
        
        [self initialize];
    }
    else{
        
        for (ISWorkOut *w in wo) {
            distance+=[w.distance doubleValue];
            steps+=[w.steps doubleValue];
            calories+=[w.calBurned doubleValue]/1000.0;
            duration+=[w.endTimeStamp timeIntervalSinceDate:w.startTimeStamp]/60.0;
            
            if (maxCalories<[w.calBurned doubleValue]) {
                maxCalories=[w.calBurned doubleValue];
            }
            if (maxDistance<[w.distance doubleValue]) {
                maxDistance=[w.distance doubleValue];
            }
            if (maxSteps<[w.steps doubleValue]) {
                maxSteps=[w.steps doubleValue];
            }
            if (maxSpeed<[w.maxSpeed doubleValue]) {
                maxSpeed=[w.maxSpeed doubleValue];
            }
            if (maxDuration<[w.endTimeStamp timeIntervalSinceDate:w.startTimeStamp]/60.0) {
                maxDuration=[w.endTimeStamp timeIntervalSinceDate:w.startTimeStamp]/60.0;
            }
            
        }
        
        if (duration<0) {
            duration=0;
        }
        
        avgCalories=calories/workouts;
        avgDistance=distance/workouts;
        avgDuration=duration/workouts;
        
        if (duration==0) {
            avgSpeed=0;
        }
        else
        {
            avgSpeed=distance/duration;
        }
        
        avgSteps=steps/workouts;
        
        if (avgSpeed<0) {
            avgSpeed=0;
        }
    
    }
}

-(void)fillLabelValues
{
    self.workoutsLabel.text=[NSString stringWithFormat:@"%.0f",workouts];
    self.durationLabel.text=[NSString stringWithFormat:@"%.0f min",duration];
    self.maxDurationLabel.text=[NSString stringWithFormat:@"%.0f min",maxDuration];
    self.avgDurationLabel.text=[NSString stringWithFormat:@"%.0f min",avgDuration];
    self.distanceLabel.text=[NSString stringWithFormat:@"%.2f mile",distance];
    self.maxDistanceLabel.text=[NSString stringWithFormat:@"%.2f mile",maxDistance];
    self.avgDistanceLabel.text=[NSString stringWithFormat:@"%.2f mile",avgDistance];
    if (appDel.isStepsCountingAvailable) {
        self.stepsLabel.text=[NSString stringWithFormat:@"%.0f",steps];
        self.maxStepsLabel.text=[NSString stringWithFormat:@"%.0f",maxSteps];
        self.avgStepsLabel.text=[NSString stringWithFormat:@"%.0f",avgSteps];
    }
    else
    {
        self.stepsLabel.text=[NSString stringWithFormat:@"n/a"];
        self.maxStepsLabel.text=[NSString stringWithFormat:@"- -"];
        self.avgStepsLabel.text=[NSString stringWithFormat:@"- -"];
    }
    
    
    self.caloriesLabel.text=[NSString stringWithFormat:@"%.2f kcal",calories];
    self.maxCaloriesLabel.text=[NSString stringWithFormat:@"%.2f kcal",maxCalories];
    self.avgCaloriesLabel.text=[NSString stringWithFormat:@"%.2f kcal",avgCalories];
    self.maxSpeedLabel.text=[NSString stringWithFormat:@"%.2f mph",maxSpeed];
    self.avgSpeedLabel.text=[NSString stringWithFormat:@"%.2f mph",avgSpeed];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupNavigationBar];
    blurView=[[UIView alloc]initWithFrame:self.view.bounds];
    [blurView setBackgroundColor:[UIColor colorWithWhite:0.4 alpha:0.7]];
    
    
}

-(void)setupNavigationBar
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
    self.wantsFullScreenLayout=YES;
    
    
    self.navigationController.navigationBar.translucent=NO;
    
    UILabel *titleLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 25)];
    
    titleLable.backgroundColor=[UIColor clearColor];
    titleLable.text=@"Statistics";
    titleLable.font=[UIFont fontWithName:@"Arial" size:20.0];
    titleLable.textColor= [UIColor colorWithHue:31.0/360.0 saturation:99.0/100.0 brightness:87.0/100.0 alpha:1];
    
    self.navigationItem.titleView=titleLable;
    self.navigationItem.titleView.backgroundColor=[UIColor clearColor];
    float xSpace=SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")?-10.0f:-0.0f;
    
    
    UIView *backView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [backView setBackgroundColor:[UIColor clearColor]];
    UITapGestureRecognizer *tapBack=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goBack:)];
    tapBack.numberOfTapsRequired=1;
    [backView addGestureRecognizer:tapBack];
    UIButton *backButtonCustom = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButtonCustom setFrame:CGRectMake(xSpace, 3.0f, 25.0f, 25.0f)];
    [backButtonCustom addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    [backButtonCustom setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backView addSubview:backButtonCustom];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backView];
    
    UIButton *addButtonCustom = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButtonCustom setFrame:CGRectMake(0.0f, 0.0f, 25.0f, 25.0f)];
    [addButtonCustom addTarget:self action:@selector(setUpPopover:) forControlEvents:UIControlEventTouchUpInside];
    [addButtonCustom setImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithCustomView:addButtonCustom];
    
    
    
    [self.navigationItem setRightBarButtonItem:addButton];
    
    [self.navigationItem setLeftBarButtonItem:backButton];
    
   
    
}

-(void)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
