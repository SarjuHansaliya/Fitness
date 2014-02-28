//
//  ISHRMonitorViewController.m
//  Fitness
//
//  Created by ispluser on 2/14/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import "ISHRMonitorViewController.h"
#import "macros.h"
#import "ISHR.h"
#import "ILAlertView.h"




@interface ISHRMonitorViewController ()

@end

@implementation ISHRMonitorViewController
{
    NSDate *fromDate;
    NSDate *toDate;
}


@synthesize dataForPlot;


float randomFloat(float Min, float Max){
    return ((arc4random()%RAND_MAX)/(RAND_MAX*1.0))*(Max-Min)+Min;
}

-(NSDate *)generateData
{
    dataForPlot=nil;
    NSArray * data=[ISHR getHRArrayWithStartTS:fromDate endTS:toDate];
    if (data ==nil || [data count]<=0) {
        return nil;
    }
    NSDate *startDate=[(ISHR*)data[0] timeStamp];
   // NSLog(@"%@",data);
    if ( !dataForPlot ) {
        NSMutableArray *newData = [NSMutableArray array];
        for (ISHR *hr in data)
         {
            [newData addObject:
             [NSDictionary dictionaryWithObjectsAndKeys:
              [NSDecimalNumber numberWithInt:[hr.timeStamp timeIntervalSinceDate:startDate]], [NSNumber numberWithInt:CPTScatterPlotFieldX],
              [NSDecimalNumber numberWithInt: [hr.hr intValue]], [NSNumber numberWithInt:CPTScatterPlotFieldY],
              nil]];
        }
        dataForPlot = newData;
        return startDate;
    }
    return nil;
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
   NSDate *refDate = [self generateData];
    if (refDate ==nil) {
        
        [ILAlertView showWithTitle:@"" message:@"No Heart rate records found!" closeButtonTitle:@"OK" secondButtonTitle:nil tappedSecondButton:nil];
        return;
    }
    // Create graph from theme
    graph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    CPTTheme *theme = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
    [graph applyTheme:theme];
    CPTGraphHostingView *hostingView =(CPTGraphHostingView*)self.graphView;
    hostingView.collapsesLayers = NO;
    hostingView.hostedGraph     = graph;
    graph.paddingLeft   = 0.0;
    graph.paddingTop    = 0.0;
    graph.paddingRight  = 0.0;
    graph.paddingBottom = 0.0;
    
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
                                                              length:CPTDecimalFromFloat(200.0f)];
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
                                            length:CPTDecimalFromFloat(200.0f)];
    }
    
    if (coordinate==CPTCoordinateX) {
        
        double len=newRange.lengthDouble;
        double totalPoints=30;
        double min=60*totalPoints;
        double hour=min*60;
        double day=hour*24;
        double week=day*7;
        NSNumber *temp=[NSNumber numberWithDouble: xAxisUnitInterval.doubleValue];
        
//        if ( len <= min) {
//            currentScale=MIN;
//            xAxisUnitInterval=@60;
//            
//        }
//        else if (len>min && len<=hour)
//        {
//            currentScale=HOUR;
//            xAxisUnitInterval=@(60*60);
//        }
//        else if (len>hour && len<=day)
//        {
//            currentScale=DAY;
//            xAxisUnitInterval=@(60*60*24);
//        }
//        else if (len>day && len<=week)
//        {
//            currentScale=WEEK;
//            xAxisUnitInterval=@(60*60*24*7);
//        }
//        else if(len>week)
//        {
//            currentScale=MONTH;
//            xAxisUnitInterval=@(60*60*24*30);
//            
//        }
//        
//        if(![temp isEqual:xAxisUnitInterval])
//        {
//           // [self reloadGraph];
//        }
        
        
       // NSLog(@"%@",newRange);
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
    hitAnnotationTextStyle.color    = [CPTColor blackColor];
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




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupNavigationBar];
    [self setupTextFields];
   
   // xAxisUnitInterval=@(60*24*60);
    xAxisUnitInterval=@1.0;
    
    //    NSArray *itemArray = [NSArray arrayWithObjects: @"Min", @"Hour", @"Date",@"Week",@"Month", nil];
    //    segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
    //    segmentedControl.frame = CGRectMake(50, 380, 250, 30);
    //    segmentedControl.segmentedControlStyle = UISegmentedControlStylePlain;
    //    segmentedControl.selectedSegmentIndex = 2;
    //
    //    [segmentedControl addTarget:self action:@selector(unitChanged:) forControlEvents: UIControlEventValueChanged];
    currentScale=MONTH;
   // [self reloadGraph];

    
    
    // Do any additional setup after loading the view from its nib.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//--------------------------------setting up textfields--------------------------------------

-(void)setupTextFields
{
    
    
    UIView *fromView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 23, 21)];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20 , 20)];
    [btn addTarget:self action:@selector(buttonFromDateClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"date.png"] forState:UIControlStateNormal];
    
    [fromView addSubview:btn];
    
    self.fromDateTextField.inputView = self.datePicker;
    self.fromDateTextField.inputAccessoryView=self.accessoryView;
    self.fromDateTextField.rightView = fromView;
    self.fromDateTextField.rightViewMode=UITextFieldViewModeAlways;

    
    
    UIView *toView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 23, 21)];
   
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20 , 20)];
    [btn1 addTarget:self action:@selector(buttonToDateClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn1 setImage:[UIImage imageNamed:@"date.png"] forState:UIControlStateNormal];
    
    [toView addSubview:btn1];
    
    self.toDateTextField.inputView=self.datePicker;
    self.toDateTextField.inputAccessoryView=self.accessoryView;
    self.toDateTextField.rightView = toView;
    self.toDateTextField.rightViewMode=UITextFieldViewModeAlways;

    
}
//--------------------------------setting up navigation bar--------------------------------------

-(void)setupNavigationBar
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
    self.wantsFullScreenLayout=YES;
    
    
    self.navigationController.navigationBar.translucent=NO;
    
    
    UILabel *titleLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 27)];
    
    titleLable.backgroundColor=[UIColor clearColor];
    titleLable.text=@"Heart Rate Monitoring";
    titleLable.font=[UIFont fontWithName:@"HelveticaWorld-Regular" size:20.0];
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
//------------------------------------------------------------------------------------------------

- (IBAction)buttonToDateClicked:(id)sender {

    [self.toDateTextField becomeFirstResponder];
}

- (IBAction)buttonFromDateClicked:(id)sender {
    [self.fromDateTextField becomeFirstResponder];
    
}
- (IBAction)doneEditing:(id)sender {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH:mm dd/MM/yy"];
    
    if([self.toDateTextField isFirstResponder])
    {
        self.toDateTextField.text = [formatter stringFromDate: self.datePicker.date];
        [self.toDateTextField resignFirstResponder];
        toDate=[NSDate dateWithTimeIntervalSince1970:[self.datePicker.date timeIntervalSince1970]];

        
    }
    else if ([self.fromDateTextField isFirstResponder])
    {
        self.fromDateTextField.text = [formatter stringFromDate: self.datePicker.date];
        [self.fromDateTextField resignFirstResponder];
        fromDate=[NSDate dateWithTimeIntervalSince1970:[self.datePicker.date timeIntervalSince1970]];
    }
    
    if (toDate !=nil && fromDate !=nil) {
        [self reloadGraph];
    }
    
}

@end
