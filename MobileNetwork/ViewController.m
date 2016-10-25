//
//  ViewController.m
//  MobileNetwork
//
//  Created by Minal Soni on 24/10/16.
//  Copyright © 2016 Minal Soni. All rights reserved.
//

#import "ViewController.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <SystemConfiguration/SystemConfiguration.h>
@import SystemConfiguration.CaptiveNetwork;
@interface ViewController () {
    IBOutlet UILabel *mobileNetworkName;
    IBOutlet UILabel *ssidName;
    IBOutlet UILabel *bssid;
    IBOutlet UILabel *ssidData;
    IBOutlet UILabel *mobile;
    IBOutlet UILabel *mobileCountryCode;
    IBOutlet UILabel *mobileNetworkCode;
    IBOutlet UILabel *isoCountryCode;
}
@end

@implementation ViewController
-(void)viewDidLoad {
    [super viewDidLoad];
    [self setupMobileNetworkInfo];
}

-(void)setupMobileNetworkInfo {
    CTTelephonyNetworkInfo *phoneInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *phoneCarrier = [phoneInfo subscriberCellularProvider];
    mobileNetworkName.text = [phoneCarrier carrierName];
    mobileCountryCode.text = [phoneCarrier mobileCountryCode];
    mobileNetworkCode.text = [phoneCarrier mobileNetworkCode];
    isoCountryCode.text = [phoneCarrier isoCountryCode];
    NSDictionary *ssidInfo = [self fetchSSIDInfo];
    ssidName.text = [ssidInfo valueForKey:@"SSID"];
    bssid.text = [ssidInfo valueForKey:@"BSSID"];
}


- (NSDictionary *)fetchSSIDInfo {
    NSArray *interfaceNames = CFBridgingRelease(CNCopySupportedInterfaces());
    NSLog(@"%s: Supported interfaces: %@", __func__, interfaceNames);
    
    NSDictionary *SSIDInfo;
    for (NSString *interfaceName in interfaceNames) {
        SSIDInfo = CFBridgingRelease(
                                     CNCopyCurrentNetworkInfo((__bridge CFStringRef)interfaceName));
        NSLog(@"%s: %@ => %@", __func__, interfaceName, SSIDInfo);
        
        BOOL isNotEmpty = (SSIDInfo.count > 0);
        if (isNotEmpty) {
            break;
        }
    }
    return SSIDInfo;
}

@end
