//
//  NSUserDefaults+WLAdd.m
//  Welian
//
//  Created by weLian on 16/5/14.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import "NSUserDefaults+WLAdd.h"

@implementation NSUserDefaults (WLAdd)

+ (void)setBool:(BOOL)value forKey:(NSString *)key {
    NSUserDefaults *defaults = kUserDefaults;
    [defaults setBool:value forKey:key];
    [defaults synchronize];
}

+ (BOOL)boolForKey:(NSString *)key {
    return [kUserDefaults boolForKey:key];
}


+ (void)setObject:(id)value forKey:(NSString *)key {
    NSUserDefaults *defaults = kUserDefaults;
    [defaults setObject:value forKey:key];
    [defaults synchronize];
}

+ (id)objectForKey:(NSString *)key {
    return [kUserDefaults objectForKey:key];
}

+ (void)removeObjectForKey:(NSString *)key {
    NSUserDefaults *defaults = kUserDefaults;
    [defaults removeObjectForKey:key];
    [defaults synchronize];
}

+ (void)setString:(NSString *)value forKey:(NSString *)key {
    [NSUserDefaults setObject:value forKey:key];
}

+ (NSString *)stringForKey:(NSString *)key {
    return [kUserDefaults stringForKey:key];
}

+ (void)setInteger:(NSInteger)value forKey:(NSString *)key {
    NSUserDefaults *defaults = kUserDefaults;
    [defaults setInteger:value forKey:key];
    [defaults synchronize];
}

+ (NSInteger)intForKey:(NSString *)key {
    return [kUserDefaults integerForKey:key];
}

+ (void)registerDefaultValueWithTestKey:(NSString *)key {
    NSUserDefaults *standardUserDefaults = kUserDefaults;
    NSString *val = nil;
    
    if (standardUserDefaults) {
        val = [standardUserDefaults valueForKey:key];
    }
    
    if (val == nil) {
        NSString *bPath = [[NSBundle mainBundle] bundlePath];
        NSString *settingPath = [bPath stringByAppendingPathComponent:@"Settings.bundle"];
        NSString *plistPath = [settingPath stringByAppendingPathComponent:@"Root.plist"];
        
        NSDictionary *settingsDictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];
        NSArray *preferencesArray = [settingsDictionary objectForKey:@"PreferenceSpecifiers"];
        
        NSDictionary *item;
        for (item in preferencesArray) {
            NSString *keyValue = [item objectForKey:@"Key"];
            
            id defaultValue = [item objectForKey:@"DefaultValue"];
            
            if (keyValue && defaultValue) {
                [standardUserDefaults setObject:defaultValue forKey:keyValue];
            }
        }
        [standardUserDefaults synchronize];
    }
}

@end
