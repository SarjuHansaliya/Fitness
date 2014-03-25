//
//  ISReportDetailsViewController.m
//  Fitness
//
//  Created by ispluser on 2/18/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import "ISReportDetailsViewController.h"
#import "ISPathViewController.h"
#import "ISAppDelegate.h"
#import "macros.h"
#import "ISSocialViewController.h"


@implementation UIView (Screenshot)

- (UIImage *)screenshot {
    //UIGraphicsBeginImageContext(self.bounds.size);
    if (!IS_IPHONE_5) {
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



@interface ISReportDetailsViewController ()

@end

@implementation ISReportDetailsViewController
{
    ISAppDelegate *appDel;
    UIView *blurView;
    __weak UIBarButtonItem *rightBarButtonItem;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        appDel=(ISAppDelegate *)[[UIApplication sharedApplication]delegate];
        self.shareButtonShouldBounce=NO;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupMenuItemsTouchEvents];
    [self setupNavigationBar];
    blurView=[[UIView alloc]initWithFrame:self.view.bounds];
    [blurView setBackgroundColor:[UIColor colorWithWhite:0.4 alpha:0.7]];
   
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [blurView setFrame:self.view.bounds];
    UINavigationItem *navItem=[self.navigationController.navigationBar.items lastObject];
    rightBarButtonItem=navItem.rightBarButtonItem;
    if (self.shareButtonShouldBounce) {
        [self addBounceAnimation];
        self.shareButtonShouldBounce=NO;
    }
    
    
}

-(void)viewWillDisappear:(BOOL)animated
{
   // [self stopHighlight];
}
-(void)viewDidDisappear:(BOOL)animated
{
    if (!IS_IPHONE_5) {
        [self.scrollView setContentOffset:CGPointZero];
    }

    
}
//-(void)stopHighlight
//{
//    
//    [rightBarButtonItem.customView stopGlowing];
//}
-(void)viewWillAppear:(BOOL)animated
{
    
    NSDateComponents *ageComponents = [[NSCalendar currentCalendar]
                                       components:NSMinuteCalendarUnit
                                       fromDate:self.workout.startTimeStamp
                                       toDate:self.workout.endTimeStamp
                                       options:0];
    
    self.woDurationLabel.text=[NSString stringWithFormat:@"%d Min",ageComponents.minute];
    self.distanceLabel.text=[NSString stringWithFormat:@"%.2f Miles", [self.workout.distance doubleValue]];
    if (appDel.isStepsCountingAvailable) {
        self.stepsLabel.text=[NSString stringWithFormat:@"%d Steps", [self.workout.steps intValue]];
    }
    else
    {
        self.stepsLabel.text=[NSString stringWithFormat:@"n/a"];
    }
    
    self.calBurnedLabel.text=[NSString stringWithFormat:@"%.2f kcal", [self.workout.calBurned doubleValue]/1000];
    if ([self.workout.minSpeed doubleValue]>999.0 || [self.workout.minSpeed doubleValue]< 0.00) {
        self.minSpeedLabel.text=[NSString stringWithFormat:@"- -"];
    }
    else
    {
        self.minSpeedLabel.text=[NSString stringWithFormat:@"%.1f mph",[self.workout.minSpeed doubleValue] ];
    }
    if ([self.workout.maxSpeed doubleValue]<=0.00) {
        self.maxSpeedLabel.text=[NSString stringWithFormat:@"- -"];
    }
    else
    {
        self.maxSpeedLabel.text=[NSString stringWithFormat:@"%.1f mph",[self.workout.maxSpeed doubleValue] ];
    }
    
    //double speed=[self.workout.distance doubleValue]/(ageComponents.minute/60.0);
   
    if ([self.workout.maxSpeed doubleValue]> 0.0 && [self.workout.minSpeed doubleValue]>= 0.0 && ageComponents.minute!=0.0) {
         double speed=([self.workout.maxSpeed doubleValue]+[self.workout.minSpeed doubleValue])/2.0;
        self.speedLabel.text=[NSString stringWithFormat:@"%.2f mph", speed];
    }
    else
        self.speedLabel.text=@"- -";

    
//    if (speed>=0.0 && ageComponents.minute!=0.0) {
//        self.speedLabel.text=[NSString stringWithFormat:@"%.2f mph", speed];
//    }
//    else
//        self.speedLabel.text=@"- -";
    
    
    
    NSArray *hrRecords=[ISHR getHRArrayWithStartTS:self.workout.startTimeStamp endTS:self.workout.endTimeStamp];
    
    if ([hrRecords count]==0 || hrRecords== nil) {
        self.hrLabel.text=@"n/a";
        self.minHRLabel.text=[NSString stringWithFormat:@"- -"];
        self.maxHRLabel.text=[NSString stringWithFormat:@"- -"];
    }
    else
    {
        int maxHR=0;
        int minHR=1000;
        int avgHR=0;
        
        for (ISHR *h in hrRecords) {
            if ([h.hr intValue]< minHR) {
                minHR=[h.hr intValue];
            }
            else if ([h.hr intValue]> maxHR) {
                maxHR=[h.hr intValue];
            }
            
            avgHR+=[h.hr intValue];
            
        }
        avgHR=avgHR/[hrRecords count];
        
        self.hrLabel.text=[NSString stringWithFormat:@"%d bpm",avgHR];
        self.minHRLabel.text=[NSString stringWithFormat:@"%d bpm",minHR];
        self.maxHRLabel.text=[NSString stringWithFormat:@"%d bpm",maxHR];
    }
    int goalId=self.workout.woGoalId;
    double completed;
    if (goalId!=0)
    {
        ISWOGoal *goal=[ISWOGoal getWOGoalWithId:goalId];
        
        switch (goal.goalType) {
            case MILES:
                
                completed=([self.workout.distance doubleValue])/[goal.goalValue doubleValue]*100.0;
                break;
            case CALORIES:
                
                completed=([self.workout.calBurned doubleValue]/1000)/[goal.goalValue doubleValue]*100.0;
                break;
            case DURATION:
                
                completed=(ageComponents.minute)/[goal.goalValue doubleValue]*100.0;
                break;
        }
        if (completed>100.0) {
            completed=100.0;
        }
        self.goalLabel.text=[NSString stringWithFormat:@"%.0f %%",completed];
        
    }
    else
    {
        self.goalLabel.text=@"- -";
    }
    
}
-(void)setupNavigationBar
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
    self.wantsFullScreenLayout=YES;
    
    
    self.navigationController.navigationBar.translucent=NO;
    
    UILabel *titleLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 27)];
    
    titleLable.backgroundColor=[UIColor clearColor];
    titleLable.text=@"Workout Details";
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
    
    
    
    
    // [backButton setTintColor: [UIColor colorWithHue:31.0/360.0 saturation:99.0/100.0 brightness:87.0/100.0 alpha:1]];
    [self.navigationItem setLeftBarButtonItem:backButton];
    [self.navigationItem setRightBarButtonItem:addButton];
    
    
    
}

