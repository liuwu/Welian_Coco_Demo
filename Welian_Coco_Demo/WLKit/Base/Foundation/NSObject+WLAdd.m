//
//  NSObject+WLAdd.m
//  Welian
//
//  Created by weLian on 16/5/9.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import "NSObject+WLAdd.h"
#import <objc/runtime.h>

@implementation NSObject (WLAdd)


#pragma mark - Normal
/**
 *  @author liuwu     , 16-05-10
 *
 *  返回类名的字符串
 *  @return 类名
 *  @since V2.7.9
 */
+ (NSString *)wl_className {
    return NSStringFromClass(self);
}

/**
 返回类名的字符串
 
 @讨论 苹果已经在NSObject(NSLayoutConstraintCallsThis)实现了该方法，但没有公开它。
 */
- (NSString *)wl_className {
    return [NSString stringWithUTF8String:class_getName([self class])];
}

/**
 返回一个'NSKeyedArchiver'和'NSKeyedUnarchiver'的实例副本。
 如果发生错误返回nil.
 */
- (nullable id)wl_deepCopy {
    id obj = nil;
    @try {
        obj = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:self]];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
    return obj;
}

/**
 返回一个用archiver和unarchiver生成的实例副本。
 如果发生错误返回nil.
 
 @param archiver   NSKeyedArchiver类或者其他类继承.
 @param unarchiver NSKeyedUnarchiver类或者其他类继承.
 */
- (nullable id)wl_deepCopyWithArchiver:(Class)archiver unarchiver:(Class)unarchiver {
    id obj = nil;
    @try {
        obj = [unarchiver unarchiveObjectWithData:[archiver archivedDataWithRootObject:self]];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
    return obj;
}

#pragma mark - Swap method (Swizzling)
/**
 在一个类中交换两个实例方法的实现。危险，小心使用！
 
 @param originalSel   实例方法 1.
 @param newSel        实例方法 2.
 @return              YES ：交换成功; 否则, NO.
 */
+ (BOOL)wl_swizzleInstanceMethod:(SEL)originalSel with:(SEL)newSel {
    Method originalMethod = class_getInstanceMethod(self, originalSel);
    Method newMethod = class_getInstanceMethod(self, newSel);
    if (!originalMethod || !newMethod) return NO;
    
    class_addMethod(self,
                    originalSel,
                    class_getMethodImplementation(self, originalSel),
                    method_getTypeEncoding(originalMethod));
    class_addMethod(self,
                    newSel,
                    class_getMethodImplementation(self, newSel),
                    method_getTypeEncoding(newMethod));
    
    method_exchangeImplementations(class_getInstanceMethod(self, originalSel),
                                   class_getInstanceMethod(self, newSel));
    return YES;
}

/**
 在一个类中交换两个类方法的实现。危险，小心使用！
 
 @param originalSel   类方法 1.
 @param newSel        类方法 2.
 @return              YES ：交换成功; 否则, NO.
 */
+ (BOOL)wl_swizzleClassMethod:(SEL)originalSel with:(SEL)newSel {
    Class class = object_getClass(self);
    Method originalMethod = class_getInstanceMethod(class, originalSel);
    Method newMethod = class_getInstanceMethod(class, newSel);
    if (!originalMethod || !newMethod) return NO;
    method_exchangeImplementations(originalMethod, newMethod);
    return YES;
}


#pragma mark - Associate value
///=============================================================================
/// @name 附加值
///=============================================================================

/**
 给‘self’附加一个strong对象，
 
 @param value   被附加的对象
 @param key     被附加对象的key.
 */
- (void)wl_setAssociateValue:(nullable id)value withKey:(void *)key {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

/**
 给‘self’附加一个weak对象，
 
 @param value   被附加的对象
 @param key     被附加对象的key.
 */
- (void)wl_setAssociateWeakValue:(nullable id)value withKey:(void *)key {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_ASSIGN);
}

/**
 根据附加对象的key取出附加对象
 
 @param key 附加对象的key.
 */
- (nullable id)wl_getAssociatedValueForKey:(void *)key {
    return objc_getAssociatedObject(self, key);
}

/**
 删除所有的附加对象数据
 */
- (void)wl_removeAssociatedValues {
    objc_removeAssociatedObjects(self);
}

@end
