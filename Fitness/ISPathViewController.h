//
//  ISPathViewController.h
//  Fitness
//
//  Created by ispluser on 2/14/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISWorkOut.h"
#import <MapKit/MapKit.h>
#import "XBCurlView.h"

@interface ISPathViewController : UIViewController <MKMapViewDelegate>

@property (weak) ISWorkOut * workout;
@property (nonatomic, strong) XBCurlView *curlView;
@property (weak, nonatomic) IBOutlet MKMapView *map;
@property (weak, nonatomic) IBOutlet UIView *frontView;
@property (weak, nonatomic) IBOutlet UIView *backView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil workout:(ISWorkOut*)workout;

- (IBAction)standardButtonAction:(id)sender;
- (IBAction)satelliteButtonAction:(id)sender;
- (IBAction)hybridButtonAction:(id)sender;

@end
