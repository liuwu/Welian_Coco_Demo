//
//  NSArray+WLAdd.m
//  Welian
//
//  Created by weLian on 16/5/11.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import "NSArray+WLAdd.h"
#import "NSData+WLAdd.h"

@implementation NSArray (WLAdd)


/**
 把属性列表数据转换为数组
 
 @param plist   根对象为数组的属性列表数据.
 @return 一个从plist数据中解析的数组, 如果出错返回nil.
 */
+ (nullable NSArray *)wl_arrayWithPlistData:(NSData *)plist {
    if (!plist) return nil;
    NSArray *array = [NSPropertyListSerialization propertyListWithData:plist options:NSPropertyListImmutable format:NULL error:NULL];
    if ([array isKindOfClass:[NSArray class]]) return array;
    return nil;
}

/**
 把xml的属性列表字符串转换为数组
 
 @param plist   跟对象为数组的xml属性列表字符串.
 @return 一个从plist字符串中解析的数组, 如果出错返回nil.
 */
+ (nullable NSArray *)wl_arrayWithPlistString:(NSString *)plist {
    if (!plist) return nil;
    NSData *data = [plist dataUsingEncoding:NSUTF8StringEncoding];
    return [self wl_arrayWithPlistData:data];
}

/**
 把数组转换为属性列表
 
 @return 一个plist数据, 如果出错返回nil.
 */
- (nullable NSData *)wl_plistData {
    return [NSPropertyListSerialization dataWithPropertyList:self format:NSPropertyListBinaryFormat_v1_0 options:kNilOptions error:NULL];
    
}

/**
 把数组转换为xml属性列表字符串
 
 @return 一个xml属性列表字符串, 如果出错返回nil.
 */
- (nullable NSString *)wl_plistString {
    NSData *xmlData = [NSPropertyListSerialization dataWithPropertyList:self format:NSPropertyListXMLFormat_v1_0 options:kNilOptions error:NULL];
    if (xmlData) return xmlData.wl_utf8String;
    return nil;
}

/**
 返回数组中随机对象的索引。
 
 @return  在数组的对象中返回一个随机的索引值.如果数组为空，返回nil.
 */
- (nullable id)wl_randomObject {
    if (self.count) {
        return self[arc4random_uniform((u_int32_t)self.count)];
    }
    return nil;
}

/**
 返回索引处的对象，或超出边界时返回nil。 它类似与'objectAtIndex:',但它不会抛出异常。
 
 @param index 对象的索引值.
 */
- (nullable id)wl_objectOrNilAtIndex:(NSUInteger)index {
    return index < self.count ? self[index] : nil;
}

/**
 把数组转换为json字符串。 如果出错返回nil.
 NSString/NSNumber/NSDictionary/NSArray
 */
- (nullable NSString *)wl_jsonStringEncoded {
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        if (!error) return json;
    }
    return nil;
}

/**
 把数组转换为格式化的json字符串。如果出错返回Nil.
 */
- (nullable NSString *)wl_jsonPrettyStringEncoded {
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        if (!error) return json;
    }
    return nil;
}

@end



@implementation NSMutableArray (WLAdd)

/**
 把指定的属性列表数据转换为数组
 
 @param plist   根对象为数组的属性列表数据.
 @return 一个从plist数据中解析的数组, 如果出错返回nil.
 */
+ (nullable NSMutableArray *)wl_arrayWithPlistData:(NSData *)plist {
    if (!plist) return nil;
    NSMutableArray *array = [NSPropertyListSerialization propertyListWithData:plist options:NSPropertyListMutableContainersAndLeaves format:NULL error:NULL];
    if ([array isKindOfClass:[NSMutableArray class]]) return array;
    return nil;
}

/**
 把xml的属性列表字符串转换为数组
 
 @param plist   跟对象为数组的xml属性列表字符串.
 @return 一个从plist字符串中解析的数组, 如果出错返回nil.
 */
+ (nullable NSMutableArray *)wl_arrayWithPlistString:(NSString *)plist {
    if (!plist) return nil;
    NSData *data = [plist dataUsingEncoding:NSUTF8StringEncoding];
    return [self wl_arrayWithPlistData:data];
}

