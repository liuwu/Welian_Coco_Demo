//
//  UIDevice+WLAddForInfo.m
//  Welian
//
//  Created by 好迪 on 16/5/10.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import "UIDevice+WLAddForInfo.h"
//#import <SSKeychain/SSKeychain.h>
#import "NSString+WLAdd.h"

#include <sys/sysctl.h>
#include <sys/socket.h>
#include <mach/mach.h>

#include <net/if.h>
#include <net/if_dl.h>
#include <arpa/inet.h>
#include <ifaddrs.h>


@implementation UIDevice (WLAddForInfo)

///描述信息，打印设备型号，系统版本，设备ID
+ (NSString *)wl_description{
    NSString *desc = [NSString stringWithFormat:@"\n设备型号:%@;\n系统版本:%@;\n设备ID:%@;\n",kDeviceModelInfo,kDeviceIOSVersion,kDeviceUdid];
    return desc;
}

/// 获取iOS系统的版本号
+ (double)wl_systemVersion {
    static double version;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        version = [UIDevice currentDevice].systemVersion.doubleValue;
    });
    return version;
}

- (BOOL)wl_isPad {
    static dispatch_once_t one;
    static BOOL pad;
    dispatch_once(&one, ^{
        pad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
    });
    return pad;
}

- (BOOL)wl_isSimulator {
#if TARGET_OS_SIMULATOR
    return YES;
#else
    return NO;
#endif
}

- (BOOL)wl_isJailbroken {
    if ([self wl_isSimulator]) return NO; // Dont't check simulator
    
    // iOS9 URL Scheme query changed ...
    // NSURL *cydiaURL = [NSURL URLWithString:@"cydia://package"];
    // if ([[UIApplication sharedApplication] canOpenURL:cydiaURL]) return YES;
    
    NSArray *paths = @[@"/Applications/Cydia.app",
                       @"/private/var/lib/apt/",
                       @"/private/var/lib/cydia",
                       @"/private/var/stash"];
    for (NSString *path in paths) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) return YES;
    }
    
    FILE *bash = fopen("/bin/bash", "r");
    if (bash != NULL) {
        fclose(bash);
        return YES;
    }
    
    NSString *path = [NSString stringWithFormat:@"/private/%@", [NSString wl_stringWithUUID]];
    if ([@"test" writeToFile : path atomically : YES encoding : NSUTF8StringEncoding error : NULL]) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        return YES;
    }
    
    return NO;
}

#ifdef __IPHONE_OS_VERSION_MIN_REQUIRED
- (BOOL)wl_canMakePhoneCalls {
    __block BOOL can;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        can = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://"]];
    });
    return can;
}
#endif

/**
 *	返回统一版本的设备编号，无论系统的操作系统版本
 *  先检测在KeyChain中是否存在udid值
 *  如果存在，则直接读出来用
 *  如果不存在，则产生
 *  产生方式：如果硬件Udid可读，则用Udid 否则用 identifierForVendor 再不行，自己产生一个UUID
 *
 *	@return	udid字符串
 */
- (NSString *)wl_idForDevice{
    NSString *result = @"";
//    BOOL found=FALSE;
    
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
///获取设备信号列表
- (NSDictionary *)getDeviceList {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"DeviceList" ofType:@"plist"];
    NSDictionary *deviceList = [NSDictionary dictionaryWithContentsOfFile:path];
    NSAssert(deviceList != nil, @"DevicePlist not found in the bundle.");
    return deviceList;
}

//设备型号字符串
- (NSString*)wl_machineModel {
    static dispatch_once_t one;
    static NSString *model;
    dispatch_once(&one, ^{
        size_t size;
        sysctlbyname("hw.machine", NULL, &size, NULL, 0);
        char *machine = malloc(size);
        sysctlbyname("hw.machine", machine, &size, NULL, 0);
        model = [NSString stringWithUTF8String:machine];
        free(machine);
    });
    return model;
//    int name[] = {CTL_HW,HW_MACHINE};
//    size_t size = 100;
//    sysctl(name, 2, NULL, &size, NULL, 0); // getting size of answer
//    char *hw_machine = malloc(size);
//    
//    sysctl(name, 2, hw_machine, &size, NULL, 0);
//    NSString *hardware = [NSString stringWithUTF8String:hw_machine];
//    free(hw_machine);
//    return hardware;
}

