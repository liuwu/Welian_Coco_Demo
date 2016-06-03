//
//  NSFileManager+WLAdd.m
//  Welian
//
//  Created by weLian on 16/5/18.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import "NSFileManager+WLAdd.h"

@implementation NSFileManager (WLAdd)

+ (NSURL *)wl_URLForDirectory:(NSSearchPathDirectory)directory
{
    return [self.defaultManager URLsForDirectory:directory inDomains:NSUserDomainMask].lastObject;
}

+ (NSString *)wl_pathForDirectory:(NSSearchPathDirectory)directory
{
    return [NSSearchPathForDirectoriesInDomains(directory, NSUserDomainMask, YES) objectAtIndex:0];
}

+ (NSString *)wl_tempFolderPath {
    return NSTemporaryDirectory();
}

/**
 获取Documents文件目录的url地址
 */
+ (NSURL *)wl_documentsURL {
    return [self wl_URLForDirectory:NSDocumentDirectory];
}

/**
 获取Documents文件目录的地址字符串
 */
+ (NSString *)wl_documentsPath {
    return [self wl_pathForDirectory:NSDocumentDirectory];
}

/**
 获取Library文件目录的url地址
 */
+ (NSURL *)wl_libraryURL {
    return [self wl_URLForDirectory:NSLibraryDirectory];
}

/**
 获取Library文件目录的地址字符串
 */
+ (NSString *)wl_libraryPath {
    return [self wl_pathForDirectory:NSLibraryDirectory];
}

/**
 获取Caches文件目录的url地址
 */
+ (NSURL *)wl_cachesURL {
    return [self wl_URLForDirectory:NSCachesDirectory];
}

/**
 获取Caches文件目录的地址字符串
 */
+ (NSString *)wl_cachesPath {
    return [self wl_pathForDirectory:NSCachesDirectory];
}

/**
 添加一个特色的文件系统标志，避免iCloud备份文件
 */
+ (BOOL)wl_addSkipBackupAttributeToFile:(NSString *)path {
    NSError *error = nil;
    NSURL *url = [NSURL fileURLWithPath:path isDirectory:YES];
    [url setResourceValue:@(YES) forKey:NSURLIsExcludedFromBackupKey error:&error];
    return error == nil;
    
    //    if (&NSURLIsExcludedFromBackupKey == nil) { // iOS <= 5.0.1
    //        const char* filePath = [[URL path] fileSystemRepresentation];
    //
    //        const char* attrName = "com.apple.MobileBackup";
    //        u_int8_t attrValue = 1;
    //
    //        int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    //        return result == 0;
    //    } else { // iOS >= 5.1
    //        NSError *error = nil;
    //        [URL setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:&error];
    //        return error == nil;
    //    }
}

/**
 获取可用磁盘空间
 */
+ (double)wl_availableDiskSpace {
    NSDictionary *attributes = [self.defaultManager attributesOfFileSystemForPath:self.wl_documentsPath error:nil];
    return [attributes[NSFileSystemFreeSize] unsignedLongLongValue] / (double)0x100000;
}

@end
