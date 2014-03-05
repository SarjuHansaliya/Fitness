//
//  ISBluetooth.m
//  Central
//
//  Created by ispluser on 1/28/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import "ISBluetooth.h"
#import "macros.h"


#define HEART_RATE_SERVICE_UUID @"180D"
#define HEART_RATE_MEASUREMENT_CHAR_UUID @"2A37"
#define HEART_RATE_BODY_SENSOR_LOCATION_CHAR_UUID @"2A38"
#define HEART_RATE_CONTROL_POINT_CHAR_UUID @"2A39"

#define RECONNECTION_TIMEOUT 5.0

@implementation ISBluetooth
{
    BOOL isConnected;
}


- (id)init
{
    self = [super init];
    if (self) {
        
        _peripherals=[NSMutableArray arrayWithCapacity:1];
        _isScanning=NO;
        isConnected=NO;
        _connectedDeviceServices=[NSMutableArray arrayWithCapacity:1];
        _connectedDeviceCharacteristicsForService=[NSMutableDictionary dictionaryWithCapacity:1];
        
        [self initializeCentralManager];
        
    }
    return self;
}


-(void )initializeCentralManager
{
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        
        self.centralManager=[[CBCentralManager alloc] initWithDelegate:self queue:nil options:@{ CBCentralManagerOptionRestoreIdentifierKey:@"myCentralManagerIdentifier" }];
    }
    
    else   {
        
        self.centralManager=[[CBCentralManager alloc] initWithDelegate:self queue:nil ];
    }
    [self.centralManager setDelegate:self];
    
}
//---------------------------------------------------------------------------------------------------------------
-(void)addNewKnownPeripheral:(NSUUID*)newDeviceUUID
{
    //    if (SYSTEM_VERSION_EQUAL_TO(@"7.0"))
    //    {
    //        NSMutableArray *deviceUUIDS=[[NSUserDefaults standardUserDefaults] objectForKey:@"knownDevices"];
    //        if(deviceUUIDS!=nil)
    //        {
    //        NSMutableArray *p=[NSMutableArray arrayWithArray: [self.centralManager retrievePeripheralsWithIdentifiers:deviceUUIDS]];
    //        if(![p containsObject:newDeviceUUID])
    //        {
    //            [p addObject:newDeviceUUID];
    //            [[NSUserDefaults standardUserDefaults]setObject:p forKey:@"knownDevices"];
    //        }
    //        }
    //    }
}

-(void)retriveKnownPeripherals
{
    //    if (SYSTEM_VERSION_EQUAL_TO(@"7.0"))
    //    {
    //        NSMutableArray *deviceUUIDS=[[NSUserDefaults standardUserDefaults] objectForKey:@"knownDevices"];
    //        if (deviceUUIDS==nil) {
    //            return;
    //        }
    //        self.peripherals=[NSMutableArray arrayWithArray: [self.centralManager retrievePeripheralsWithIdentifiers:deviceUUIDS]];
    //        if ([self.delegate respondsToSelector:@selector(didDiscoverPeripheral:)]) {
    //            [self.delegate didDiscoverPeripheral:nil];
    //        }
    //    }
    
}
//---------------------------------------------------------------------------------------------------------------
- (void)centralManager:(CBCentralManager *)central
      willRestoreState:(NSDictionary *)state {
    
    NSArray *peripherals =
    state[CBCentralManagerRestoredStatePeripheralsKey];
    
    if (peripherals!=nil || [peripherals count]>0) {
        
        [self connectPeripheral:[peripherals objectAtIndex:0] options:nil];
    }
    
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if (central.state==CBCentralManagerStatePoweredOn) {
        
        //   NSString *savedValue = [[NSUserDefaults standardUserDefaults]stringForKey:@""];
        
        [self retriveKnownPeripherals];
        if ([self.delegate respondsToSelector:@selector(centralManagerDidStartedWithSuccess:errorMessage:)]) {
            [self.delegate centralManagerDidStartedWithSuccess:YES errorMessage:@"Successfully Powered on"];
        }
        
    }
    else
    {
        NSString *message;
        
        switch (central.state) {
            case CBCentralManagerStatePoweredOff:
                message=@"Bluetooth Powered Off";
                break;
                
            case CBCentralManagerStateResetting:
                message=@"Bluetooth Resetting";
                break;
            case CBCentralManagerStateUnauthorized:
                message=@"Unauthorized Access";
                break;
            case CBCentralManagerStateUnsupported:
                message=@"Bluetooth Unsupported";
                break;
                
            default:
                message=@"Unrecognized";
        }
        
        
        if ([self.delegate respondsToSelector:@selector(centralManagerDidStartedWithSuccess:errorMessage:)]) {
            [self.delegate centralManagerDidStartedWithSuccess:NO errorMessage:message];
        }
    }
}
//---------------------------------------------------------------------------------------------------------------

