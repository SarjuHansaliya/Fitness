//
//  ISPathViewController.m
//  Fitness
//
//  Created by ispluser on 2/14/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import "ISPathViewController.h"
#import "macros.h"
#import "ISAppDelegate.h"


@interface ISPathViewController ()

@end

@implementation ISPathViewController
{
    ISAppDelegate *appDel;
    NSArray  *locations;
    BOOL singleLocation;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil workout:(ISWorkOut*)workout
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.workout=workout;
        appDel=(ISAppDelegate*)[[UIApplication sharedApplication]delegate];
        
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupNavigationBar];
    [self.map setDelegate:self];
    [self fetchCordinates];
   
}

//--------------------------------setting up navigation bar--------------------------------------

-(void)setupNavigationBar
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
    self.wantsFullScreenLayout=YES;
    
    
    self.navigationController.navigationBar.translucent=NO;
    
    UILabel *titleLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 27)];
    
    titleLable.backgroundColor=[UIColor clearColor];
    titleLable.text=@"Workout Path";
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

//--------------------------------------calculating path----------------------------------

-(void)fetchCordinates
{
    if (appDel.woHandler.isWOStarted && appDel.woHandler.currentWO.woId==self.workout.woId) {
        
        locations=[ISLocation getLocationArrayWithStartTS:self.workout.startTimeStamp endTS:[NSDate date]];
    }
    else
    {
        locations=[ISLocation getLocationArrayWithStartTS:self.workout.startTimeStamp endTS:self.workout.endTimeStamp];
    }
    [self drawRoute];
}
- (void) drawRoute
{
    NSInteger numberOfSteps = [locations count];
    
    if (numberOfSteps==0 && appDel.woHandler.isWOStarted) {
        [self.map setShowsUserLocation:YES];
        singleLocation=YES;
    }
    else
    {
        
        CLLocationCoordinate2D coordinates[numberOfSteps];
        
        for (NSInteger index = 0; index < numberOfSteps; index++) {
            
            CLLocationCoordinate2D c1=[(ISLocation*)[locations objectAtIndex:index] coordinate];
            if (index==0 || index==(numberOfSteps-1)) {
                MKPointAnnotation *tmpAnnotation=[[MKPointAnnotation alloc]init];
                [tmpAnnotation setCoordinate:c1];
                [self.map addAnnotation:tmpAnnotation];
            }
            
            coordinates[index] =c1;
        }
        MKPolyline *polyLine = [MKPolyline polylineWithCoordinates:coordinates count:numberOfSteps];
        [self.map addOverlay:polyLine];
        [self.map setVisibleMapRect:[polyLine boundingMapRect]];
    }
    
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    if (singleLocation) {
        MKCoordinateRegion rg=MKCoordinateRegionMake(self.map.userLocation.coordinate,
                                                     MKCoordinateSpanMake(0.004,0.004)
                                                     );
        
        //NSLog(@"------------------%f %f",self.map.userLocation.coordinate.latitude,self.map.userLocation.coordinate.longitude);
        [self.map setRegion:rg animated:NO];
        singleLocation=NO;
    }
}

-(MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
     MKPinAnnotationView *tmp=[[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"userLocation"];
    tmp.pinColor=MKPinAnnotationColorRed;
    [tmp setDraggable:NO];
    
    return tmp;
}
-(MKOverlayView*)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay
{
    MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
    polylineView.strokeColor = [UIColor redColor];
    polylineView.lineWidth = 1.0;
    return polylineView;
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolyline *route = overlay;
        MKPolylineRenderer *routeRenderer = [[MKPolylineRenderer alloc] initWithPolyline:route];
        routeRenderer.strokeColor = [UIColor redColor];
        routeRenderer.lineWidth=1.0;
        
        return routeRenderer;
    }
    else return nil;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
