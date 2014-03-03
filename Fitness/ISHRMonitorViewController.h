//
//  ISHRMonitorViewController.h
//  Fitness
//
//  Created by ispluser on 2/14/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"

typedef enum _ScaleLevel {
    MIN=0,
    HOUR=1,
    DAY=2,
    WEEK=3,
    MONTH=4
}
ScaleLevel;


@interface ISHRMonitorViewController : UIViewController<CPTPlotDataSource, CPTAxisDelegate,CPTPlotSpaceDelegate,
CPTPlotDataSource,CPTScatterPlotDelegate>

{
    CPTXYGraph *graph;
    NSMutableArray *dataForPlot;
    CPTPlotSpaceAnnotation *symbolTextAnnotation;
    NSNumber * xAxisUnitInterval;
    UISegmentedControl *segmentedControl;
    ScaleLevel currentScale;
    
}


@property (readwrite, strong, nonatomic) NSMutableArray *dataForPlot;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UITextField *fromDateTextField;
@property (weak, nonatomic) IBOutlet UITextField *toDateTextField;
@property (strong, nonatomic) IBOutlet UIToolbar *accessoryView;
@property (weak, nonatomic) IBOutlet UIView *graphView;

- (IBAction)doneEditing:(id)sender;



@end
