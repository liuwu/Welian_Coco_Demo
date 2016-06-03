//
//  NSData+WLAdd.h
//  Welian
//
//  Created by weLian on 16/5/11.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 NS_ASSUME_NONNULL_BEGIN  NS_ASSUME_NONNULL_END
 在这两个宏之间的代码，所有简单指针对象都被假定为nonnull，因此我们只需要去指定那些nullable的指针。
 */
NS_ASSUME_NONNULL_BEGIN

/**
 *  @author liuwu     , 16-05-11
 *
 *  NSData常见任务
 *  @since V2.7.9
 */
@interface NSData (WLAdd)

#pragma mark - Encrypt and Decrypt
///=============================================================================
/// @name 加密 and 解密
///=============================================================================

/**
*  @author liuwu     , 16-05-11
*
*  使用AES256解密数据
*  @return 解密后的数据字符串
*  @since V2.7.9
*/
- (NSString *)wl_decryptAES256Value;

/**
*  @author liuwu     , 16-05-11
*
*  利用AES加密数据
*  @param key 加密的key.
*  @return 一个加密后的NSData,或nil如果出现错误。
*  @since V2.7.9
*/
- (nullable NSData *)wl_encryptAESWithkey:(NSString *)key;


/**
 *  @author liuwu     , 16-05-11
 *
 *  使用AES256解密数据
 *  @param key 解密的key.
 *  @return 一个解密后的NSData,或nil如果出现错误。
 *  @since V2.7.9
 */
- (nullable NSData *)wl_decryptAES256Withkey:(NSString *)key;


#pragma mark - Encode and decode
///=============================================================================
/// @name 编码 and 解码
///=============================================================================

/**
 *  @author liuwu     , 16-05-11
 *
 *  base64数据解码为字符串
 *  @return 解码后的字符串
 *  @since V2.7.9
 */
- (nullable NSString *)wl_base64DcodedString;

/**
 返回UTF8解码的字符串
 */
- (nullable NSString *)wl_utf8String;

/**
 返回一个hex编码的字符串
 */
- (nullable NSString *)wl_hexString;

/**
 返回一个使用hex字符串编码的NSData
 
 @param hexString   不区分大小写的hex字符串.
 
 @return 一个新的NSData,或nil如果出现错误。
 */
+ (nullable NSData *)wl_dataWithHexString:(NSString *)hexString;

/**
 返回一个base64编码的字符串
 */
- (nullable NSString *)wl_base64EncodedString;

/**
 字符串base64转data
 
 @警告 这个方法已经在iOS7中实现.
 
 @param base64EncodedString  编码的字符串.
 */
+ (nullable NSData *)wl_dataWithBase64EncodedString:(NSString *)base64EncodedString;

/**
 *  @author liuwu     , 16-05-11
 *
 *  系统自带的字符串base64后转data
 *  @param string 编码的字符串
 *  @return 传入字符串base64后的data
 *  @since V2.7.9
 */
+ (nullable NSData *)wl_systemdataWithBase64EncodedString:(NSString *)string;

/**
 返回一个解码的NSDictionary或NSArray. 如果发送错误，返回nil.
 */
- (nullable id)wl_jsonValueDecoded;


@end

NS_ASSUME_NONNULL_END

