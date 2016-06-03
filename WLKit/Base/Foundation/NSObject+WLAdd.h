//
//  NSObject+WLAdd.h
//  Welian
//
//  Created by weLian on 16/5/9.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 NS_ASSUME_NONNULL_BEGIN  NS_ASSUME_NONNULL_END
 在这两个宏之间的代码，所有简单指针对象都被假定为nonnull，因此我们只需要去指定那些nullable的指针。
 */
NS_ASSUME_NONNULL_BEGIN

/**
 *  @author liuwu     , 16-05-09
 *
 *  NSObject的常见任务
 */
@interface NSObject (WLAdd)

#pragma mark - Normal
/**
*  @author liuwu     , 16-05-10
*
*  返回类名的字符串
*  @return 类名
*  @since V2.7.9
*/
+ (NSString *)wl_className;

/**
 返回类名的字符串
 
 @讨论 苹果已经在NSObject(NSLayoutConstraintCallsThis)实现了该方法，但没有公开它。
*/
- (NSString *)wl_className;

/**
 返回一个'NSKeyedArchiver'和'NSKeyedUnarchiver'的实例副本。
 如果发生错误返回nil.
 */
- (nullable id)wl_deepCopy;

/**
 返回一个用archiver和unarchiver生成的实例副本。
 如果发生错误返回nil.
 
 @param archiver   NSKeyedArchiver类或者其他类继承.
 @param unarchiver NSKeyedUnarchiver类或者其他类继承.
 */
- (nullable id)wl_deepCopyWithArchiver:(Class)archiver unarchiver:(Class)unarchiver;

#pragma mark - Swap method (Swizzling)
/**
 在一个类中交换两个实例方法的实现。危险，小心使用！
 
 @param originalSel   实例方法 1.
 @param newSel        实例方法 2.
 @return              YES ：交换成功; 否则, NO.
 */
+ (BOOL)wl_swizzleInstanceMethod:(SEL)originalSel with:(SEL)newSel;

/**
 在一个类中交换两个类方法的实现。危险，小心使用！
 
 @param originalSel   类方法 1.
 @param newSel        类方法 2.
 @return              YES ：交换成功; 否则, NO.
 */
+ (BOOL)wl_swizzleClassMethod:(SEL)originalSel with:(SEL)newSel;

#pragma mark - Associate value
///=============================================================================
/// @name 附加值
///=============================================================================

/**
 给‘self’附加一个strong对象，
 
 @param value   被附加的对象
 @param key     被附加对象的key.
 */
- (void)wl_setAssociateValue:(nullable id)value withKey:(void *)key;

/**
 给‘self’附加一个weak对象，
 
 @param value   被附加的对象
 @param key     被附加对象的key.
 */
- (void)wl_setAssociateWeakValue:(nullable id)value withKey:(void *)key;

/**
 根据附加对象的key取出附加对象
 
 @param key 附加对象的key.
 */
- (nullable id)wl_getAssociatedValueForKey:(void *)key;

/**
 删除所有的附加对象数据
 */
- (void)wl_removeAssociatedValues;


@end

NS_ASSUME_NONNULL_END
