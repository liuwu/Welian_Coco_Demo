//
//  NSUserDefaults+WLAdd.h
//  Welian
//
//  Created by weLian on 16/5/14.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef kUserDefaults
#define kUserDefaults [NSUserDefaults standardUserDefaults]
#endif

//本地数据存储
#define SaveLoginMobile(mobile) [NSUserDefaults setString:mobile forKey:@"kLastLoginMobile"]
#define GetLastLoginMobile [NSUserDefaults stringForKey:@"kLastLoginMobile"]

//#define SaveLoginPassWD(pass) [NSUserDefaults setString:pass forKey:@"kLastLoginPassWord"]
//#define lastLoginPassWD [NSUserDefaults stringForKey:@"kLastLoginPassWord"]

@interface NSUserDefaults (WLAdd)

//read/wrtie bool values
+ (void)setBool:(BOOL)value forKey:(NSString *)key;
+ (BOOL)boolForKey:(NSString *)key;

//read/write string values
+ (void)setString:(NSString *)value forKey:(NSString *)key;
+ (NSString *)stringForKey:(NSString *)key;

//read/write int values
+ (void)setInteger:(NSInteger)value forKey:(NSString *)key;
+ (NSInteger)intForKey:(NSString *)key;

+ (void)setObject:(id)value forKey:(NSString *)key;
+ (id)objectForKey:(NSString *)key;

+ (void)removeObjectForKey:(NSString *)key;

// register
+ (void)registerDefaultValueWithTestKey:(NSString *)key;

@end
