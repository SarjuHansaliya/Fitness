//
//  CPTTestAppScatterPlotController.m
//  CPTTestApp-iPhone
//
//  Created by Brad Larson on 5/11/2009.
//

#import "HRPlot.h"
#import "ISAppDelegate.h"
typedef enum _ScaleLevel {
    MIN=0,
    HOUR=1,
    DAY=2,
    WEEK=3,
    MONTH=4
}
ScaleLevel;

@implementation HRPlot
{
    NSNumber * xAxisUnitInterval;
    UISegmentedControl *segmentedControl;
    ScaleLevel *currentScale;
    
}

@synthesize dataForPlot;


float randomFloat(float Min, float Max){
    return ((arc4random()%RAND_MAX)/(RAND_MAX*1.0))*(Max-Min)+Min;
}

-(void)generateData
{
    dataForPlot=nil;
        if ( !dataForPlot ) {
        const NSTimeInterval oneDay = xAxisUnitInterval.doubleValue;
        
        // Add some data
        NSMutableArray *newData = [NSMutableArray array];
        NSUInteger i;
        
        for ( i = 0; i < 200; i++ ) {
            NSTimeInterval x = oneDay * (i*0.1);
            id y             = [NSDecimalNumber numberWithFloat:randomFloat(70, 90) ];
            [newData addObject:
             [NSDictionary dictionaryWithObjectsAndKeys:
              [NSDecimalNumber numberWithFloat:x], [NSNumber numberWithInt:CPTScatterPlotFieldX],
              y, [NSNumber numberWithInt:CPTScatterPlotFieldY],
              nil]];
        }
        dataForPlot = newData;
    }
}
-(BOOL)plotSpace:(CPTPlotSpace *)space shouldScaleBy:(CGFloat)interactionScale aboutPoint:(CGPoint)interactionPoint
{
    //NSLog(@"%f %f %f",interactionScale,interactionPoint.x,interactionPoint.y);
    if (interactionScale>=1.5) {
        NSLog(@"hello");
    }
    
    return YES;
}

#pragma mark -
#pragma mark Initialization and teardown

