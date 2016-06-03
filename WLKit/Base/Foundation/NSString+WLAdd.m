//
//  NSString+WLAdd.m
//  Welian
//
//  Created by weLian on 16/5/9.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import "NSString+WLAdd.h"
#import "NSDate+WLAdd.h"
#import "NSData+WLAdd.h"
#import "NSNumber+WLAdd.h"
#import "NSString+WLAddForRegex.h"

@implementation NSString (WLAdd)

/**
 *  根据图片使用场景生成新的URL地址
 *
 *  @param imageScene 使用场景
 *
 *  @return 新的地址
 */
- (NSString *)imageUrlDownloadImageSceneAvatar
{
    return [self imageUrlManageScene:DownloadImageSceneAvatar condenseSize:CGSizeZero];
}

///转换字符串为阿里云对应的图片压缩格式，方便下载
- (NSString *)imageUrlManageScene:(DownloadImageScene)imageScene condenseSize:(CGSize)condenseSize
{
    NSString *deleExestr = [self stringByDeletingPathExtension];
    if ([deleExestr hasSuffix:@"_x"]) return self;
    NSArray *array = [deleExestr componentsSeparatedByString:@"_"];
    if (array.count<3) {
        return self;
    }
    CGFloat originalWidth = [array[1] floatValue];
    CGFloat originalHeight = [array[2] floatValue];
    long long bytesStr = [[array lastObject] longLongValue];
    CGFloat max = MAX(originalWidth, originalHeight);
    if (max<300) return self;
    
    NSString *thumbType = @"w";
    if (originalWidth > originalHeight) {
        thumbType = @"h";
    }
    // 图片格式，转小写
    NSString *suffixStr = [[self pathExtension] lowercaseStringWithLocale:[NSLocale currentLocale]];
    if (!([suffixStr isEqualToString:@"png"] || [suffixStr isEqualToString:@"jpg"])) {
        suffixStr = @"jpg";
    }
    switch (imageScene) {
        case DownloadImageSceneAvatar:
            return [self stringByAppendingFormat:@"@200w_1o.%@",suffixStr];
            break;
        case DownloadImageSceneThumbnail:
        {
            //缩略图
            //change by liuwu | 2016.2.29 | 添加传入尺寸为0的默认值处理
            if (condenseSize.width == 0 || condenseSize.height == 0) {
                condenseSize = CGSizeMake(150.f, 150.f);
            }
            NSString *widthStr = [NSString stringWithFormat:@"%.0f",condenseSize.width*2];
            return [self stringByAppendingFormat:@"@80Q_%@%@_1o.%@",widthStr, thumbType, suffixStr];
        }
            break;
        case DownloadImageSceneTailor:
        {
            //裁剪图
            //change by liuwu | 2016.2.29 | 添加传入尺寸为0的默认值处理
            if (condenseSize.width == 0 || condenseSize.height == 0) {
                condenseSize = CGSizeMake(150.f, 150.f);
            }
            NSString *widthStr = [NSString stringWithFormat:@"%.0f",condenseSize.width*2];
            NSString *heightStr = [NSString stringWithFormat:@"%.0f",condenseSize.height*2];
            return [self stringByAppendingFormat:@"@%@x%@-5rc_2o.%@",widthStr, heightStr, suffixStr];
        }
            break;
        case DownloadImageSceneBig:
        {
            CGFloat byteM = bytesStr/1024.00f;
            CGFloat min = MIN(originalHeight, originalWidth);
            if (min<1000) {
                CGFloat maxPixel = 20.0;
                if (byteM<=1.0) {
                    return self;
                }else if (byteM>1&&byteM<=8){
                    maxPixel = (10-byteM)*10;
                }
                return [self stringByAppendingFormat:@"@%.fQ_1o.%@",maxPixel, suffixStr];
            }
            
            NSString *oreStr = @"";
            if (originalHeight > 3000 || originalWidth > 3000) {
                if ([thumbType isEqualToString:@"w"]) {
                    oreStr = @"_3000h";
                }else{
                    oreStr = @"_3000w";
                }
            }
            return [self stringByAppendingFormat:@"@%@_1o.%@",oreStr, suffixStr];
        }
            break;
            
        default:
            break;
    }
    return self;
}

#pragma mark - Utilities
///=============================================================================
/// @name 常用方法
///=============================================================================

