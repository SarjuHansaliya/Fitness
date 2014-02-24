//
//  ISBLEConnectionManagerViewController.m
//  Fitness
//
//  Created by ispluser on 2/14/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import "ISBLEConnectionManagerViewController.h"
#import "ISBLEDeviceCell.h"
#import "ISConnectionManagerViewController.h"
#import "ISAppDelegate.h"
#import "macros.h"
#import "ILAlertView.h"

@interface ISBLEConnectionManagerViewController ()

@end

@implementation ISBLEConnectionManagerViewController
{
    // dummy data, just for checking screen--------------------------
    NSMutableArray *deviceNameArray;
    NSIndexPath *selectedDeviceIndexPath;
    //remove before original implementation---------------------------
    
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fillDummyReminderData]; //remove this
    self.tableView.separatorColor=[UIColor clearColor];
    self.tableView.backgroundColor=[UIColor clearColor];
    //bluetooth Manager initialization
    self.bluetoothManager=[(ISAppDelegate*)[[UIApplication sharedApplication] delegate] getBluetoothManager];
    [self.bluetoothManager setDelegate:self];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//--------------------------------handling table view controller-------------------


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [self.bluetoothManager.peripherals count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DeviceCell";
    ISBLEDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ISBLEDeviceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    CBPeripheral *p=(CBPeripheral*)[self.bluetoothManager.peripherals objectAtIndex:indexPath.row];
    [cell setDeviceLabelText:p.name];

    NSUUID *u1,*u2;
    BOOL isSame=NO;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        
        u1=self.bluetoothManager.connectedPeripheral.identifier;
        u2=p.identifier;
        
        if ([u1 isEqual:u2]) {
            isSame=YES;
        }
    }
    else
    {
        isSame=[p isConnected];
    }
    if(isSame)
    {
        
        [cell setSelectedDeviceImageHidden:NO];
        
    }
    else
    {
        [cell setSelectedDeviceImageHidden:YES];
    }

    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO ];
    
    CBPeripheral *p=(CBPeripheral*)[self.bluetoothManager.peripherals objectAtIndex:indexPath.row];
    NSUUID *u1,*u2;
    BOOL isSame=NO;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        
        u1=self.bluetoothManager.connectedPeripheral.identifier;
        u2=p.identifier;
        
        if ([u1 isEqual:u2]) {
            isSame=YES;
        }
    }
    else
    {
        isSame=[p isConnected];
    }
    if(isSame)
    {
        
        [ILAlertView showWithTitle:[NSString stringWithFormat:@"Disconnect\n%@",p.name]
                           message:@"Are you sure you want to disconnect this device?"
                  closeButtonTitle:@"No"
                 secondButtonTitle:@"Yes"
                tappedSecondButton:^{
                    [self.bluetoothManager disconnectPeripheral];
                }];
        
    }
    else
    {
        
        [self.bluetoothManager connectPeripheral:[self.bluetoothManager.peripherals objectAtIndex:indexPath.row] options:nil];
    }

    
    
    
    
}
//--------------------------------handling Bluetooth events---------------------------------

-(void)centralManagerDidStartedWithSuccess:(BOOL)b  errorMessage:(NSString*)str
{
    if (!b) {
        UIAlertView *error=[[UIAlertView alloc]initWithTitle:@"Error" message:str delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [error show];
    }
}
-(void)peripheralDidDisconnect:(NSError *)error
{
    [self.tableView reloadData];
}
-(void)didDiscoverPeripheral:(CBPeripheral *)peripheral
{
    [self.tableView reloadData];
    
}

-(void)didConnectPeripheral
{
    [self.tableView reloadData];
}

-(void)didStopScanning
{
    
    if(self.bluetoothManager.isScanning==YES)
    {
        [(ISConnectionManagerViewController*)self.parentController  scanButton].hidden=YES;
        [(ISConnectionManagerViewController*)self.parentController  scanningActivityIndicator].alpha=1.0;
        [[(ISConnectionManagerViewController*)self.parentController  scanningActivityIndicator] startAnimating];
    }
    else
    {
        [(ISConnectionManagerViewController*)self.parentController  scanButton].hidden=NO;
        [(ISConnectionManagerViewController*)self.parentController  scanningActivityIndicator].alpha=0.0;
        [[(ISConnectionManagerViewController*)self.parentController  scanningActivityIndicator] stopAnimating];
    }
}



//-------------------------filling dummy Data-------------------------
-(void)fillDummyReminderData
{
    deviceNameArray=[[NSMutableArray alloc]initWithCapacity:1];
    [deviceNameArray addObject:@"Wahoo HR"];
    [deviceNameArray addObject:@"Polar HR"];
    [deviceNameArray addObject:@"Custom Device"];
    
    
    
    
}
@end
