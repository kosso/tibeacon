/**
 * tibeacon
 *
 * Created by Kosso
 * Copyright (c) 2017
*/

#import "ComKossoTibeaconModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"

@implementation ComKossoTibeaconModule

    
#pragma mark Internal

// this is generated for your module, please do not change it
-(id)moduleGUID
{
    // This will also be the default GUID of the advertising beacon
    return @"d186a5d9-7f48-42d0-81ad-fb1a31f81d3c";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
	return @"com.kosso.tibeacon";
}

#pragma mark Lifecycle

-(void)startup
{
	[super startup];

	NSLog(@"[INFO] %@ loaded",self);
    
    minor = 0;
    major = 0;
    
}

-(void)shutdown:(id)sender
{
	// this method is called when the module is being unloaded
	// typically this is during shutdown. make sure you don't do too
	// much processing here or the app will be quit forceably

	// you *must* call the superclass
	[super shutdown:sender];
}

#pragma mark Cleanup

-(void)dealloc
{
	// release any resources that have been retained by the module
	[super dealloc];
}

#pragma mark Internal Memory Management

-(void)didReceiveMemoryWarning:(NSNotification*)notification
{
	// optionally release any resources that can be dynamically
	// reloaded once memory is available - such as caches
	[super didReceiveMemoryWarning:notification];
}

#pragma mark Listener Notifications

-(void)_listenerAdded:(NSString *)type count:(int)count
{
	if (count == 1 && [type isEqualToString:@"my_event"])
	{
		// the first (of potentially many) listener is being added
		// for event named 'my_event'
	}
}

-(void)_listenerRemoved:(NSString *)type count:(int)count
{
	if (count == 0 && [type isEqualToString:@"my_event"])
	{
		// the last listener called for event named 'my_event' has
		// been removed, we can optionally clean up any resources
		// since no body is listening at this point for that event
	}
}

-(void)checkPermissions
{
    NSString *bluetoothPermissions = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSBluetoothPeripheralUsageDescription"];
    if(!bluetoothPermissions) {
        [self throwException:@"The NSBluetoothPeripheralUsageDescription key is required to interact with Bluetooth on iOS. Please add it to your plist and try it again." subreason:nil location:CODELOCATION];
        return;
    }
}

-(void)initialise:(id)args
{
    [self checkPermissions];
    if(_peripheralManager) {
        [self stopAdvertising:nil];
    }
    _peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];

}
    
-(void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    if(peripheral.state == CBPeripheralManagerStatePoweredOn && advertisingOn) {
        [self startAdvertising:nil];
    }
}

#pragma Public APIs
    
-(BOOL)isAdvertising:(id)args
{
    return advertisingOn;
}

-(void)stopAdvertising:(id)args
{
    NSLog(@"[INFO] Stopping advertising");
    if(_peripheralManager) {
        advertisingOn = NO;
        [_peripheralManager stopAdvertising];
    }
}
    
-(void)startAdvertising:(id)args
{
    [self checkPermissions];
    if(!_peripheralManager) {
        [self initialise:nil];
    }
    _uuid = [[NSUUID alloc] initWithUUIDString:[self moduleGUID]]; // Using the module GUID for now..
    _power = @(broadcastpower); // in .h
    
    NSDictionary *_args = nil;
    
    _args = [args objectAtIndex:0];
    
    if(_args != nil){
        //NSLog(@"[INFO] args dict : %@", _args);
        id _minor = [_args objectForKey:@"minor"];
        if(_minor){
            minor = [[TiUtils numberFromObject:_minor] integerValue];
            //NSLog(@"[INFO] arg MINOR : %d", minor);
        }
        id _major = [_args objectForKey:@"major"];
        if(_major){
            major = [[TiUtils numberFromObject:_major] integerValue];
            //NSLog(@"[INFO] arg MAJOR : %d", major);
        }
    }

    // Default 0 and 0  Set in startup
    NSLog(@"[INFO] Major: %d - Minor: %d", major, minor);
    
    CLBeaconRegion *newregion = [[CLBeaconRegion alloc] initWithProximityUUID:_uuid major:(uint16_t)major minor:(uint16_t)minor identifier:[self moduleId]];
    NSMutableDictionary *peripheralData = [newregion peripheralDataWithMeasuredPower:_power];

    NSLog(@"[INFO] Starting advertising: %@",peripheralData);
    
    advertisingOn = YES;
    [_peripheralManager startAdvertising:peripheralData];
    
}

-(void)setMinor:(id)arg
{
    minor = [TiUtils intValue:arg def:0];
}

-(void)setMajor:(id)arg
{
    major = [TiUtils intValue:arg def:0];
}


@end