///把接收的时间毫秒，转换为时间
+ (NSString *)wl_formatterTimeText:(NSTimeInterval)secs
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSDate *send = [NSDate dateWithTimeIntervalSince1970:secs];
    NSString *sendStr = [fmt stringFromDate:send];
    NSDate *now = [NSDate date];
    NSString *nowStr = [fmt stringFromDate:now];
    
    NSDate *yesterday = [[NSDate alloc] initWithTimeIntervalSinceNow:-(24 * 60 * 60)];
    NSString *strYesterday = [fmt stringFromDate:yesterday];
    
    if ([sendStr isEqualToString:nowStr]) {
        fmt.dateFormat = @"HH:mm";
        return [fmt stringFromDate:send];
    }else if([strYesterday isEqualToString:sendStr]){
        fmt.dateFormat = @"HH:mm";
        return [NSString stringWithFormat:@"昨天 %@",[fmt stringFromDate:send]];
    }else{
        return sendStr;
    }
}

/**
 *  解析时间字符串转换成过去的时间
 */
- (NSString *)wl_createdTimeSineNow {
    return [[self wl_dateFormartNormalString] wl_timeAgoSimple];
    /*
     + (NSString *)getCreatedData:(NSString *)created
     {
     // 1.获得微博的发送时间
     NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
     fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
     NSDate *send = [fmt dateFromString:created];
     
     // 2.当前时间
     NSDate *now = [NSDate date];
     
     // 3.获得当前时间和发送时间 的 间隔  (now - send)
     NSString *timeStr = nil;
     NSTimeInterval delta = [now timeIntervalSinceDate:send];
     if (delta < 60) { // 一分钟内
     timeStr = @"刚刚";
     } else if (delta < 60 * 60) { // 一个小时内
     timeStr = [NSString stringWithFormat:@"%.f分钟前", delta/60];
     } else if (delta < 60 * 60 * 24) { // 一天内
     timeStr = [NSString stringWithFormat:@"%.f小时前", delta/60/60];
     } else { // 几天前
     fmt.dateFormat = @"MM-dd";
     timeStr = [fmt stringFromDate:send];
     }
     return timeStr;
     }
     */
}

/**
 *  随机获取英文字母
 *
 *  @param count 字符个数
 *
 *  @return 随机获取英文字母
 */
+ (NSString *)wl_randomString:(NSInteger)count {
    char data[count];
    for (int x=0;x<count;data[x++] = (char)('a' + (arc4random_uniform(26))));
    NSString *randomStr = [[NSString alloc] initWithBytes:data length:count encoding:NSUTF8StringEncoding];
    return randomStr;
}

/**
 *  @author liuwu     , 16-05-12
 *
 *  获取当前时间戳，精确到毫秒
 *  @return 时间戳字符串
 *  @since V2.7.9
 */
+ (NSString *)wl_timeStamp {
    return [[NSNumber numberWithLongLong:[[NSDate date] timeIntervalSince1970]*1000] stringValue];;
}

/**
 *  @author liuwu     , 16-05-09
 *
 *  获取随机UUID，例如： "E621E1F8-C36C-495A-93FC-0C247A3E6E5F"
 *  @return 一个新的UUID字符串
 *  @since V2.7.9.1
 */
+ (NSString *)wl_stringWithUUID{
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuid = CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    return (__bridge_transfer NSString *)uuid;
}

/**
 是否包含给定的字符串
 
 @param string 给定的字符串.
 
 @讨论 评估已经在iOS8实现这个方法,这里重写这个方法.
 */
- (BOOL)containsString:(NSString *)string {
    return [self wl_containsString:string];
}

/**
 是否包含给定的字符串
 
 @param string 给定的字符串.
 
 @讨论 评估已经在iOS8实现这个方法.
 */
- (BOOL)wl_containsString:(NSString *)string {
    if (string == nil) return NO;
    return [self rangeOfString:string].location != NSNotFound;
}

/**
 字符串统一转换小写字母后，判断是否包含给定的字符串
 
 @param string 给定的字符串.
 */
- (BOOL)wl_containsLowercaseString:(NSString *)string {
    if (string == nil) return NO;
    NSRange range = [[self lowercaseString] rangeOfString:[string lowercaseString]];
    return range.location != NSNotFound;
}

/**
 如果目标字符集内包含当前字符串返回YES
 @param set  一个字符集用来测试接收器
 */
