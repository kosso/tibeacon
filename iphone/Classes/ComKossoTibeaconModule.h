/**
 * tibeacon
 *
 * Created by Kosso
 * Copyright (c) 2017 . All rights reserved.
 */

#import "TiModule.h"

#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>

static int broadcastpower = -59;


@interface ComKossoTibeaconModule : TiModule <CBPeripheralManagerDelegate>
{
    NSUUID *_uuid;
    NSNumber *_power;
    CLBeaconRegion *region;
    CBPeripheralManager *_peripheralManager;
    BOOL advertisingOn;
    NSInteger major;
    NSInteger minor;
    NSString *indentifier;
    NSString *uuid;
}
    
@end
