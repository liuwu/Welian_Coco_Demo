//
//  NSNotificationCenter+WLAdd.m
//  Welian
//
//  Created by weLian on 16/5/16.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import "NSNotificationCenter+WLAdd.h"
#include <pthread.h>

@implementation NSNotificationCenter (WLAdd)

+ (void)_wl_postNotification:(NSNotification *)notification {
    [[self defaultCenter] postNotification:notification];
}

+ (void)_wl_postNotificationName:(NSDictionary *)info {
    NSString *name = [info objectForKey:@"name"];
    id object = [info objectForKey:@"object"];
    NSDictionary *userInfo = [info objectForKey:@"userInfo"];
    
    [[self defaultCenter] postNotificationName:name object:object userInfo:userInfo];
}

/**
 在主线程中发送一个给定的通知给接收者。如果当前线程是主线程，则同步发送通知。否则，以异步方式发送。
 
 @param notification  发送的通知.
 如果通知是nil会引发异常.
 */
- (void)wl_postNotificationOnMainThread:(NSNotification *)notification {
    if (pthread_main_np()) return [self postNotification:notification];
    [self wl_postNotificationOnMainThread:notification waitUntilDone:NO];
}

/**
 在主线程发送一个给定的通知给接收者。
 
 @param notification 发送的通知.
 如果通知是nil会引发异常.
 
 @param wait   一个布尔值用来指定是否阻塞线程直到通知在主线程上发送给接收者.
 指定YES阻止当前线程; 否则, 指定NO此方法立即返回。
 */
- (void)wl_postNotificationOnMainThread:(NSNotification *)notification
                          waitUntilDone:(BOOL)wait {
    if (pthread_main_np()) return [self postNotification:notification];
    [[self class] performSelectorOnMainThread:@selector(_wl_postNotification:) withObject:notification waitUntilDone:wait];
}

/**
 在主线程发送一个用给定的名称创建的通知给接收者. 如果当前线程是主线程，则同步通知；否则，异步通知.
 
 @param name    通知的名称.
 @param object  发送通知的对象.
 */
- (void)wl_postNotificationOnMainThreadWithName:(NSString *)name
                                         object:(nullable id)object {
    if (pthread_main_np()) return [self postNotificationName:name object:object userInfo:nil];
    [self wl_postNotificationOnMainThreadWithName:name object:object userInfo:nil waitUntilDone:NO];
}

/**
 在主线程发送一个用给定的名称创建的通知给接收者. 如果当前线程是主线程，则同步通知；否则，异步通知.
 
 @param name    通知的名称.
 @param object  发送通知的对象.
 @param userInfo  有关通知的信息. 可能是nil.
 */
- (void)wl_postNotificationOnMainThreadWithName:(NSString *)name
                                         object:(nullable id)object
                                       userInfo:(nullable NSDictionary *)userInfo {
    if (pthread_main_np()) return [self postNotificationName:name object:object userInfo:userInfo];
    [self wl_postNotificationOnMainThreadWithName:name object:object userInfo:userInfo waitUntilDone:NO];
}

/**
 在主线程发送一个用给定的名称创建的通知给接收者.
 
 @param name    通知的名称.
 @param object  发送通知的对象.
 @param userInfo  有关通知的信息. 可能是nil.
 @param wait    一个布尔值用来指定是否阻塞线程直到通知在主线程上发送给接收者.
 指定YES阻止当前线程; 否则, 指定NO此方法立即返回。
 */
- (void)wl_postNotificationOnMainThreadWithName:(NSString *)name
                                         object:(nullable id)object
                                       userInfo:(nullable NSDictionary *)userInfo
                                  waitUntilDone:(BOOL)wait {
    if (pthread_main_np()) return [self postNotificationName:name object:object userInfo:userInfo];
    NSMutableDictionary *info = [[NSMutableDictionary allocWithZone:nil] initWithCapacity:3];
    if (name) [info setObject:name forKey:@"name"];
    if (object) [info setObject:object forKey:@"object"];
    if (userInfo) [info setObject:userInfo forKey:@"userInfo"];
    [[self class] performSelectorOnMainThread:@selector(_wl_postNotificationName:) withObject:info waitUntilDone:wait];
}

@end