/// 设备硬件型号
- (NSString*)wl_machineModelName {
    static dispatch_once_t one;
    static NSString *name;
    dispatch_once(&one, ^{
        NSString *model = [self wl_machineModel];
        if (!model) return;
        NSDictionary *deviceList = [self getDeviceList];
        name = [[deviceList objectForKey:model] objectForKey:@"name"];
        if (!name) {
            name = [NSString stringWithFormat:@"iOS Unknow Device:%@",model];
        }
    });
    return name;
}

/**
 *  @author liuwu     , 16-05-12
 *
 *  不带(GSM, CDMA, GLOBAL)的设备硬件型号，如：iphone5
 *  @return 设置型号字符串
 *  @since V2.7.9
 */
- (NSString *)wl_machineModelSimpleName {
    NSString *hardware = [self wl_machineModel];
    if ([hardware isEqualToString:@"iPhone1,1"])    return @"iPhone 2G";
    if ([hardware isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([hardware isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([hardware isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([hardware isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([hardware isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
    if ([hardware isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([hardware isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([hardware isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([hardware isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([hardware isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([hardware isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([hardware isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    
    if ([hardware isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([hardware isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([hardware isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([hardware isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([hardware isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    
    if ([hardware isEqualToString:@"iPod1,1"])      return @"iPod Touch (1 Gen)";
    if ([hardware isEqualToString:@"iPod2,1"])      return @"iPod Touch (2 Gen)";
    if ([hardware isEqualToString:@"iPod3,1"])      return @"iPod Touch (3 Gen)";
    if ([hardware isEqualToString:@"iPod4,1"])      return @"iPod Touch (4 Gen)";
    if ([hardware isEqualToString:@"iPod5,1"])      return @"iPod Touch (5 Gen)";
    
    if ([hardware isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([hardware isEqualToString:@"iPad1,2"])      return @"iPad";
    if ([hardware isEqualToString:@"iPad2,1"])      return @"iPad 2";
    if ([hardware isEqualToString:@"iPad2,2"])      return @"iPad 2";
    if ([hardware isEqualToString:@"iPad2,3"])      return @"iPad 2";
    if ([hardware isEqualToString:@"iPad2,4"])      return @"iPad 2";
    if ([hardware isEqualToString:@"iPad2,5"])      return @"iPad Mini";
    if ([hardware isEqualToString:@"iPad2,6"])      return @"iPad Mini";
    if ([hardware isEqualToString:@"iPad2,7"])      return @"iPad Mini";
    if ([hardware isEqualToString:@"iPad3,1"])      return @"iPad 3";
    if ([hardware isEqualToString:@"iPad3,2"])      return @"iPad 3";
    if ([hardware isEqualToString:@"iPad3,3"])      return @"iPad 3";
    if ([hardware isEqualToString:@"iPad3,4"])      return @"iPad 4";
    if ([hardware isEqualToString:@"iPad3,5"])      return @"iPad 4";
    if ([hardware isEqualToString:@"iPad3,6"])      return @"iPad 4";
    if ([hardware isEqualToString:@"iPad4,1"])      return @"iPad Air";
    if ([hardware isEqualToString:@"iPad4,2"])      return @"iPad Air";
    if ([hardware isEqualToString:@"iPad4,3"])      return @"iPad Air";
    if ([hardware isEqualToString:@"iPad4,4"])      return @"iPad Mini Retina";
    if ([hardware isEqualToString:@"iPad4,5"])      return @"iPad Mini Retina";
    
    if ([hardware isEqualToString:@"i386"])         return @"Simulator";
    if ([hardware isEqualToString:@"x86_64"])       return @"Simulator";
    
    NSLog(@"This is a device which is not listed in this category. Please visit https://github.com/inderkumarrathore/UIDevice-Hardware and add a comment there.");
    NSLog(@"Your device hardware string is: %@", hardware);
    
    if ([hardware hasPrefix:@"iPhone"]) return @"iPhone";
    if ([hardware hasPrefix:@"iPod"]) return @"iPod";
    if ([hardware hasPrefix:@"iPad"]) return @"iPad";
    
    return nil;
}

- (NSDate *)wl_systemUptime {
    NSTimeInterval time = [[NSProcessInfo processInfo] systemUptime];
    return [[NSDate alloc] initWithTimeIntervalSinceNow:(0 - time)];
}


#pragma mark - Network Information
///=============================================================================
/// @name 网络信息
///=============================================================================


typedef struct {
    uint64_t en_in;
    uint64_t en_out;
    uint64_t pdp_ip_in;
    uint64_t pdp_ip_out;
    uint64_t awdl_in;
    uint64_t awdl_out;
} wl_net_interface_counter;


static uint64_t wl_net_counter_add(uint64_t counter, uint64_t bytes) {
    if (bytes < (counter % 0xFFFFFFFF)) {
        counter += 0xFFFFFFFF - (counter % 0xFFFFFFFF);
        counter += bytes;
    } else {
        counter = bytes;
    }
    return counter;
}

static uint64_t wl_net_counter_get_by_type(wl_net_interface_counter *counter, WLNetworkTrafficType type) {
    uint64_t bytes = 0;
    if (type & WLNetworkTrafficTypeWWANSent) bytes += counter->pdp_ip_out;
    if (type & WLNetworkTrafficTypeWWANReceived) bytes += counter->pdp_ip_in;
    if (type & WLNetworkTrafficTypeWIFISent) bytes += counter->en_out;
    if (type & WLNetworkTrafficTypeWIFIReceived) bytes += counter->en_in;
    if (type & WLNetworkTrafficTypeAWDLSent) bytes += counter->awdl_out;
    if (type & WLNetworkTrafficTypeAWDLReceived) bytes += counter->awdl_in;
    return bytes;
}

static wl_net_interface_counter wl_get_net_interface_counter() {
    static dispatch_semaphore_t lock;
    static NSMutableDictionary *sharedInCounters;
    static NSMutableDictionary *sharedOutCounters;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInCounters = [NSMutableDictionary new];
        sharedOutCounters = [NSMutableDictionary new];
        lock = dispatch_semaphore_create(1);
    });
    
    wl_net_interface_counter counter = {0};
    struct ifaddrs *addrs;
    const struct ifaddrs *cursor;
    if (getifaddrs(&addrs) == 0) {
        cursor = addrs;
        dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
        while (cursor) {
            if (cursor->ifa_addr->sa_family == AF_LINK) {
                const struct if_data *data = cursor->ifa_data;
                NSString *name = cursor->ifa_name ? [NSString stringWithUTF8String:cursor->ifa_name] : nil;
                if (name) {
                    uint64_t counter_in = ((NSNumber *)sharedInCounters[name]).unsignedLongLongValue;
                    counter_in = wl_net_counter_add(counter_in, data->ifi_ibytes);
                    sharedInCounters[name] = @(counter_in);
                    
                    uint64_t counter_out = ((NSNumber *)sharedOutCounters[name]).unsignedLongLongValue;
                    counter_out = wl_net_counter_add(counter_out, data->ifi_obytes);
                    sharedOutCounters[name] = @(counter_out);
                    
                    if ([name hasPrefix:@"en"]) {
                        counter.en_in += counter_in;
                        counter.en_out += counter_out;
                    } else if ([name hasPrefix:@"awdl"]) {
                        counter.awdl_in += counter_in;
                        counter.awdl_out += counter_out;
                    } else if ([name hasPrefix:@"pdp_ip"]) {
                        counter.pdp_ip_in += counter_in;
                        counter.pdp_ip_out += counter_out;
                    }
                }
            }
            cursor = cursor->ifa_next;
        }
        dispatch_semaphore_signal(lock);
        freeifaddrs(addrs);
    }
    
    return counter;
}

/**
 获取设备网络流量字节数。
 
 @讨论  这是一个该设备最后启动时间的计数器.
 用法:
 uint64_t bytes = [[UIDevice currentDevice] getNetworkTrafficBytes:WLNetworkTrafficTypeALL];
 NSTimeInterval time = CACurrentMediaTime();
 
 uint64_t bytesPerSecond = (bytes - _lastBytes) / (time - _lastTime);
 
 _lastBytes = bytes;
 _lastTime = time;
 
 @param type 流量类型
 @return 字节计数.
 */
- (uint64_t)wl_getNetworkTrafficBytes:(WLNetworkTrafficType)types {
    wl_net_interface_counter counter = wl_get_net_interface_counter();
    return wl_net_counter_get_by_type(&counter, types);
}


#pragma mark - Disk Space
///=============================================================================
/// @name 磁盘空间
///=============================================================================

/// 磁盘空间大小，字节表示. (出错时为：-1)
- (int64_t)wl_diskSpace {
    NSError *error = nil;
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    if (error) return -1;
    int64_t space =  [[attrs objectForKey:NSFileSystemSize] longLongValue];
    if (space < 0) space = -1;
    return space;
}

/// 空闲的磁盘空间大小，字节表示. (出错时为：-1)
- (int64_t)wl_diskSpaceFree {
    NSError *error = nil;
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    if (error) return -1;
    int64_t space =  [[attrs objectForKey:NSFileSystemFreeSize] longLongValue];
    if (space < 0) space = -1;
    return space;
}

/// 已使用的磁盘空间大小，字节表示. (出错时为：-1)
- (int64_t)wl_diskSpaceUsed {
    int64_t total = self.wl_diskSpace;
    int64_t free = self.wl_diskSpaceFree;
    if (total < 0 || free < 0) return -1;
    int64_t used = total - free;
    if (used < 0) used = -1;
    return used;
}


#pragma mark - Memory Information
///=============================================================================
/// @name 内存信息
///=============================================================================

/// 总的物理内存大小，字节表示. (出错时为：-1)
- (int64_t)wl_memoryTotal {
    int64_t mem = [[NSProcessInfo processInfo] physicalMemory];
    if (mem < -1) mem = -1;
    return mem;
}

/// 使用中的（主动+非活动+有线）内存大小，字节表示.(出错时为：-1)
- (int64_t)wl_memoryUsed {
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t page_size;
    vm_statistics_data_t vm_stat;
    kern_return_t kern;
    
    kern = host_page_size(host_port, &page_size);
    if (kern != KERN_SUCCESS) return -1;
    kern = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    if (kern != KERN_SUCCESS) return -1;
    return page_size * (vm_stat.active_count + vm_stat.inactive_count + vm_stat.wire_count);
}

/// 空闲内存的大小，字节表示. (出错时为：-1)
- (int64_t)wl_memoryFree {
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t page_size;
    vm_statistics_data_t vm_stat;
    kern_return_t kern;
    
    kern = host_page_size(host_port, &page_size);
    if (kern != KERN_SUCCESS) return -1;
    kern = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    if (kern != KERN_SUCCESS) return -1;
    return vm_stat.free_count * page_size;
}

/// 活动中的内存大小，字节表示.(出错时为：-1)
- (int64_t)wl_memoryActive {
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t page_size;
    vm_statistics_data_t vm_stat;
    kern_return_t kern;
    
    kern = host_page_size(host_port, &page_size);
    if (kern != KERN_SUCCESS) return -1;
    kern = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    if (kern != KERN_SUCCESS) return -1;
    return vm_stat.active_count * page_size;
}

/// 非活动内存大小，字节表示. (出错时为：-1)
- (int64_t)wl_memoryInactive {
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t page_size;
    vm_statistics_data_t vm_stat;
    kern_return_t kern;
    
    kern = host_page_size(host_port, &page_size);
    if (kern != KERN_SUCCESS) return -1;
    kern = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    if (kern != KERN_SUCCESS) return -1;
    return vm_stat.inactive_count * page_size;
}

/// 有线内存大小，字节表示. (出错时为：-1)
- (int64_t)wl_memoryWired {
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t page_size;
    vm_statistics_data_t vm_stat;
    kern_return_t kern;
    
    kern = host_page_size(host_port, &page_size);
    if (kern != KERN_SUCCESS) return -1;
    kern = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    if (kern != KERN_SUCCESS) return -1;
    return vm_stat.wire_count * page_size;
}

/// Purgable字节大小，字节表. (出错时为：-1)
- (int64_t)wl_memoryPurgable {
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t page_size;
    vm_statistics_data_t vm_stat;
    kern_return_t kern;
    
    kern = host_page_size(host_port, &page_size);
    if (kern != KERN_SUCCESS) return -1;
    kern = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    if (kern != KERN_SUCCESS) return -1;
    return vm_stat.purgeable_count * page_size;
}


#pragma mark - CPU Information
///=============================================================================
/// @name CPU信息
///=============================================================================

/// 可用的CPU处理器数.
- (NSUInteger)wl_cpuCount {
    return [NSProcessInfo processInfo].activeProcessorCount;
}

/// 当前的CPU处理器的使用率，1.0指100% (出错时为：-1)
- (float)wl_cpuUsage {
    float cpu = 0;
    NSArray *cpus = [self wl_cpuUsagePerProcessor];
    if (cpus.count == 0) return -1;
    for (NSNumber *n in cpus) {
        cpu += n.floatValue;
    }
    return cpu;
}

/// 当前使用的CPU处理所有使用率（NSNumber的数组），1.0指100%.出错时：nil
- (NSArray *)wl_cpuUsagePerProcessor {
    processor_info_array_t _cpuInfo, _prevCPUInfo = nil;
    mach_msg_type_number_t _numCPUInfo, _numPrevCPUInfo = 0;
    unsigned _numCPUs;
    NSLock *_cpuUsageLock;
    
    int _mib[2U] = { CTL_HW, HW_NCPU };
    size_t _sizeOfNumCPUs = sizeof(_numCPUs);
    int _status = sysctl(_mib, 2U, &_numCPUs, &_sizeOfNumCPUs, NULL, 0U);
    if (_status)
        _numCPUs = 1;
    
    _cpuUsageLock = [[NSLock alloc] init];
    
    natural_t _numCPUsU = 0U;
    kern_return_t err = host_processor_info(mach_host_self(), PROCESSOR_CPU_LOAD_INFO, &_numCPUsU, &_cpuInfo, &_numCPUInfo);
    if (err == KERN_SUCCESS) {
        [_cpuUsageLock lock];
        
        NSMutableArray *cpus = [NSMutableArray new];
        for (unsigned i = 0U; i < _numCPUs; ++i) {
            Float32 _inUse, _total;
            if (_prevCPUInfo) {
                _inUse = (
                          (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER]   - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER])
                          + (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM] - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM])
                          + (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE]   - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE])
                          );
                _total = _inUse + (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE] - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE]);
            } else {
                _inUse = _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER] + _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM] + _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE];
                _total = _inUse + _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE];
            }
            [cpus addObject:@(_inUse / _total)];
        }
        
        [_cpuUsageLock unlock];
        if (_prevCPUInfo) {
            size_t prevCpuInfoSize = sizeof(integer_t) * _numPrevCPUInfo;
            vm_deallocate(mach_task_self(), (vm_address_t)_prevCPUInfo, prevCpuInfoSize);
        }
        return cpus;
    } else {
        return nil;
    }
}


@end
