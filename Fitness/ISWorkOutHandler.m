//
//  ISWorkOutHandler.m
//  Fitness
//
//  Created by ispluser on 2/21/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import "ISWorkOutHandler.h"
#import "ISAppDelegate.h"
#import "ILAlertView.h"
#import "ISLocation.h"
#import "macros.h"
#define LOCATIONS_SAVE_DELAY 30.0
#define WORKOUT_SAVE_DELAY 30.0



@implementation ISWorkOutHandler
{
    ISAppDelegate *appDel;
}


static ISWorkOutHandler *sharedInstance = nil;

+(ISWorkOutHandler*)getSharedInstance{
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone:NULL]init];
        [sharedInstance firstTime];
    }
    return sharedInstance;
}
+(void)reset
{
    sharedInstance=nil;
}
-(void)firstTime
{
    
    self.userDetails=[ISUserDetails getUserDetails];
    if (self.userDetails==nil) {
        self.isUserProfileSet=NO;
        self.userDetails=[[ISUserDetails alloc]init];
    }
    else
        self.isUserProfileSet=YES;
    
    self.woGoal=[ISWOGoal getWOGoal];
    if (self.woGoal==nil) {
        self.isWOGoalEnable=NO;
        self.woGoal=[[ISWOGoal alloc]init];
    }
    else
        self.isWOGoalEnable=YES;
    
    self.locationManager=[[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    self.locationManager.activityType=CLActivityTypeFitness;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    self.isDeviceConnected=NO;
    self.isWOStarted=NO;
    
    if (appDel.isStepsCountingAvailable) {
        self.stepCounter=[[CMStepCounter alloc]init];
    }
    self.musicController=[[ISMusicController alloc]init];
    [self.musicController initialize];
    
    appDel=(ISAppDelegate*)[[UIApplication sharedApplication]delegate];
    
    
}
//-------------------------------setting workout object------------------

-(void)setupNewWorkout
{
    self.currentWO=[[ISWorkOut alloc]init];
    self.currentWO.startTimeStamp=[NSDate date];
    self.currentWO.minSpeed=@1000.0;
    self.currentWO.maxSpeed=@0.0;
    self.currentWO.distance=@0.0;
    
}
//-------------------------------handling workout start stop------------------
-(void)startWO
{
    self.isWOStarted=YES;
    [self setupNewWorkout];
    if (self.isWOGoalEnable) {
        self.currentWO.woGoalId=self.woGoal.woGoalId;
    }
    [self.currentWO saveNewWorkout];
    
    if ([CLLocationManager locationServicesEnabled]) {
        [self.locationManager startUpdatingLocation];
        self.locations=[NSMutableArray arrayWithCapacity:1];
        [self saveLocations];
    }
    if (self.stepCounter!=nil) {
        
        
        [self.stepCounter startStepCountingUpdatesToQueue:[NSOperationQueue mainQueue] updateOn:1 withHandler:^(NSInteger numberOfSteps, NSDate *timestamp, NSError *error)
         {
             self.currentWO.steps=[NSNumber numberWithInteger:numberOfSteps];
             UINavigationController *temp= (UINavigationController*)appDel.drawerController.centerViewController;
             [(ISDashboardViewController*)[temp.viewControllers objectAtIndex:0] didUpdateStepsValue:numberOfSteps ];
             
         }];
    }
    [self updateWorkoutInfo];
    [self textToSpeechFromString:@"Workout Started"];
    
}
-(void)stopWO
{
    self.currentWO.endTimeStamp=[NSDate date];
    if ([CLLocationManager locationServicesEnabled]) {
        [self.locationManager stopUpdatingLocation];
    }
    if (self.stepCounter!=nil) {
        [self.stepCounter stopStepCountingUpdates];
    }
    [self.currentWO updateWorkout];
    self.isWOStarted=NO;
//    if (!self.isWOGoalEnable) {
//        [self textToSpeechFromString:@"Workout Stopped"];
//    }
    
}

//--------------------------------handling location services
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    UINavigationController *temp= (UINavigationController*)appDel.drawerController.centerViewController;
    [(ISDashboardViewController*)[temp.viewControllers objectAtIndex:0] resetLocationRelatedLabels];
    
    
    
    if (!(status==kCLAuthorizationStatusAuthorized) && status!=kCLAuthorizationStatusNotDetermined) {
        [ILAlertView showWithTitle:@"Location Service Disabled" message:@"To re-enable, please go to Settings and turn on Location Service for this app" closeButtonTitle:@"OK" secondButtonTitle:nil tappedSecondButton:nil];
    }
}
-(void)saveLocations
{
    [ISLocation saveLocationArray:self.locations];
    self.locations=[NSMutableArray arrayWithCapacity:1];
    if (self.isWOStarted) {
        [self performSelector:@selector(saveLocations) withObject:nil afterDelay:LOCATIONS_SAVE_DELAY];
    }
    
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    
    
    NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
    if (locationAge > 1.0) return;
    if (newLocation.horizontalAccuracy < 0 || newLocation.horizontalAccuracy>10.0) return;
    
    NSLog(@"%f %f",newLocation.coordinate.latitude,newLocation.coordinate.longitude);
    [self.locations addObject:newLocation];
    
    if(oldLocation != nil)
    {
        self.currentWO.distance = [NSNumber numberWithDouble:([newLocation distanceFromLocation:oldLocation] * 0.00062137)+[self.currentWO.distance doubleValue]];
        
    }
    
    if ([self.currentWO.maxSpeed doubleValue] <= newLocation.speed) {
        self.currentWO.maxSpeed=[NSNumber numberWithDouble:newLocation.speed];
    }
    
    if ([self.currentWO.minSpeed doubleValue] > newLocation.speed && newLocation.speed>=0.0) {
        self.currentWO.minSpeed=[NSNumber numberWithDouble:newLocation.speed];
    }
    
    if ([self.dashBoardDelegate respondsToSelector:@selector(didUpdateLocation)]) {
        [self.dashBoardDelegate didUpdateLocation];
    }
    
    //        sinceLastUpdate += [newLocation.timestamp timeIntervalSinceDate:oldLocation.timestamp];
    //        if (sinceLastUpdate!=0) {
    //
    //
    //            speed = distanceChange / sinceLastUpdate;
    //            self.navigationItem.title=[NSString stringWithFormat:@"Speed AVG:%f CURR:%f",speed,[newLocation distanceFromLocation:oldLocation]/[newLocation.timestamp timeIntervalSinceDate:oldLocation.timestamp]];
    //        }
    
}

//------------------------------regularly updating workout in db---------------------
-(void)updateWorkoutInfo
{
    if (!self.isWOStarted) {
        return;
    }
    [self saveCurrentWorkOut];
    [self performSelector:@selector(updateWorkoutInfo) withObject:nil afterDelay:WORKOUT_SAVE_DELAY];
    
}


- (void)saveCurrentWorkOut
{
    if (self.isWOStarted) {
        self.currentWO.endTimeStamp=[NSDate date];
        [self.currentWO updateWorkout];
        [self saveLocations];
    }
    if (self.isWOStarted || self.userDetails.hrMonitoring) {
        [[appDel getHRDistributor]saveData];
    }
}


//------------------------------handling voice assistance------------------------------

-(void)speakDistance:(double)mile
{
    [self textToSpeechFromString:[NSString stringWithFormat:@"%.1f miles covered",mile]];
}
-(void)speakDuration:(int)minute
{
    [self textToSpeechFromString:[NSString stringWithFormat:@"%d minutes elapsed",minute]];
}
-(void)speakCalBurned:(int)calBurned
{
    [self textToSpeechFromString:[NSString stringWithFormat:@"%d calories burned",calBurned]];
}

-(void)speakGoalValue:(int)goalValue
{
    if (goalValue==100)
    {
        [self textToSpeechFromString:[NSString stringWithFormat:@"Workout goal achieved"]];
    }
    else
    {
        [self textToSpeechFromString:[NSString stringWithFormat:@"%d percent goal completed",goalValue]];
    }
}

-(void)textToSpeechFromString:(NSString*)str
{
    [self.musicController speakText:str];
}
























@end
