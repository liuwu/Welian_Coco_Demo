//
//  NSTimer+WLAdd.h
//  Welian
//
//  Created by weLian on 16/5/13.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 NS_ASSUME_NONNULL_BEGIN  NS_ASSUME_NONNULL_END
 在这两个宏之间的代码，所有简单指针对象都被假定为nonnull，因此我们只需要去指定那些nullable的指针。
 */
NS_ASSUME_NONNULL_BEGIN

/**
 NSTimer提供的扩展.
 */
@interface NSTimer (WLAdd)

/**
 *  @author liuwu     , 16-05-13
 *
 *  暂停NSTimer
 *  @since V2.7.9
 */
- (void)wl_pauseTimer;

/**
 *  @author liuwu     , 16-05-13
 *
 *  开始NSTimer
 *  @since V2.7.9
 */
- (void)wl_resumeTimer;

/**
 *  @author liuwu     , 16-05-13
 *
 *  延迟开始NSTimer
 *  @param interval 时间
 *  @since V2.7.9
 */
- (void)wl_resumeTimerAfterTimeInterval:(NSTimeInterval)interval;

/**
 创建一个默认模式的NSTimer。
 
 @讨论     在指定时间后触发定时器发送消息给目标.
 
 @param seconds  计时器和事件之间的秒数. 如果秒小于或等于0.0，该方法选择非负值0.1毫秒。
 @param block    定时器回调. 定时维护一个代码块直到它（定时器）无效。
 @param repeats  YES:定时器将重复执行直到定时器无效。NO:定时器将在执行后失效。
 @return 一个新的NSTimer对象, 根据指定的参数配置.
 */
+ (NSTimer *)wl_scheduledTimerWithTimeInterval:(NSTimeInterval)seconds block:(void (^)(NSTimer *timer))block repeats:(BOOL)repeats;

/**
 创建一个对指定块进行初始化的新的NSTimer对象。
 
 @讨论      你必须添加新的定时器循环运行, 使用addTimer:forMode:.
 然后,几秒钟后定时器触发，调用代码块. (如果该定时器配置为重复，则不需要将计时器重新添加到循环运行。)
 
 @param seconds  计时器和事件之间的秒数. 如果秒小于或等于0.0，该方法选择非负值0.1毫秒。
 @param block    定时器回调. 定时维护一个代码块直到它（定时器）无效。
 @param repeats  YES:定时器将重复执行直到定时器无效。NO:定时器将在执行后失效。
 @return 一个新的NSTimer对象, 根据指定的参数配置.
 */
+ (NSTimer *)wl_timerWithTimeInterval:(NSTimeInterval)seconds block:(void (^)(NSTimer *timer))block repeats:(BOOL)repeats;

@end

NS_ASSUME_NONNULL_END
