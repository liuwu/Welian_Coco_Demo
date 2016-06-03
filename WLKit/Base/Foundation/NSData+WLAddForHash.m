//
//  NSData+WLAddForHash.m
//  Welian
//
//  Created by weLian on 16/5/9.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import "NSData+WLAddForHash.h"
#include <CommonCrypto/CommonCrypto.h>
#include <zlib.h>

@implementation NSData (WLAddForHash)

/**
 返回一个MD2加密的小写NSString字符串
 */
- (NSString *)wl_md2String {
    unsigned char result[CC_MD2_DIGEST_LENGTH];
    CC_MD2(self.bytes, (CC_LONG)self.length, result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

/**
 返回一个MD2加密的NSData数据
 */
- (NSData *)wl_md2Data {
    unsigned char result[CC_MD2_DIGEST_LENGTH];
    CC_MD2(self.bytes, (CC_LONG)self.length, result);
    return [NSData dataWithBytes:result length:CC_MD2_DIGEST_LENGTH];
}

/**
 返回一个MD4加密的小写NSString字符串
 */
- (NSString *)wl_md4String {
    unsigned char result[CC_MD4_DIGEST_LENGTH];
    CC_MD4(self.bytes, (CC_LONG)self.length, result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

/**
 返回一个MD4加密的NSData数据
 */
- (NSData *)wl_md4Data {
    unsigned char result[CC_MD4_DIGEST_LENGTH];
    CC_MD4(self.bytes, (CC_LONG)self.length, result);
    return [NSData dataWithBytes:result length:CC_MD4_DIGEST_LENGTH];
}

/**
 返回一个MD5加密的小写NSString字符串
 */
- (NSString *)wl_md5String {
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(self.bytes, (CC_LONG)self.length, result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

/**
 返回一个MD5加密的NSData数据
 */
- (NSData *)wl_md5Data {
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(self.bytes, (CC_LONG)self.length, result);
    return [NSData dataWithBytes:result length:CC_MD5_DIGEST_LENGTH];
}

/*
 返回一个SHA1加密的小写NSString字符串
 */
- (NSString *)wl_sha1String {
    unsigned char result[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(self.bytes, (CC_LONG)self.length, result);
    NSMutableString *hash = [NSMutableString
                             stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02x", result[i]];
    }
    return hash;
}

/**
 返回一个SHA1加密的NSData数据
 */
- (NSData *)wl_sha1Data {
    unsigned char result[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(self.bytes, (CC_LONG)self.length, result);
    return [NSData dataWithBytes:result length:CC_SHA1_DIGEST_LENGTH];
}

/**
 返回一个SHA224加密的小写NSString字符串
 */
- (NSString *)wl_sha224String {
    unsigned char result[CC_SHA224_DIGEST_LENGTH];
    CC_SHA224(self.bytes, (CC_LONG)self.length, result);
    NSMutableString *hash = [NSMutableString
                             stringWithCapacity:CC_SHA224_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA224_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02x", result[i]];
    }
    return hash;
}

/*
 返回一个SHA224加密的NSData数据
 */
- (NSData *)wl_sha224Data {
    unsigned char result[CC_SHA224_DIGEST_LENGTH];
    CC_SHA224(self.bytes, (CC_LONG)self.length, result);
    return [NSData dataWithBytes:result length:CC_SHA224_DIGEST_LENGTH];
}

/**
 返回一个SHA256加密的小写NSString字符串
 */
- (NSString *)wl_sha256String {
    unsigned char result[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(self.bytes, (CC_LONG)self.length, result);
    NSMutableString *hash = [NSMutableString
                             stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02x", result[i]];
    }
    return hash;
}

/**
 返回一个SHA256加密的NSData数据
 */
- (NSData *)wl_sha256Data {
    unsigned char result[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(self.bytes, (CC_LONG)self.length, result);
    return [NSData dataWithBytes:result length:CC_SHA256_DIGEST_LENGTH];
}

/*
 返回一个SHA384加密的小写NSString字符串
 */
- (NSString *)wl_sha384String {
    unsigned char result[CC_SHA384_DIGEST_LENGTH];
    CC_SHA384(self.bytes, (CC_LONG)self.length, result);
    NSMutableString *hash = [NSMutableString
                             stringWithCapacity:CC_SHA384_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA384_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02x", result[i]];
    }
    return hash;
}

/**
 返回一个SHA384加密的NSData数据
 */
- (NSData *)wl_sha384Data {
    unsigned char result[CC_SHA384_DIGEST_LENGTH];
    CC_SHA384(self.bytes, (CC_LONG)self.length, result);
    return [NSData dataWithBytes:result length:CC_SHA384_DIGEST_LENGTH];
}

/**
 返回一个SHA512加密的小写NSString字符串
 */
- (NSString *)wl_sha512String {
    unsigned char result[CC_SHA512_DIGEST_LENGTH];
    CC_SHA512(self.bytes, (CC_LONG)self.length, result);
    NSMutableString *hash = [NSMutableString
                             stringWithCapacity:CC_SHA512_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA512_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02x", result[i]];
    }
    return hash;
}

/**
 返回一个SHA512加密的NSData数据
 */
- (NSData *)wl_sha512Data {
    unsigned char result[CC_SHA512_DIGEST_LENGTH];
    CC_SHA512(self.bytes, (CC_LONG)self.length, result);
    return [NSData dataWithBytes:result length:CC_SHA512_DIGEST_LENGTH];
}

- (NSString *)wl_hmacStringUsingAlg:(CCHmacAlgorithm)alg withKey:(NSString *)key {
    size_t size;
    switch (alg) {
        case kCCHmacAlgMD5: size = CC_MD5_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA1: size = CC_SHA1_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA224: size = CC_SHA224_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA256: size = CC_SHA256_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA384: size = CC_SHA384_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA512: size = CC_SHA512_DIGEST_LENGTH; break;
        default: return nil;
    }
    unsigned char result[size];
    const char *cKey = [key cStringUsingEncoding:NSUTF8StringEncoding];
    CCHmac(alg, cKey, strlen(cKey), self.bytes, self.length, result);
    NSMutableString *hash = [NSMutableString stringWithCapacity:size * 2];
    for (int i = 0; i < size; i++) {
        [hash appendFormat:@"%02x", result[i]];
    }
    return hash;
}

- (NSData *)wl_hmacDataUsingAlg:(CCHmacAlgorithm)alg withKey:(NSData *)key {
    size_t size;
    switch (alg) {
        case kCCHmacAlgMD5: size = CC_MD5_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA1: size = CC_SHA1_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA224: size = CC_SHA224_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA256: size = CC_SHA256_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA384: size = CC_SHA384_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA512: size = CC_SHA512_DIGEST_LENGTH; break;
        default: return nil;
    }
    unsigned char result[size];
    CCHmac(alg, [key bytes], key.length, self.bytes, self.length, result);
    return [NSData dataWithBytes:result length:size];
}

/**
 返回一个hmac的小写NSString字符串，使用md5加密的key的计算方式
 @param key  hmac的密钥
 */
- (NSString *)wl_hmacMD5StringWithKey:(NSString *)key {
    return [self wl_hmacStringUsingAlg:kCCHmacAlgMD5 withKey:key];
}

/**
 返回一个hmac的NSData数据，使用md5加密的key的计算方式
 @param key  hmac的密钥
 */
- (NSData *)wl_hmacMD5DataWithKey:(NSData *)key {
    return [self wl_hmacDataUsingAlg:kCCHmacAlgMD5 withKey:key];
}

/**
 Returns a lowercase NSString for hmac using algorithm sha1 with key.
 返回一个hmac的小写NSString字符串，使用SHA1加密的key的计算方式
 @param key  hmac的密钥
 */
- (NSString *)wl_hmacSHA1StringWithKey:(NSString *)key {
    return [self wl_hmacStringUsingAlg:kCCHmacAlgSHA1 withKey:key];
}

/**
 Returns an NSData for hmac using algorithm sha1 with key.
 返回一个hmac的NSData数据，使用SHA1加密的key的计算方式
 @param key  hmac的密钥
 */
- (NSData *)wl_hmacSHA1DataWithKey:(NSData *)key {
    return [self wl_hmacDataUsingAlg:kCCHmacAlgSHA1 withKey:key];
}

/**
 Returns a lowercase NSString for hmac using algorithm sha224 with key.
 返回一个hmac的小写NSString字符串，使用SHA224加密的key的计算方式
 @param key  hmac的密钥
 */
- (NSString *)wl_hmacSHA224StringWithKey:(NSString *)key {
    return [self wl_hmacStringUsingAlg:kCCHmacAlgSHA224 withKey:key];
}

/**
 Returns an NSData for hmac using algorithm sha224 with key.
 返回一个hmac的NSData数据，使用SHA224加密的key的计算方式
 @param key  hmac的密钥
 */
- (NSData *)wl_hmacSHA224DataWithKey:(NSData *)key {
    return [self wl_hmacDataUsingAlg:kCCHmacAlgSHA224 withKey:key];
}

/**
 Returns a lowercase NSString for hmac using algorithm sha256 with key.
 返回一个hmac的小写NSString字符串，使用SHA256加密的key的计算方式
 @param key  hmac的密钥
 */
- (NSString *)wl_hmacSHA256StringWithKey:(NSString *)key {
    return [self wl_hmacStringUsingAlg:kCCHmacAlgSHA256 withKey:key];
}

/**
 Returns an NSData for hmac using algorithm sha256 with key.
 返回一个hmac的NSData数据，使用SHA256加密的key的计算方式
 @param key  hmac的密钥
 */
- (NSData *)wl_hmacSHA256DataWithKey:(NSData *)key {
    return [self wl_hmacDataUsingAlg:kCCHmacAlgSHA256 withKey:key];
}

/**
 Returns a lowercase NSString for hmac using algorithm sha384 with key.
 返回一个hmac的小写NSString字符串，使用SHA384加密的key的计算方式
 @param key  hmac的密钥
 */
- (NSString *)wl_hmacSHA384StringWithKey:(NSString *)key {
    return [self wl_hmacStringUsingAlg:kCCHmacAlgSHA384 withKey:key];
}

/**
 Returns an NSData for hmac using algorithm sha384 with key.
 返回一个hmac的NSData数据，使用SHA384加密的key的计算方式
 @param key  hmac的密钥
 */
- (NSData *)wl_hmacSHA384DataWithKey:(NSData *)key {
    return [self wl_hmacDataUsingAlg:kCCHmacAlgSHA384 withKey:key];
}

/**
 Returns a lowercase NSString for hmac using algorithm sha512 with key.
 返回一个hmac的小写NSString字符串，使用SHA512加密的key的计算方式
 @param key  hmac的密钥
 */
- (NSString *)wl_hmacSHA512StringWithKey:(NSString *)key {
    return [self wl_hmacStringUsingAlg:kCCHmacAlgSHA512 withKey:key];
}

/**
 Returns an NSData for hmac using algorithm sha512 with key.
 返回一个hmac的NSData数据，使用SHA512加密的key的计算方式
 @param key  hmac的密钥
 */
- (NSData *)wl_hmacSHA512DataWithKey:(NSData *)key {
    return [self wl_hmacDataUsingAlg:kCCHmacAlgSHA512 withKey:key];
}

/**
 返回一个src32加密的小写NSString字符串
 */
- (NSString *)wl_crc32String {
    uLong result = crc32(0, self.bytes, (uInt)self.length);
    return [NSString stringWithFormat:@"%08x", (uint32_t)result];
}

/**
 返回src32加密的数据
 */
- (uint32_t)wl_crc32 {
    uLong result = crc32(0, self.bytes, (uInt)self.length);
    return (uint32_t)result;
}

@end