-(void)reloadGraph
{
    [self generateData];
    // Create graph from theme
    graph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    CPTTheme *theme = [CPTTheme themeNamed:kCPTSlateTheme];
    [graph applyTheme:theme];
     ISAppDelegate *appDel=(ISAppDelegate *)[[UIApplication sharedApplication]delegate];
    CGRect rect=[appDel getHRMonitorViewController].graphView.frame;
    rect.origin=CGPointMake(0, 0);
    self.hostingView=[[CPTGraphHostingView alloc]initWithFrame:rect];
    
    CPTGraphHostingView *hostingView =(CPTGraphHostingView*)self.hostingView;
    [self.view addSubview:self.hostingView];
    hostingView.collapsesLayers = NO; // Setting to YES reduces GPU memory usage, but can slow drawing/scrolling
    hostingView.hostedGraph     = graph;
    
    graph.paddingLeft   = 10.0;
    graph.paddingTop    = 0.0;
    graph.paddingRight  = 10.0;
    graph.paddingBottom = 1.0;
    
    
    
    // Setup scatter plot space
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    plotSpace.allowsUserInteraction = YES;
    plotSpace.delegate              = self;
    
    // Grid line styles
    CPTMutableLineStyle *majorGridLineStyle = [CPTMutableLineStyle lineStyle];
    majorGridLineStyle.lineWidth = 0.75;
    majorGridLineStyle.lineColor = [[CPTColor colorWithGenericGray:0.2] colorWithAlphaComponent:0.75];
    
    CPTMutableLineStyle *minorGridLineStyle = [CPTMutableLineStyle lineStyle];
    minorGridLineStyle.lineWidth = 0.25;
    minorGridLineStyle.lineColor = [[CPTColor whiteColor] colorWithAlphaComponent:0.1];
    graph.plotAreaFrame.paddingLeft += 40.0;
    graph.plotAreaFrame.paddingBottom += 55.0;
        NSDate *refDate = [NSDate date];
    
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
    CPTXYAxis *x          = axisSet.xAxis;
    x.majorIntervalLength         = CPTDecimalFromFloat(xAxisUnitInterval.floatValue);
    //  x.orthogonalCoordinateDecimal = CPTDecimalFromString(@"4");
    x.minorTicksPerInterval       = 0;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    if([xAxisUnitInterval isEqual:@60]){
         dateFormatter.dateFormat= @"hh:mm:ss" ;
    }
    else if([xAxisUnitInterval isEqual:@(60*60)]){
         dateFormatter.dateFormat= @"hh:mm" ;
    }
    else if([xAxisUnitInterval isEqual:@(60*60*24)]){
         dateFormatter.dateFormat= @"dd-MM-yy" ;
    }
    else if([xAxisUnitInterval isEqual:@(60*24*60*7)]){
        dateFormatter.dateStyle=kCFDateFormatterShortStandaloneMonthSymbols;
        graph.plotAreaFrame.paddingBottom = 80.0;

    }
    else if([xAxisUnitInterval isEqual:@(60*24*60*30)]){
         dateFormatter.dateFormat= @"MMM-yy" ;
   }
    
    //dateFormatter.dateStyle=kCFDateFormatterDefaultFormat;
    CPTTimeFormatter *timeFormatter = [[CPTTimeFormatter alloc] initWithDateFormatter:dateFormatter];
    timeFormatter.referenceDate = refDate;
    x.minorTicksPerInterval       = 2;
    x.preferredNumberOfMajorTicks = 8;
    x.labelFormatter            = timeFormatter;
    x.labelRotation             = M_PI / 4;
    //    x.title         = @"Date";
    //    x.titleOffset   = 30.0;
    //    x.titleLocation = CPTDecimalFromString(@"1.25");
    x.majorGridLineStyle          = majorGridLineStyle;
    x.minorGridLineStyle          = minorGridLineStyle;
    x.axisConstraints       = [CPTConstraints constraintWithRelativeOffset:0.0];
   // x.delegate=self;
    
    
    // Label y with an automatic label policy.
    CPTXYAxis *y = axisSet.yAxis;
    y.labelingPolicy              = CPTAxisLabelingPolicyAutomatic;
    
    y.minorTicksPerInterval       = 2;
    y.preferredNumberOfMajorTicks = 8;
    y.majorGridLineStyle          = majorGridLineStyle;
    y.minorGridLineStyle          = minorGridLineStyle;
    y.labelOffset                 = 3.0;
    //y.delegate             = self;
    //    y.title         = @"HR";
    //    y.titleOffset   = 20.0;
    //    y.titleLocation = CPTDecimalFromString(@"1.0");
    y.axisConstraints             = [CPTConstraints constraintWithLowerOffset:0.0];
    graph.axisSet.axes = [NSArray arrayWithObjects:x, y, nil];
    // Create a plot that uses the data source method
    CPTScatterPlot *dataSourceLinePlot = [[CPTScatterPlot alloc] init];
    dataSourceLinePlot.identifier = @"Data Source Plot";
    
    CPTMutableLineStyle *lineStyle = [dataSourceLinePlot.dataLineStyle mutableCopy];
    lineStyle.lineWidth              = 5.0;
    lineStyle.lineJoin               = kCGLineJoinRound;
    lineStyle.lineGradient           = [CPTGradient gradientWithBeginningColor:[CPTColor grayColor] endingColor:[CPTColor whiteColor]];
    dataSourceLinePlot.dataLineStyle = lineStyle;
    dataSourceLinePlot.dataSource    = self;
    [graph addPlot:dataSourceLinePlot];
    
    // Put an area gradient under the plot above
    CPTColor *areaColor       = [CPTColor colorWithComponentRed:0.3 green:0.5 blue:0.3 alpha:0.9];
    CPTGradient *areaGradient = [CPTGradient gradientWithBeginningColor:areaColor endingColor:[CPTColor clearColor]];
    areaGradient.angle = -90.0;
    CPTFill *areaGradientFill = [CPTFill fillWithGradient:areaGradient];
    dataSourceLinePlot.areaFill      = areaGradientFill;
    dataSourceLinePlot.areaBaseValue = CPTDecimalFromString(@"0.0");
    
    // Auto scale the plot space to fit the plot data
    // Extend the ranges by 30% for neatness
    [plotSpace scaleToFitPlots:[NSArray arrayWithObjects:dataSourceLinePlot, nil]];
    CPTMutablePlotRange *xRange = [plotSpace.xRange mutableCopy];
    CPTMutablePlotRange *yRange = [plotSpace.yRange mutableCopy];
    [xRange expandRangeByFactor:CPTDecimalFromDouble(0.5)];
    [yRange expandRangeByFactor:CPTDecimalFromDouble(5)];
    
    
    [xRange shiftLocationToFitInRange:[[CPTPlotRange alloc]initWithLocation:[[NSNumber numberWithInt:(-[xAxisUnitInterval intValue])]decimalValue] length:[[NSNumber numberWithInt:10]decimalValue]]];
    plotSpace.xRange = xRange;
   plotSpace.yRange = yRange;
    CPTPlotRange *globalYRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f)
                                                              length:CPTDecimalFromFloat(150.0f)];
    plotSpace.globalYRange = globalYRange;
    
   // y.orthogonalCoordinateDecimal = CPTDecimalFromFloat(0);
    
    // Restrict y range to a global range
    // CPTPlotRange *globalYRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f)
    //                      length:CPTDecimalFromFloat(5.0f)];
    //  plotSpace.globalYRange = globalYRange;
    
    // Add plot symbols
    CPTGradient *symbolGradient = [CPTGradient gradientWithBeginningColor:[CPTColor colorWithComponentRed:0.75 green:0.75 blue:1.0 alpha:1.0]
                                                              endingColor:[CPTColor blueColor]];
    symbolGradient.gradientType = CPTGradientTypeRadial;
    symbolGradient.startAnchor  = CPTPointMake(0.25, 0.75);
    
    CPTPlotSymbol *plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    plotSymbol.fill               = [CPTFill fillWithGradient:symbolGradient];
    plotSymbol.lineStyle          = nil;
    plotSymbol.size               = CGSizeMake(3.0, 3.0);
    dataSourceLinePlot.plotSymbol = plotSymbol;
    
    // Set plot delegate, to know when symbols have been touched
    // We will display an annotation when a symbol is touched
    dataSourceLinePlot.delegate                        = self;
    dataSourceLinePlot.plotSymbolMarginForHitDetection = 5.0f;
     [self.view addSubview:segmentedControl];
}



