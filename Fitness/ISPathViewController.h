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

@interface ISPathViewController : UIViewController <MKMapViewDelegate>

@property (weak) ISWorkOut * workout;
@property (weak, nonatomic) IBOutlet MKMapView *map;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil workout:(ISWorkOut*)workout;
@end