-(void)scanForDevicesWithHeartRateService
{
    CBUUID *heartRateUUID=[CBUUID UUIDWithString:HEART_RATE_SERVICE_UUID];
    [self.centralManager scanForPeripheralsWithServices:@[heartRateUUID] options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
   // [self.centralManager scanForPeripheralsWithServices:nil options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
    self.isScanning=YES;
    NSTimeInterval delay=120;
    [self performSelector:@selector(stopScanning) withObject:nil afterDelay:delay];
}
-(void)scanForDevicesWithServices:(NSArray *)serviceUUIDs options:(NSDictionary *)options
{
    self.peripherals=[NSMutableArray arrayWithCapacity:1];
    if (serviceUUIDs !=nil) {
        NSMutableArray *UUIDs=[NSMutableArray arrayWithCapacity:1];
        for (NSString *uuidString in serviceUUIDs) {
            [UUIDs addObject:[CBUUID UUIDWithString:uuidString]];
        }
        [self.centralManager scanForPeripheralsWithServices:UUIDs options:options];
    }
    else
    {
        
        [self.centralManager scanForPeripheralsWithServices:nil options:options];
    }
    
    self.isScanning=YES;
    NSTimeInterval delay=120;
    
    [self performSelector:@selector(stopScanning) withObject:nil afterDelay:delay];
    
}
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary *)advertisementData
                  RSSI:(NSNumber *)RSSI {
    
    if (![self checkSignalStrengthWithRSSI:RSSI]) {
        //return;
    }
    
    NSLog(@"Discovered %@ at %@", peripheral.name, RSSI);
    if ([peripheral.name length]==0 ||peripheral.name==nil) {
        return;
    }
    
    // Ok, it's in range - have we already seen it?
    if ([self.peripherals containsObject:peripheral]) {
        return;
    }
    
    else
    {
        
        [self.peripherals addObject:peripheral];
        
        if ([self.delegate respondsToSelector:@selector(didDiscoverPeripheral:)]) {
            [self.delegate didDiscoverPeripheral:peripheral];
        }
    }
    
}
-(void)stopScanning
{
    [self.centralManager stopScan];
    self.isScanning=NO;
    if ([self.delegate respondsToSelector:@selector(didStopScanning)]) {
        [self.delegate didStopScanning];
    }
    
    if ([self.peripherals count]<=0 && self.connectedPeripheral==nil) {
        if ([self.delegate respondsToSelector:@selector(noPeripheralsFound)]) {
            [self.delegate noPeripheralsFound];
        }
    }
}


-(BOOL)checkSignalStrengthWithRSSI:(NSNumber *)RSSI
{
    // Reject any where the value is above reasonable range
    if (RSSI.integerValue > -15) {
        return NO;
    }
    
    // Reject if the signal strength is too low to be close enough (Close is around -22dB)
    if (RSSI.integerValue < -35) {
        return NO;
    }
    
    return YES;
}



//---------------------------------------------------------------------------------------------------------------



