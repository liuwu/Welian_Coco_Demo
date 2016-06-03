//
//  UIDevice+WLAddForInfo.m
//  Welian
//
//  Created by 好迪 on 16/5/10.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import "UIDevice+WLAddForInfo.h"
//#import <SSKeychain/SSKeychain.h>

#include <sys/sysctl.h>


@implementation UIDevice (WLAddForInfo)

+ (NSString *)systemVersion{
    return [[UIDevice currentDevice] systemVersion];
}

+ (NSString *) idForDevice;
{
    NSString *result = @"";
//    BOOL found=FALSE;
//    
//    NSError *error = nil;
//    SSKeychainQuery *query = [[SSKeychainQuery alloc] init];
//    query.service = @"com.chuansongmen.welianos";
//    query.account = @"udid";
//    [query fetch:&error];
//    
//    if ([error code] == errSecItemNotFound) {
//        NSLog(@"Udid NOT FOUND in keychain.");
//    } else if (error != nil) {
//        NSLog(@"Some other error occurred when query keychain: %@", [error localizedDescription]);
//    } else {
//        //取出存储的UdId
//        result=query.password;
//        found=TRUE;
//        NSLog(@"Udid FOUND in keychain.");
//    }
//    
//    if (!found) {
//        UIDevice *thisDevice = [UIDevice currentDevice];
//        if ([thisDevice respondsToSelector: @selector(identifierForVendor)])
//        {
//            NSUUID *myID = [[UIDevice currentDevice] identifierForVendor];
//            result = [myID UUIDString];
//        }
//        else
//        {
//            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//            result = [defaults objectForKey: @"appDeviceId"];
//            if (!result)
//            {
//                CFUUIDRef myCFUUID = CFUUIDCreate(kCFAllocatorDefault);
//                result = (__bridge_transfer NSString *) CFUUIDCreateString(kCFAllocatorDefault, myCFUUID);
//                result=[result copy];
//                [defaults setObject: result forKey: @"appDeviceId"];
//                [defaults synchronize];
//                CFRelease(myCFUUID);
//            }
//        }
//        
//        //存储Udid
//        query.password = result;
//        [query save:&error];
//        
//        if (error != nil) {
//            NSLog(@"Some other error occurred when save keychain: %@", [error localizedDescription]);
//        }
//        else
//            NSLog(@"Save udid to keychain successed!");
//        
//    }
    
    return result;
}

#pragma mark -
+ (NSDictionary *)getDeviceList {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"DeviceList" ofType:@"plist"];
    NSDictionary *deviceList = [NSDictionary dictionaryWithContentsOfFile:path];
    NSAssert(deviceList != nil, @"DevicePlist not found in the bundle.");
    return deviceList;
}

+ (NSString*)hardwareDescription {
    NSString *hardware = [self hardwareString];
    NSDictionary *deviceList = [self getDeviceList];
    NSString *hardwareDescription = [[deviceList objectForKey:hardware] objectForKey:@"name"];
    if (hardwareDescription) {
        return hardwareDescription;
    }
    else {
        return [NSString stringWithFormat:@"iOS Unknow Device:%@",hardware];
    }
}

+ (NSString*)hardwareString {
    int name[] = {CTL_HW,HW_MACHINE};
    size_t size = 100;
    sysctl(name, 2, NULL, &size, NULL, 0); // getting size of answer
    char *hw_machine = malloc(size);
    
    sysctl(name, 2, hw_machine, &size, NULL, 0);
    NSString *hardware = [NSString stringWithUTF8String:hw_machine];
    free(hw_machine);
    return hardware;
}

+ (NSString *)description{
    NSString *desc = [NSString stringWithFormat:@"\n设备型号:%@;\n系统版本:%@;\n设备ID:%@;\n",[self hardwareDescription],[self systemVersion],[self idForDevice]];
//    DLog(@"%@",desc);
    return desc;
}


@end
