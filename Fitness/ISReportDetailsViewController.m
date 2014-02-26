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

@interface ISReportDetailsViewController ()

@end

@implementation ISReportDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupMenuItemsTouchEvents];
    [self setupNavigationBar];
}
-(void)viewWillAppear:(BOOL)animated
{
    
    NSDateComponents *ageComponents = [[NSCalendar currentCalendar]
                                       components:NSMinuteCalendarUnit
                                       fromDate:self.workout.startTimeStamp
                                       toDate:self.workout.endTimeStamp
                                       options:0];
    
    self.woDurationLabel.text=[NSString stringWithFormat:@"%d Min",ageComponents.minute];
    self.distanceLabel.text=[NSString stringWithFormat:@"%.2f Miles", [self.workout.distance doubleValue]];
    self.stepsLabel.text=[NSString stringWithFormat:@"%d Steps", [self.workout.steps intValue]];
    self.calBurnedLabel.text=[NSString stringWithFormat:@"%.2f kcal", [self.workout.calBurned doubleValue]/1000];
    if ([self.workout.minSpeed doubleValue]>999.0 || [self.workout.minSpeed doubleValue]< 0.00) {
        self.minSpeedLabel.text=[NSString stringWithFormat:@"Min - mph"];
    }
    else
    {
        self.minSpeedLabel.text=[NSString stringWithFormat:@"Min - %.1f mph",[self.workout.minSpeed doubleValue] ];
    }
    if ([self.workout.maxSpeed doubleValue]<=0.00) {
        self.maxSpeedLabel.text=[NSString stringWithFormat:@"Max - mph"];
    }
    else
    {
        self.maxSpeedLabel.text=[NSString stringWithFormat:@"Max - %.1f mph",[self.workout.maxSpeed doubleValue] ];
    }
    
    double speed=[self.workout.distance doubleValue]/(ageComponents.minute/60.0);
    if (speed>=0.0 && ageComponents.minute!=0.0) {
        self.speedLabel.text=[NSString stringWithFormat:@"%.2f mph", speed];
    }
    else
        self.speedLabel.text=@"- -";
    
    
    
    NSArray *hrRecords=[ISHR getHRArrayWithStartTS:self.workout.startTimeStamp endTS:self.workout.endTimeStamp];
    
    if ([hrRecords count]==0 || hrRecords== nil) {
        self.hrLabel.text=@"0 bpm";
        self.minHRLabel.text=[NSString stringWithFormat:@"Min - 0 bpm"];
        self.maxHRLabel.text=[NSString stringWithFormat:@"Max - 0 bpm"];
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
        self.minHRLabel.text=[NSString stringWithFormat:@"Min - %d bpm",minHR];
        self.maxHRLabel.text=[NSString stringWithFormat:@"Max - %d bpm",maxHR];
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
    
    
    
    
    // [backButton setTintColor: [UIColor colorWithHue:31.0/360.0 saturation:99.0/100.0 brightness:87.0/100.0 alpha:1]];
    [self.navigationItem setLeftBarButtonItem:backButton];
    
    
    
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

@end