-(void)setUpPopover:(id)sender
{
    //NSLog(@"popover retain count: %d",[popover retainCount]);
   // [self stopHighlight];
    SAFE_ARC_RELEASE(popover);
    self.popover=nil;
    
    [self.view addSubview:blurView];
    blurView.alpha=0.0;

    
    [UIView animateWithDuration:0.2 animations:^{
        
        blurView.alpha=1.0;
        
    } completion:^(BOOL finished) {
    
        //the controller we want to present as a popover
        ISSocialViewController *controller = [[ISSocialViewController alloc] initWithNibName:nil bundle:nil delegate:self];
        if (!IS_IPHONE_5) {
            [self.scrollView setContentOffset:CGPointMake(0, 0)];
        }
        controller.initialText=@"Checkout my workout from 'Stay Fit'...";
        
        self.popover = [[FPPopoverController alloc] initWithViewController:controller delegate:self];
        self.popover.tint=FPPopoverRedTint;
        self.popover.arrowDirection = FPPopoverArrowDirectionUp;
        self.popover.contentSize = CGSizeMake(150 ,120);
        self.popover.arrowDirection = FPPopoverArrowDirectionAny;
        self.popover.border=NO;
        controller.popover=self.popover;
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


-(UIImage*)imageToShare
{
    [blurView removeFromSuperview];
    return [self.view screenshot];
}


-(void)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


//----------------------------handling touch events on items---------------
-(void)setupMenuItemsTouchEvents
{
    UITapGestureRecognizer *tapOnMapView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(displayPathOnMap:)] ;
    tapOnMapView.numberOfTapsRequired=1;
    [self.mapPathView addGestureRecognizer:tapOnMapView];
    
    UITapGestureRecognizer *tapOnDeleteView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(deleteReport:)] ;
    tapOnDeleteView.numberOfTapsRequired=1;
    [self.deleteReportView addGestureRecognizer:tapOnDeleteView];
    
    
    
    
}
-(void) displayPathOnMap:(id)sender
{
    
    [(UINavigationController*)[(ISAppDelegate *)[[UIApplication sharedApplication]delegate] drawerController].centerViewController pushViewController:[[ISPathViewController alloc] initWithNibName:nil bundle:nil workout:self.workout] animated:YES];
}
-(void) deleteReport:(id)sender
{
    [self.workout deleteWorkout];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) addBounceAnimation {
//	if (!CGRectContainsPoint(rightBarButtonItem.customView.frame, CGPointMake(160, 200))) {
//		rightBarButtonItem.customView.frame = CGRectMake(10, 10, 40, 40);
//		rightBarButtonItem.customView.center = CGPointMake(160, 200);
//		return;
//	}
	
	
	NSString *keyPath = @"transform";
	CATransform3D transform = rightBarButtonItem.customView.layer.transform;
    id fromValue = [NSValue valueWithCATransform3D:
                     CATransform3DScale(transform, 0.6, 0.6, 0.6)
                     ];
	id finalValue = [NSValue valueWithCATransform3D:
                     CATransform3DScale(transform, 1.0, 1.0, 1.0)
                     ];
    
	SKBounceAnimation *bounceAnimation = [SKBounceAnimation animationWithKeyPath:keyPath];
//	bounceAnimation.fromValue = [NSValue valueWithCATransform3D:transform];
    bounceAnimation.fromValue = fromValue;
	bounceAnimation.toValue = finalValue;
	bounceAnimation.duration = 3.0f;
	bounceAnimation.numberOfBounces = 6;
	bounceAnimation.shouldOvershoot = YES;
	
	[rightBarButtonItem.customView.layer addAnimation:bounceAnimation forKey:@"someKey"];
	
	//[rightBarButtonItem.customView.layer setValue:finalValue forKeyPath:keyPath];
    
}

@end
