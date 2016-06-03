//
//  UIDevice+WLAddForInfo.h
//  Welian
//
//  Created by 好迪 on 16/5/10.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (WLAddForInfo)

+ (NSString *)description;

// 获取iOS系统的版本号
+ (NSString *)systemVersion;

/**
 *	返回统一版本的设备编号，无论系统的操作系统版本
 *  先检测在KeyChain中是否存在udid值
 *  如果存在，则直接读出来用
 *  如果不存在，则产生
 *  产生方式：如果硬件Udid可读，则用Udid 否则用 identifierForVendor 再不行，自己产生一个UUID
 *
 *	@return	udid字符串
 */
+ (NSString *)idForDevice;

// 设备硬件型号
+ (NSString *)hardwareDescription;

@end
