//
//  CPTTestAppScatterPlotController.h
//  CPTTestApp-iPhone
//
//  Created by Brad Larson on 5/11/2009.
//

#import "CorePlot-CocoaTouch.h"
#import <UIKit/UIKit.h>

@interface HRPlot : UIViewController<CPTPlotDataSource, CPTAxisDelegate,CPTPlotSpaceDelegate,
CPTPlotDataSource,CPTScatterPlotDelegate>
{
    CPTXYGraph *graph;

    NSMutableArray *dataForPlot;
    CPTPlotSpaceAnnotation *symbolTextAnnotation;

}

@property (readwrite, strong, nonatomic) NSMutableArray *dataForPlot;
@property CPTGraphHostingView *hostingView;

@end