-(void)unitChanged:(UISegmentedControl*)sender
{
    
    switch (sender.selectedSegmentIndex) {
        case 0:
            xAxisUnitInterval=@(60);
            break;
        case 1:
            xAxisUnitInterval=@(60*60);
            break;
        case 2:
            xAxisUnitInterval=@(60*24*60);
            break;
        case 3:
            xAxisUnitInterval=@(60*60*24*7);
            break;
        case 4:
            xAxisUnitInterval=@(60*60*24*30);
            break;
            
        default:
            break;
    }
    [self reloadGraph];
    
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    xAxisUnitInterval=@(60*24*60);
//    NSArray *itemArray = [NSArray arrayWithObjects: @"Min", @"Hour", @"Date",@"Week",@"Month", nil];
//    segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
//    segmentedControl.frame = CGRectMake(50, 380, 250, 30);
//    segmentedControl.segmentedControlStyle = UISegmentedControlStylePlain;
//    segmentedControl.selectedSegmentIndex = 2;
//
//    [segmentedControl addTarget:self action:@selector(unitChanged:) forControlEvents: UIControlEventValueChanged];
    
    currentScale=DAY;
    [self reloadGraph];
    
    
    

}


#pragma mark -
#pragma mark Plot Data Source Methods


#pragma mark -
#pragma mark Axis Delegate Methods

-(BOOL)axis:(CPTAxis *)axis shouldUpdateAxisLabelsAtLocations:(NSSet *)locations
{
    static CPTTextStyle *positiveStyle = nil;
    static CPTTextStyle *negativeStyle = nil;

    NSFormatter *formatter = axis.labelFormatter;
    CGFloat labelOffset    = axis.labelOffset;
    NSDecimalNumber *zero  = [NSDecimalNumber zero];

    NSMutableSet *newLabels = [NSMutableSet set];

    for ( NSDecimalNumber *tickLocation in locations ) {
        CPTTextStyle *theLabelTextStyle;

        if ( [tickLocation isGreaterThanOrEqualTo:zero] ) {
            if ( !positiveStyle ) {
                CPTMutableTextStyle *newStyle = [axis.labelTextStyle mutableCopy];
                newStyle.color = [CPTColor greenColor];
                positiveStyle  = newStyle;
            }
            theLabelTextStyle = positiveStyle;
        }
        else {
            if ( !negativeStyle ) {
                CPTMutableTextStyle *newStyle = [axis.labelTextStyle mutableCopy];
                newStyle.color = [CPTColor redColor];
                negativeStyle  = newStyle;
            }
            theLabelTextStyle = negativeStyle;
        }

        NSString *labelString       = [formatter stringForObjectValue:tickLocation];
        CPTTextLayer *newLabelLayer = [[CPTTextLayer alloc] initWithText:labelString style:theLabelTextStyle];

        CPTAxisLabel *newLabel = [[CPTAxisLabel alloc] initWithContentLayer:newLabelLayer];
        newLabel.tickLocation = tickLocation.decimalValue;
        newLabel.offset       = labelOffset;

        [newLabels addObject:newLabel];
    }

    axis.axisLabels = newLabels;

    return NO;
}
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    
    return [dataForPlot count];
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
        NSDecimalNumber *num = [[dataForPlot objectAtIndex:index] objectForKey:[NSNumber numberWithInt:fieldEnum]];
    
    return num;
}