-(void) connectPeripheral:(CBPeripheral *)peripheral options:(NSDictionary *)options
{
    [self disconnectPeripheral];
    [self.centralManager connectPeripheral:peripheral options:options];
}
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    
    self.connectedPeripheral=peripheral;
    [self.connectedPeripheral setDelegate:self];
    
    isConnected=YES;
    
    
    if (SYSTEM_VERSION_EQUAL_TO(@"7.0"))
    {
        [self addNewKnownPeripheral:peripheral.identifier];
    }
    [self stopScanning];
    [self discoverServicesAndCharacteristics:nil];
    if ([self.delegate respondsToSelector:@selector(didConnectPeripheral)]) {
        [self.delegate didConnectPeripheral];
    }
    if ([self.connectionDelegate respondsToSelector:@selector(peripheralDidConnect)]) {
        [self.connectionDelegate peripheralDidConnect];
    }
}

-(void)disconnectPeripheral
{
    if(isConnected==YES)
    {
        [self.centralManager cancelPeripheralConnection:self.connectedPeripheral];
        self.connectedPeripheral=nil;
        self.connectedDeviceServices=[NSMutableArray arrayWithCapacity:1];
        self.connectedDeviceCharacteristicsForService=[NSMutableDictionary dictionaryWithCapacity:1];
        
    }
}

-(void)connectToDeviceAgain
{
    [self.centralManager connectPeripheral:self.connectedPeripheral options:nil];
}

-(void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    isConnected=NO;
    if ([self.notificationDelegate respondsToSelector:@selector(peripheralDidDisconnect:)]) {
        [self.notificationDelegate peripheralDidDisconnect:error];
    }
    if ([self.delegate respondsToSelector:@selector(peripheralDidDisconnect:)]) {
        [self.delegate peripheralDidDisconnect:error];
    }
    if (error!=nil) {
        
        [self connectToDeviceAgain];
        [self performSelector:@selector(deviceReconnectionTimedOut:) withObject:error afterDelay:RECONNECTION_TIMEOUT];
    }
}
-(void)deviceReconnectionTimedOut:(NSError *)error
{
    if (isConnected) {
        return;
    }
    
    if ([self.connectionDelegate respondsToSelector:@selector(peripheralDidDisconnect:)]) {
        [self.connectionDelegate peripheralDidDisconnect:error];
    }
    
}

//---------------------------------------------------------------------------------------------------------------


-(void)discoverServicesAndCharacteristics:(NSArray*)services
{
    if(![self checkPeripheralConnection])
    {
        return;
    }
    self.connectedDeviceServices=[NSMutableArray arrayWithCapacity:1];
    self.connectedDeviceCharacteristicsForService=[NSMutableDictionary dictionaryWithCapacity:1];
    [self.connectedPeripheral discoverServices:services];
}
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    
    for (CBService *service in peripheral.services) {
        
        if ([service.UUID isEqual:[CBUUID UUIDWithString:HEART_RATE_SERVICE_UUID]]) {
            
            
            [self.connectedDeviceServices addObject:service];
            [peripheral discoverCharacteristics:nil forService:service];
        }
    }
}
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service
            error:(NSError *)error {
    
    [self.connectedDeviceCharacteristicsForService setObject:service.characteristics forKey:[NSString stringWithFormat:@"%@", service.UUID]];
    
    for (CBCharacteristic *chara in service.characteristics){
        
        if (([chara.UUID isEqual:[CBUUID UUIDWithString:HEART_RATE_MEASUREMENT_CHAR_UUID]])) {
            self.heartRateMeasureChar=chara;
            [self subscribeToHeartRateUpdates:YES];
            
        }
        else if(([chara.UUID isEqual:[CBUUID UUIDWithString:HEART_RATE_BODY_SENSOR_LOCATION_CHAR_UUID]]) )
        {
            self.bodySensorLocationChar=chara;
        }
        else if(([chara.UUID isEqual:[CBUUID UUIDWithString:HEART_RATE_CONTROL_POINT_CHAR_UUID]]) )
        {
            self.controlPointChar=chara;
            
        }
        [peripheral discoverDescriptorsForCharacteristic:chara];
    }
    
    
    if ([self.delegate respondsToSelector:@selector(didDiscoverCharacteristicsForService:)]) {
        [self.delegate didDiscoverCharacteristicsForService:service];
    }
    
}
//---------------------------------------------------------------------------------------------------------------
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"Error in finding descriptors");
    }
    
    for (CBDescriptor *d in characteristic.descriptors) {
        if ([d.UUID isEqual:[CBUUID UUIDWithString:CBUUIDCharacteristicUserDescriptionString]]) {
            
            [peripheral readValueForDescriptor:d];
        }
    }
    
    
}
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error
{
    
    if (([descriptor.characteristic.UUID isEqual:[CBUUID UUIDWithString:HEART_RATE_MEASUREMENT_CHAR_UUID]])) {
        self.heartRateMeasureCharDescriptor=[NSString stringWithFormat:@"%@", descriptor.value];
        
        
    }
    else if(([descriptor.characteristic.UUID isEqual:[CBUUID UUIDWithString:HEART_RATE_BODY_SENSOR_LOCATION_CHAR_UUID]]) )
    {
        self.bodySensorLocationCharDescriptor=[NSString stringWithFormat:@"%@", descriptor.value];
    }
    else if(([descriptor.characteristic.UUID isEqual:[CBUUID UUIDWithString:HEART_RATE_CONTROL_POINT_CHAR_UUID]]) )
    {
        self.controlPointCharDescriptor=[NSString stringWithFormat:@"%@", descriptor.value];
        
    }
    
    if ([self.delegate respondsToSelector:@selector(didRecieveValueForDescriptorForCharacteristics:)]) {
        
        [self.delegate didRecieveValueForDescriptorForCharacteristics:descriptor.characteristic];
        
    }
}
//---------------------------------------------------------------------------------------------------------------