- (BOOL)wl_containsCharacterSet:(NSCharacterSet *)set {
    if (set == nil) return NO;
    return [self rangeOfCharacterFromSet:set].location != NSNotFound;
}

/**
 尝试解析这个字符串并返回一个NSNumber.
 @return 如果解析成功返回一个NSNumber, 如果出错返回nil.
 */
- (nullable NSNumber *)wl_numberValue {
    return [NSNumber wl_numberWithString:self];
}

/**
 使用UTF-8编码一个NSData
 */
- (nullable NSData *)wl_dataValue {
    return [self dataUsingEncoding:NSUTF8StringEncoding];
}

/**
 返回NSMakeRange(0, self.length).
 */
- (NSRange)wl_rangeOfAll {
    return NSMakeRange(0, self.length);
}

/**
 解码字符串为NSDictionfary或NSArray.如果发生错误返回nil.
 例如：NSString: @"{"name":"a","count":2}"  => NSDictionary: @[@"name":@"a",@"count":@2]
 */
- (nullable id)wl_jsonValueDecoded {
    return [[self wl_dataValue] wl_jsonValueDecoded];
}


#pragma mark - NSNumber Compatible
///=============================================================================
/// @name NSNumber 兼容
///=============================================================================

// 现在你可以使用NSString作为NSNumber
- (char)charValue {
    return self.wl_numberValue.charValue;
}

- (unsigned char) unsignedCharValue {
    return self.wl_numberValue.unsignedCharValue;
}

- (short)shortValue {
    return self.wl_numberValue.shortValue;
}

- (unsigned short)unsignedShortValue {
    return self.wl_numberValue.unsignedShortValue;
}

- (unsigned int)unsignedIntValue {
    return self.wl_numberValue.unsignedIntValue;
}

- (long)longValue {
    return self.wl_numberValue.longValue;
}

- (unsigned long)unsignedLongValue {
    return self.wl_numberValue.unsignedLongValue;
}

- (unsigned long long)unsignedLongLongValue {
    return self.wl_numberValue.unsignedLongLongValue;
}

- (NSUInteger)unsignedIntegerValue {
    return self.wl_numberValue.unsignedIntegerValue;
}


#pragma mark - 检查是否数字
/**
 *  @author liuwu     , 16-02-29
 *
 *  判断是否为整形
 *  @return YES：是Int类型  NO:不是
 *  @since V2.7.3
 */
- (BOOL)wl_isPureInt {
    NSScanner* scan = [NSScanner scannerWithString:self];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

/**
 *  @author liuwu     , 16-02-29
 *
 *  判断是否为整形
 *  @return YES：是NSInteger类型  NO:不是
 *  @since V2.7.3
 */
- (BOOL)wl_isPureInteger {
    NSScanner* scan = [NSScanner scannerWithString:self];
    int val;
    return [scan scanInteger:&val] && [scan isAtEnd];
}

/**
 *  @author liuwu     , 16-02-29
 *
 *  判断是否为浮点形
 *  @return YES：是float类型  NO:不是
 *  @since V2.7.3
 */
- (BOOL)wl_isPureFloat {
    NSScanner* scan = [NSScanner scannerWithString:self];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}

/**
 *  @author liuwu     , 16-02-29
 *
 *  使用NSString的trimming方法，判断是否都是数字
 *  @return YES:都是数字 or NO：存在字符串
 *  @since V2.7.3
 */
- (BOOL)wl_isPureNumandCharacters {
    NSString *searchStr = [self stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(searchStr.length > 0){
        //包换字符串
        return NO;
    }
    return YES;
}


#pragma mark - Encode and decode
///=============================================================================
/// @name 编码 and 解码
///=============================================================================

/**
 字符串进行base64编码
 */
- (nullable NSString *)wl_base64EncodedString {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] wl_base64EncodedString];
}

/**
 base64编码给定的字符串
 @param base64Encoding base64位编码的字符串.
 */