/**
 移除数组中的第一个索引的对象。如果数组是空的，该方法没有效果。
 
 @讨论 苹果已经实现了该方法，但是并没有公开. 重写覆盖使用它安全。
 Override for safe.
 */
- (void)removeFirstObject {
    if (self.count) {
        [self removeObjectAtIndex:0];
    }
}

/**
 移除数组中最后一个索引的对象。如果数组是空的，该方法没有效果。
 
 @讨论 苹果的实现表示如果数组是空的，它将报出一个NSRangeException的错误，但事实上没有什么会发生。重写覆盖使用它安全.
 */
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
- (void)removeLastObject {
    if (self.count) {
        [self removeObjectAtIndex:self.count - 1];
    }
}

#pragma clang diagnostic pop

/**
 删除并返回数组中的最小值索引的对象。如果数组是空，它只返回nil.
 
 @return 第一个对象或nil.
 */
- (nullable id)wl_popFirstObject {
    id obj = nil;
    if (self.count) {
        obj = self.firstObject;
        [self removeFirstObject];
    }
    return obj;
}

/**
 删除并返回数组中的最大索引的对象。如果数组是空，它只返回nil.
 
 @return 最后一个对象或nil.
 */
- (nullable id)wl_popLastObject {
    id obj = nil;
    if (self.count) {
        obj = self.lastObject;
        [self removeLastObject];
    }
    return obj;
}

/**
 在数组的末端插入一个给定的对象。
 
 @param anObject 添加到数组中的对象。
 这个值不能为nil。如果对象是nil报出一个NSInvalidArgumentException错误
 */
- (void)wl_appendObject:(id)anObject {
    [self addObject:anObject];
}

/**
 在数组的开头加入一个给定的对象。
 
 @param anObject 添加到数组中的对象.
 这个值不能为nil.如果对象是nil报出一个NSInvalidArgumentException错误
 */
- (void)wl_prependObject:(id)anObject {
    [self insertObject:anObject atIndex:0];
}

/**
 将给定数组中包含的对象添加到当前的数组中。
 
 @param objects 添加到接收数组最后面的对象属性. 如果对象是空或nil,此方法没有效果.
 */
- (void)wl_appendObjects:(NSArray *)objects {
    if (!objects) return;
    [self addObjectsFromArray:objects];
}

/**
 将给定数组中包含的对象添加到接收数组的开始位置。
 
 @param objects 添加到接收数组的开始位置的对象数组。如果对象是空或nil,此方法没有效果。
 */
- (void)prependObjects:(NSArray *)objects {
    if (!objects) return;
    NSUInteger i = 0;
    for (id obj in objects) {
        [self insertObject:obj atIndex:i++];
    }
}

/**
 将给定数组中的包含对象添加到接收数组的给定索引位置
 
 @param objects 添加到接收数组中的对象数组. 如果对象是空或nil,此方法没有效果。
 
 @param index  插入对象在当前数组的索引. 该值必须小于数组中元素的计数。如果索引大于数组中元素的个数报出NSRangeException的错误
 */
- (void)wl_insertObjects:(NSArray *)objects atIndex:(NSUInteger)index {
    NSUInteger i = index;
    for (id obj in objects) {
        [self insertObject:obj atIndex:i++];
    }
}

/**
 反转对象在数组中的索引位置。
 例如: Before @[ @1, @2, @3 ], After @[ @3, @2, @1 ].
 */
- (void)wl_reverse {
    NSUInteger count = self.count;
    int mid = floor(count / 2.0);
    for (NSUInteger i = 0; i < mid; i++) {
        [self exchangeObjectAtIndex:i withObjectAtIndex:(count - (i + 1))];
    }
}

/**
 随机排序该数组的对象
 */
- (void)wl_shuffle {
    for (NSUInteger i = self.count; i > 1; i--) {
        [self exchangeObjectAtIndex:(i - 1)
                  withObjectAtIndex:arc4random_uniform((u_int32_t)i)];
    }
}

@end