-(CBCharacteristic*)isCharacteristicsAvailableWithUUID:(CBUUID*)characteristicUUID
{
    BOOL charAvailable=NO;
    CBCharacteristic *chara=nil;
    for (NSString * key  in self.connectedDeviceCharacteristicsForService) {
        
        for (CBCharacteristic *ch in [self.connectedDeviceCharacteristicsForService objectForKey:key]) {
            
            if([ch.UUID isEqual:characteristicUUID])
            {
                charAvailable=YES;
                chara=ch;
            }
            
        }
        
    }
    return chara;
    
}

-(BOOL)checkPeripheralConnection
{
    if(isConnected==NO){
        return NO;
    }
    
    // return [self checkSignalStrengthWithRSSI:self.connectedPeripheral.RSSI];
    return YES;
}


-(BOOL)isCharacteristicsAvailable:(CBCharacteristic*)characteristic
{
    
    for (NSString * key  in self.connectedDeviceCharacteristicsForService) {
        
        for (CBCharacteristic *ch in [self.connectedDeviceCharacteristicsForService objectForKey:key]) {
            
            if([ch.UUID isEqual:characteristic.UUID])
            {
                return YES;
            }
        }
        
    }
    return NO;
    
}

//---------------------------------------------------------------------------------------------------------------

-(BOOL)readBodyLocationCharacteristics
{
    if(![self checkPeripheralConnection]){
        return NO;
    }
    if (self.bodySensorLocationChar!=nil) {
        
        [self.connectedPeripheral readValueForCharacteristic:self.bodySensorLocationChar];
        return YES;
    }
    return NO;
}


- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
    NSData *data=characteristic.value;
    NSLog(@"%@",characteristic.value);
    Byte buffer[3];
    
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:HEART_RATE_MEASUREMENT_CHAR_UUID]])
    {
        //heart rate measurement
        
        BOOL is16bit=NO;
        
        NSRange range;
        [data getBytes:buffer length:2];
        if (buffer[0]%2==1)
        {
            [data getBytes:buffer length:3];
            is16bit=YES;
            range=NSMakeRange(1, 2);
            
            //UInt16 hr=[data subdataWithRange:range];
            UInt16 hr=0;
            [[data subdataWithRange:range] getBytes:&hr];
            if ([self.delegate respondsToSelector:@selector(didUpdateHeartRate:formate16bit:)]) {
                [self.delegate didUpdateHeartRate:hr formate16bit:is16bit];
            }
            
        }
        else if(buffer[0]%2==0)
        {
            is16bit=NO;
            [data getBytes:buffer length:2];
            range=NSMakeRange(1, 1);
            UInt16 hr=0;
            
            [[data subdataWithRange:range] getBytes:&hr];
            NSLog(@"%x %s",hr,buffer);
            if ([self.delegate respondsToSelector:@selector(didUpdateHeartRate:formate16bit:)]) {
                [self.delegate didUpdateHeartRate:hr formate16bit:is16bit];
            }
            if ([self.notificationDelegate respondsToSelector:@selector(didUpdateHeartRate:formate16bit:)]) {
                [self.notificationDelegate didUpdateHeartRate:hr formate16bit:is16bit];
            }
        }
        
        
    }
    else if([characteristic.UUID isEqual:[CBUUID UUIDWithString:HEART_RATE_BODY_SENSOR_LOCATION_CHAR_UUID]])
    {
        //body Sensor Location
        NSString *location;
        [data getBytes:buffer length:1];
        switch (buffer[0]) {
            case 0x00:
                location=@"Other";
                break;
            case 0x01:
                location=@"Chest";
                break;
            case 0x02:
                location=@"Wrist";
                break;
            case 0x03:
                location=@"Finger";
                break;
            case 0x04:
                location=@"Hand";
                break;
            case 0x05:
                location=@"Ear Lobe";
                break;
            case 0x06:
                location=@"Foot";
                break;
                
            default:
                location=@"Unknown";
                break;
        }
        if ([self.delegate respondsToSelector:@selector(didRecieveValueForDeviceLocation:)]) {
            [self.delegate didRecieveValueForDeviceLocation:location];
        }
        
        
    }
    
    
}
//---------------------------------------------------------------------------------------------------------------

-(BOOL)subscribeToHeartRateUpdates:(BOOL)b
{
    if (self.heartRateMeasureChar!=nil) {
        return  [self subscribe:b Characteristic:self.heartRateMeasureChar];
    }
    return NO;
}



-(BOOL)subscribe:(BOOL)b Characteristic:(CBCharacteristic*)characteristic
{
    if(![self checkPeripheralConnection]){
        return NO;
    }
    BOOL charAvailable=[self isCharacteristicsAvailable:characteristic];
    
    if (charAvailable==YES && characteristic.properties & (CBCharacteristicPropertyNotify)) {
        
        [self.connectedPeripheral setNotifyValue:b forCharacteristic:characteristic];
        return YES;
        
    }
    else
    {
        return NO;
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic
             error:(NSError *)error {
    
    if (error) {
        NSLog(@"Error changing notification state: %@",
              [error localizedDescription]);
        return;
    }
    
    else
    {
        
        if ([self.delegate respondsToSelector:@selector(subscriptionStateChanged)]) {
            [self.delegate subscriptionStateChanged];
        }
    }
    
    
}
//---------------------------------------------------------------------------------------------------------------
-(BOOL)resetHartRateControlPoint
{
    if(![self checkPeripheralConnection]){
        return NO;
    }
    Byte b = 0x01;
    NSData *d=[NSData dataWithBytes:&b length:1];
    
    if(self.controlPointChar!=nil)
    {
        [self.connectedPeripheral writeValue:d forCharacteristic:self.controlPointChar
                                        type:CBCharacteristicWriteWithResponse];
        return YES;
    }
    return NO;
}

- (void)peripheral:(CBPeripheral *)peripheral
didWriteValueForCharacteristic:(CBCharacteristic *)characteristic
             error:(NSError *)error {
    
    if (error) {
        NSLog(@"Error writing characteristic value: %@",
              [error localizedDescription]);
        return;
    }
    else
    {
        if ([self.delegate respondsToSelector:@selector(didResetControlPoint)]) {
            [self.delegate didResetControlPoint];
        }
    }
}

//---------------------------------------------------------------------------------------------------------------


























@end