+ (nullable NSString *)wl_stringWithBase64EncodedString:(NSString *)base64EncodedString {
    NSData *data = [NSData wl_dataWithBase64EncodedString:base64EncodedString];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

/**
 URL编码utf-8字符串.
 @return 编码的字符串.
 */
- (NSString *)wl_stringByURLEncode {
    if ([self respondsToSelector:@selector(stringByAddingPercentEncodingWithAllowedCharacters:)]) {
        /**
         AFNetworking/AFURLRequestSerialization.m
         
         Returns a percent-escaped string following RFC 3986 for a query string key or value.
         RFC 3986 states that the following characters are "reserved" characters.
         - General Delimiters: ":", "#", "[", "]", "@", "?", "/"
         - Sub-Delimiters: "!", "$", "&", "'", "(", ")", "*", "+", ",", ";", "="
         In RFC 3986 - Section 3.4, it states that the "?" and "/" characters should not be escaped to allow
         query strings to include a URL. Therefore, all "reserved" characters with the exception of "?" and "/"
         should be percent-escaped in the query string.
         - parameter string: The string to be percent-escaped.
         - returns: The percent-escaped string.
         */
        static NSString * const kAFCharactersGeneralDelimitersToEncode = @":#[]@"; // does not include "?" or "/" due to RFC 3986 - Section 3.4
        static NSString * const kAFCharactersSubDelimitersToEncode = @"!$&'()*+,;=";
        
        NSMutableCharacterSet * allowedCharacterSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
        [allowedCharacterSet removeCharactersInString:[kAFCharactersGeneralDelimitersToEncode stringByAppendingString:kAFCharactersSubDelimitersToEncode]];
        static NSUInteger const batchSize = 50;
        
        NSUInteger index = 0;
        NSMutableString *escaped = @"".mutableCopy;
        
        while (index < self.length) {
            NSUInteger length = MIN(self.length - index, batchSize);
            NSRange range = NSMakeRange(index, length);
            // To avoid breaking up character sequences such as 👴🏻👮🏽
            range = [self rangeOfComposedCharacterSequencesForRange:range];
            NSString *substring = [self substringWithRange:range];
            NSString *encoded = [substring stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
            [escaped appendString:encoded];
            
            index += range.length;
        }
        return escaped;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        CFStringEncoding cfEncoding = CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding);
        NSString *encoded = (__bridge_transfer NSString *)
        CFURLCreateStringByAddingPercentEscapes(
                                                kCFAllocatorDefault,
                                                (__bridge CFStringRef)self,
                                                NULL,
                                                CFSTR("!#$&'()*+,/:;=?@[]"),
                                                cfEncoding);
        return encoded;
#pragma clang diagnostic pop
    }
}

/**
 URL解码utf-8字符串.
 @return 解码后的字符串.
 */
- (NSString *)wl_stringByURLDecode {
    if ([self respondsToSelector:@selector(stringByRemovingPercentEncoding)]) {
        return [self stringByRemovingPercentEncoding];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        CFStringEncoding en = CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding);
        NSString *decoded = [self stringByReplacingOccurrencesOfString:@"+"
                                                            withString:@" "];
        decoded = (__bridge_transfer NSString *)
        CFURLCreateStringByReplacingPercentEscapesUsingEncoding(
                                                                NULL,
                                                                (__bridge CFStringRef)decoded,
                                                                CFSTR(""),
                                                                en);
        return decoded;
#pragma clang diagnostic pop
    }
}

/**
 转换普通HTML实体。
 例子: "a<b" 转变为 "a&lt;b".
 */
- (NSString *)wl_stringByEscapingHTML {
    NSUInteger len = self.length;
    if (!len) return self;
    
    unichar *buf = malloc(sizeof(unichar) * len);
    if (!buf) return nil;
    [self getCharacters:buf range:NSMakeRange(0, len)];
    
    NSMutableString *result = [NSMutableString string];
    for (int i = 0; i < len; i++) {
        unichar c = buf[i];
        NSString *esc = nil;
        switch (c) {
            case 34: esc = @"&quot;"; break;
            case 38: esc = @"&amp;"; break;
            case 39: esc = @"&apos;"; break;
            case 60: esc = @"&lt;"; break;
            case 62: esc = @"&gt;"; break;
            default: break;
        }
        if (esc) {
            [result appendString:esc];
        } else {
            CFStringAppendCharacters((CFMutableStringRef)result, &c, 1);
        }
    }
    free(buf);
    return result;
}



#pragma mark - Date Formart
///=============================================================================
/// @name 日期格式化
///=============================================================================

/**
 *  @author liuwu     , 16-05-10
 *
 *  最常用的日期格式化转换： “yyyy-MM-dd HH:mm:ss"
 *  @return 格式化后的日期
 *  @since V2.7.9
 */
