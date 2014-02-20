//
//  ISBluetooth.h
//  Central
//
//  Created by ispluser on 1/28/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

//---------------------------------------------------------------------------------------------------------------

@protocol ISBluetoothDelegate <NSObject>

@optional
-(void)centralManagerDidStartedWithSuccess:(BOOL)b  errorMessage:(NSString*)str;
-(void)didConnectPeripheral;
-(void)didDiscoverPeripheral:(CBPeripheral *)peripheral;
-(void)didDiscoverCharacteristicsForService:(CBService *)service;
-(void)subscriptionStateChanged;
-(void)didStopScanning;
-(void)didRecieveValueForDescriptorForCharacteristics:(CBCharacteristic*)chara;

-(void)didUpdateHeartRate:(UInt16)hr formate16bit:(BOOL)is16bit;
-(void)didRecieveValueForDeviceLocation:(NSString*)location;
-(void)didResetControlPoint;

@end

//---------------------------------------------------------------------------------------------------------------


@interface ISBluetooth : NSObject <CBCentralManagerDelegate,CBPeripheralDelegate>

@property(weak, nonatomic) id<ISBluetoothDelegate> delegate;
@property CBCentralManager *centralManager;
@property CBPeripheral *connectedPeripheral;
@property NSMutableArray *peripherals;
@property BOOL isScanning;
@property NSMutableArray *connectedDeviceServices;

@property NSMutableDictionary *connectedDeviceCharacteristicsForService;

@property (weak) CBCharacteristic *heartRateMeasureChar;
@property (weak) CBCharacteristic *bodySensorLocationChar;
@property (weak) CBCharacteristic *controlPointChar;
@property  NSString *heartRateMeasureCharDescriptor;
@property  NSString *bodySensorLocationCharDescriptor;
@property  NSString *controlPointCharDescriptor;

-(void) scanForDevicesWithHeartRateService;
-(void) connectPeripheral:(CBPeripheral *)peripheral options:(NSDictionary *)options;
-(void)stopScanning;
-(void)disconnectPeripheral;

-(BOOL)readBodyLocationCharacteristics;
-(BOOL)subscribeToHeartRateUpdates:(BOOL)b;
-(BOOL)resetHartRateControlPoint;
@end