#pragma mark -
#pragma mark Plot Space Delegate Methods

-(CPTPlotRange *)plotSpace:(CPTPlotSpace *)space willChangePlotRangeTo:(CPTPlotRange *)newRange forCoordinate:(CPTCoordinate)coordinate
{
    if (coordinate==CPTCoordinateY) {
        return [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f)
                                                                  length:CPTDecimalFromFloat(150.0f)];
    }
    
    if (coordinate==CPTCoordinateX) {
        
    double len=newRange.lengthDouble;
    double totalPoints=30;
    double min=60*totalPoints;
    double hour=min*60;
    double day=hour*24;
    double week=day*7;
    NSNumber *temp=[NSNumber numberWithDouble: xAxisUnitInterval.doubleValue];
        
    if ( len <= min) {
        currentScale=MIN;
        xAxisUnitInterval=@60;
        
    }
    else if (len>min && len<=hour)
    {
        currentScale=HOUR;
        xAxisUnitInterval=@(60*60);
    }
    else if (len>hour && len<=day)
    {
        currentScale=DAY;
        xAxisUnitInterval=@(60*60*24);
    }
    else if (len>day && len<=week)
    {
        currentScale=WEEK;
        xAxisUnitInterval=@(60*60*24*7);
    }
    else if(len>week)
    {
        currentScale=MONTH;
        xAxisUnitInterval=@(60*60*24*30);
        
    }
    
    if(![temp isEqual:xAxisUnitInterval])
    {
        [self reloadGraph];
    }
        
    
    NSLog(@"%@",newRange);
    }
        return newRange;
}

#pragma mark -
#pragma mark CPTScatterPlot delegate method

-(void)scatterPlot:(CPTScatterPlot *)plot plotSymbolWasSelectedAtRecordIndex:(NSUInteger)index
{
    
    if ( symbolTextAnnotation ) {
        [graph.plotAreaFrame.plotArea removeAnnotation:symbolTextAnnotation];
        symbolTextAnnotation = nil;
    }
    
    // Setup a style for the annotation
    CPTMutableTextStyle *hitAnnotationTextStyle = [CPTMutableTextStyle textStyle];
    hitAnnotationTextStyle.color    = [CPTColor whiteColor];
    hitAnnotationTextStyle.fontSize = 16.0f;
    hitAnnotationTextStyle.fontName = @"Helvetica-Bold";
    
    // Determine point of symbol in plot coordinates
    NSNumber *x          = [[dataForPlot objectAtIndex:index] objectForKey:[NSNumber numberWithInt:CPTScatterPlotFieldX]];
    NSNumber *y          = [[dataForPlot objectAtIndex:index] objectForKey: [NSNumber numberWithInt:CPTScatterPlotFieldY]];
    NSArray *anchorPoint = [NSArray arrayWithObjects:x, y, nil];
    
    // Add annotation
    // First make a string for the y value
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setMaximumFractionDigits:2];
    NSString *yString = [formatter stringFromNumber:y];
    
    // Now add the annotation to the plot area
    CPTTextLayer *textLayer = [[CPTTextLayer alloc] initWithText:yString style:hitAnnotationTextStyle];
    symbolTextAnnotation              = [[CPTPlotSpaceAnnotation alloc] initWithPlotSpace:graph.defaultPlotSpace anchorPlotPoint:anchorPoint];
    symbolTextAnnotation.contentLayer = textLayer;
    symbolTextAnnotation.displacement = CGPointMake(0.0f, 20.0f);
    [graph.plotAreaFrame.plotArea addAnnotation:symbolTextAnnotation];
}

@end
