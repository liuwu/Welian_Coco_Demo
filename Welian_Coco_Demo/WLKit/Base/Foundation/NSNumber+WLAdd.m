//
//  NSNumber+WLAdd.m
//  Welian
//
//  Created by weLian on 16/5/13.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import "NSNumber+WLAdd.h"
#import "NSString+WLAdd.h"

@implementation NSNumber (WLAdd)

/**
 创建并返回一个字符串解析成的NSNumber对象.
 有效的格式: @"12", @"12.345", @" -0xFF", @" .23e99 "...
 
 @param string  一个数字字符串.
 
 @return 一个解析成功的NSNumber, 如果出错返回nil.
 */
+ (nullable NSNumber *)wl_numberWithString:(NSString *)string {
    NSString *str = [[string wl_trimWhitespaceAndNewlines] lowercaseString];
    if (!str || !str.length) {
        return nil;
    }
    
    static NSDictionary *dic;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dic = @{@"true" :   @(YES),
                @"yes" :    @(YES),
                @"false" :  @(NO),
                @"no" :     @(NO),
                @"nil" :    [NSNull null],
                @"null" :   [NSNull null],
                @"<null>" : [NSNull null]};
    });
    id num = dic[str];
    if (num) {
        if (num == [NSNull null]) return nil;
        return num;
    }
    
    // hex number
    int sign = 0;
    if ([str hasPrefix:@"0x"]) sign = 1;
    else if ([str hasPrefix:@"-0x"]) sign = -1;
    if (sign != 0) {
        NSScanner *scan = [NSScanner scannerWithString:str];
        unsigned num = -1;
        BOOL suc = [scan scanHexInt:&num];
        if (suc)
            return [NSNumber numberWithLong:((long)num * sign)];
        else
            return nil;
    }
    // normal number
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    return [formatter numberFromString:string];
}

///如果不为整形保留小数点后两位
- (NSString *)wl_keepTwoDecimalPlaces {
    NSString *string = self.stringValue;
    if ([string wl_isPureInt] == NO) {
        string = [NSString stringWithFormat:@"%0.2f",self.floatValue];
    }
    return string;
}

@end