- (NSDate *)wl_dateFormartNormalString {
    return [NSDate wl_dateWithString:self format:@"yyyy-MM-dd HH:mm:ss"];
}

//
/**
 *  @author liuwu     , 16-05-10
 *
 *  最常用的日期不带秒的时间格式化转换： “yyyy-MM-dd HH:mm"
 *  @return 格式化后的日期
 *  @since V2.7.9
 */
- (NSDate *)wl_dateFormartNormalStringNoss {
    return [NSDate wl_dateWithString:self format:@"yyyy-MM-dd HH:mm"];
}

/**
 *  @author liuwu     , 16-05-10
 *
 *  短日期格式转换： "yyyy-MM-dd"
 *  @return 转化后的日期
 *  @since V2.7.9
 */
- (NSDate *)wl_dateFormartShortString {
    return [NSDate wl_dateWithString:self format:@"yyyy-MM-dd"];
}

/**
 *  @author liuwu     , 16-05-10
 *
 *  短日期格式转换： "yyyy-MM-dd'T'HH:mm:ss.SSS"
 *  @return 转化后的日期
 *  @since V2.7.9
 */
- (NSDate *)wl_dateFormartISOString {
    return [NSDate wl_dateWithString:self format:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
}

/**
 *  @author liuwu     , 16-05-10
 *
 *  只有年月的日期格式转换： "yyyy年MM月"
 *  @return 转化后的日期
 *  @since V2.7.9
 */
- (NSDate *)wl_dateFormartYearAndMonthString {
    return [NSDate wl_dateWithString:self format:@"yyyy年MM月"];
}

//只有年月 yyyy年MM月  对月进行计算，小于10补零
/**
 *  @author liuwu     , 16-05-10
 *
 *  只有年月的日期格式转换,对月进行计算，小于10补零： "yyyy年MM月"
 *  @return 转化后的日期字符串
 *  @since V2.7.9
 */
- (NSString *)wl_dateFormartYearAndMonthAddZoreString {
    NSDate *date = [self wl_dateFormartYearAndMonthString];
    NSInteger month = date.wl_month;
    NSString *dateStr = @"";
    if (month < 10) {
        //小于10，前面补零
        NSString *monthStr = [NSString stringWithFormat:@"0%ld",(long)month];
        dateStr = [NSString stringWithFormat:@"%ld年%@月",(long)date.wl_year,monthStr];
    }else{
        dateStr = [date wl_stringWithFormat:@"yyyy年MM月"];
    }
    return dateStr;
}

#pragma mark - Trims
///=============================================================================
/// @name Trims
///=============================================================================


/**
 *  @author liuwu     , 16-05-12
 *
 *  对电话号码格式化去掉 -( ) 等格式
 *  @return 去掉-（ ）等的电话号码字符串
 *  @since V2.7.9
 */
- (NSString *)wl_telephoneWithReformat {
    NSString *telepStr = [self stringByReplacingOccurrencesOfString:@"-" withString:@""];
    telepStr = [telepStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    telepStr = [telepStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    telepStr = [telepStr stringByReplacingOccurrencesOfString:@"(" withString:@""];
    telepStr = [telepStr stringByReplacingOccurrencesOfString:@")" withString:@""];
    return telepStr;
}

/**
 *  @author liuwu     , 16-05-10
 *
 *  去除字符串头部和尾部的空格符
 *  @return 去除头部和尾部的空格符的字符串
 *  @since V2.7.9
 */
- (NSString *)wl_trimWhitespace {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

/**
 *  @author liuwu     , 16-05-10
 *
 *  去除字符串头部和尾部的换行符
 *  @return 去除头部和尾部的换行符的字符串
 *  @since V2.7.9
 */
- (NSString *)wl_trimNewlines {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
}

/**
 *  @author liuwu     , 16-05-10
 *
 *  去除字符串头部和尾部的空格与换行符
 *  @return 去除空格与换行的字符串
 *  @since V2.7.9
 */
- (NSString *)wl_trimWhitespaceAndNewlines {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

/**
 *  @author liuwu     , 16-05-10
 *
 *  清除html标签
 *  @return 清除后的结果
 *  @since V2.7.9
 */
- (NSString *)wl_stringByStrippingHTML {
    return [self stringByReplacingOccurrencesOfString:@"<[^>]+>" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, self.length)];
}

/**
 *  @author liuwu     , 16-05-10
 *
 *  清除js脚本
 *  @return 清除js后的字符串
 *  @since V2.7.9
 */
- (NSString *)wl_stringByRemovingScriptsAndStrippingHTML {
    NSMutableString *mString = [self mutableCopy];
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<script[^>]*>[\\w\\W]*</script>" options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *matches = [regex matchesInString:mString options:NSMatchingReportProgress range:NSMakeRange(0, [mString length])];
    for (NSTextCheckingResult *match in [matches reverseObjectEnumerator]) {
        [mString replaceCharactersInRange:match.range withString:@""];
    }
    return [mString wl_stringByStrippingHTML];
}

/**
 添加用来修改文件名的比例 (没有路径扩展名),
 从 @"name" to @"name@2x".
 
 例如：
 <table>
 <tr><th>Before     </th><th>After(scale:2)</th></tr>
 <tr><td>"icon"     </td><td>"icon@2x"     </td></tr>
 <tr><td>"icon "    </td><td>"icon @2x"    </td></tr>
 <tr><td>"icon.top" </td><td>"icon.top@2x" </td></tr>
 <tr><td>"/p/name"  </td><td>"/p/name@2x"  </td></tr>
 <tr><td>"/path/"   </td><td>"/path/"      </td></tr>
 </table>
 
 @param scale 资源比例.
 @return 添加比例修改后的字符串，如果它没有结束文件名直接返回.
 */
- (NSString *)wl_stringByAppendingNameScale:(CGFloat)scale {
    if (fabs(scale - 1) <= __FLT_EPSILON__ || self.length == 0 || [self hasSuffix:@"/"]) return self.copy;
    return [self stringByAppendingFormat:@"@%@x", @(scale)];
}

/**
 向文件路径添加修改比例 (路径扩展名),
 从 @"name.png" to @"name@2x.png".
 
 例如
 <table>
 <tr><th>Before     </th><th>After(scale:2)</th></tr>
 <tr><td>"icon.png" </td><td>"icon@2x.png" </td></tr>
 <tr><td>"icon..png"</td><td>"icon.@2x.png"</td></tr>
 <tr><td>"icon"     </td><td>"icon@2x"     </td></tr>
 <tr><td>"icon "    </td><td>"icon @2x"    </td></tr>
 <tr><td>"icon."    </td><td>"icon.@2x"    </td></tr>
 <tr><td>"/p/name"  </td><td>"/p/name@2x"  </td></tr>
 <tr><td>"/path/"   </td><td>"/path/"      </td></tr>
 </table>
 
 @param scale 资源比例.
 @return 添加比例修改后的字符串，如果它没有结束文件名直接返回
 */
- (NSString *)wl_stringByAppendingPathScale:(CGFloat)scale {
    if (fabs(scale - 1) <= __FLT_EPSILON__ || self.length == 0 || [self hasSuffix:@"/"]) return self.copy;
    NSString *ext = self.pathExtension;
    NSRange extRange = NSMakeRange(self.length - ext.length, 0);
    if (ext.length > 0) extRange.location -= 1;
    NSString *scaleStr = [NSString stringWithFormat:@"@%@x", @(scale)];
    return [self stringByReplacingCharactersInRange:extRange withString:scaleStr];
}

/**
 返回路径的比例。
 
 例如.
 <table>
 <tr><th>Path            </th><th>Scale </th></tr>
 <tr><td>"icon.png"      </td><td>1     </td></tr>
 <tr><td>"icon@2x.png"   </td><td>2     </td></tr>
 <tr><td>"icon@2.5x.png" </td><td>2.5   </td></tr>
 <tr><td>"icon@2x"       </td><td>1     </td></tr>
 <tr><td>"icon@2x..png"  </td><td>1     </td></tr>
 <tr><td>"icon@2x.png/"  </td><td>1     </td></tr>
 </table>
 */
- (CGFloat)wl_pathScale {
    if (self.length == 0 || [self hasSuffix:@"/"]) return 1;
    NSString *name = self.stringByDeletingPathExtension;
    __block CGFloat scale = 1;
    [name wl_enumerateRegexMatches:@"@[0-9]+\\.?[0-9]*x$" options:NSRegularExpressionAnchorsMatchLines usingBlock: ^(NSString *match, NSRange matchRange, BOOL *stop) {
        scale = [match substringWithRange:NSMakeRange(1, match.length - 2)].doubleValue;
    }];
    return scale;
}

@end
