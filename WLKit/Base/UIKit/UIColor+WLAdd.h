//
//  UIColor+WLAdd.h
//  Welian
//
//  Created by weLian on 16/5/13.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 NS_ASSUME_NONNULL_BEGIN  NS_ASSUME_NONNULL_END
 在这两个宏之间的代码，所有简单指针对象都被假定为nonnull，因此我们只需要去指定那些nullable的指针。
 */
NS_ASSUME_NONNULL_BEGIN


extern void WL_RGB2HSL(CGFloat r, CGFloat g, CGFloat b,
                       CGFloat *h, CGFloat *s, CGFloat *l);

extern void WL_HSL2RGB(CGFloat h, CGFloat s, CGFloat l,
                       CGFloat *r, CGFloat *g, CGFloat *b);

extern void WL_RGB2HSB(CGFloat r, CGFloat g, CGFloat b,
                       CGFloat *h, CGFloat *s, CGFloat *v);

extern void WL_HSB2RGB(CGFloat h, CGFloat s, CGFloat v,
                       CGFloat *r, CGFloat *g, CGFloat *b);

extern void WL_RGB2CMYK(CGFloat r, CGFloat g, CGFloat b,
                        CGFloat *c, CGFloat *m, CGFloat *y, CGFloat *k);

extern void WL_CMYK2RGB(CGFloat c, CGFloat m, CGFloat y, CGFloat k,
                        CGFloat *r, CGFloat *g, CGFloat *b);

extern void WL_HSB2HSL(CGFloat h, CGFloat s, CGFloat b,
                       CGFloat *hh, CGFloat *ss, CGFloat *ll);

extern void WL_HSL2HSB(CGFloat h, CGFloat s, CGFloat l,
                       CGFloat *hh, CGFloat *ss, CGFloat *bb);


/*
 创建一个十六进制的字符串UIColor
 例子: UIColorHex(0xF0F), UIColorHex(66ccff), UIColorHex(#66CCFF88)
 
 有效格式: #RGB #RGBA #RRGGBB #RRGGBBAA 0xRGB ...
 '#'或'0x'标志是不需要的
 */
#ifndef UIColorHex
#define UIColorHex(_hex_)   [UIColor wl_colorWithHexString:((__bridge NSString *)CFSTR(#_hex_))]
#endif

/**
 *  系统颜色
 *
 *  @param r
 *  @param g
 *  @param b
 *
 *  @return
 */
#define WLRGBA(r, g, b, a)      [UIColor wl_colorWithWholeRed:r green:g blue:b alpha:a]
#define WLRGB(r, g, b)          [UIColor wl_colorWithWholeRed:r green:g blue:b]
#define WLColoerRGB(rgb)        WLRGB(rgb, rgb, rgb)

//从rgb值中返回UIColor
#define WLColorFromRGB(rgbValue) [UIColor wl_colorWithRGB:rgbValue]

// 3.全局背景色
#define kWLNormalBgColor_239        WLRGB(239, 239, 239)
#define kWLNormalNavBgColor_249     WLRGB(249.f, 249.f, 249.f)

//常用系统颜色
#define kWLNormalTextColor_173      WLRGB(173.f, 173.f, 173.f)
#define kWLNormalTextColor_51       WLRGB(51.f, 51.f, 51.f)
#define kWLNormalTextColor_85       WLRGB(85.f, 85.f, 85.f)
#define kWLNormalTextColor_125      WLRGB(125.f, 125.f, 125.f)
#define kWLNormalTextColor_153      WLRGB(153.f, 153.f, 153.f)
#define kWLNormalTextColor_155      WLRGB(155.f, 155.f, 155.f)
#define kWLNormalTextColor_197      WLRGB(197.f, 197.f, 197.f)
#define kWLNormalTextColor_231      WLRGB(231.f, 231.f, 231.f)
#define kWLNormalTextColor_239      WLRGB(239.f, 239.f, 239.f)
#define kWLNormalTextColor_247      WLRGB(247.f, 247.f, 247.f)
#define kWLNormalTextColor_242      WLRGB(242.f, 242.f, 242.f)

#define kWLNormalCommentColor       WLRGB(117.f, 191.f, 222.f)
#define kWLNormalBlueTextColor      WLRGB(4.f, 166.f, 233.f) //系统默认底色蓝色
#define kWLNormalBlueNewTextColor   WLRGB(0.f, 164.f, 232.f)
#define kWLNormalYellowTextColor    WLRGB(251.f,178.f,23.f)
#define kWLNormalYellowBgColor      WLRGB(255.f, 249.f, 235.f)
#define kWLNormalGrayTextColor      WLRGB(135.f, 135.f, 136.f)
#define kWLNormalRedTextColor       WLRGB(233.f, 83.f, 70.f)

#define kWLNormalBtnJieShouColor    WLRGB(79.f, 191.f, 232.f)

// 线条浅灰颜色
#define kWLNormalLineColor          WLRGB(232.f, 234.f, 239.f)
#define kWLNormalColor_229          WLRGB(229.f, 229.f, 229.f)
#define kWLNormalGrayColor_204      WLRGB(204.f, 204.f, 204.f)

//背景灰色
#define kWLNormalLightGrayColor     WLRGB(236.f, 238.f, 241.f)
#define kWLNormalBgGrayColor        WLRGB(212.f, 214.f, 216.f)
#define kWLNormalBgGrayTextColor    WLRGB(163.f, 163.f, 169.f)

//事务中心中时间颜色
#define kWLNormalTimeColor          WLRGB(242.f, 192.f, 108.f)


/**
 UIColor提供的一些在RGB,HSB,HSL,CMYK和Hex颜色之间的转换方法
 
 | 颜色区域 | 表示意义                                     |
 |-------------|----------------------------------------|
 | RGB *       | 红, 绿, 蓝                              |
 | HSB(HSV) *  | 色相, 饱和度, 亮度 (值)                   |
 | HSL         | 色相, 饱和度, 亮度                        |
 | CMYK        | 青色, 洋红, 黄色, 黑色                    |
 
 苹果使用默认的RGB和HSB.
 这一类所有的值的取值范围在0.0到1.0。 值低于0.0被解析为0，值大于1被解析为1。
 如果你想要更多的色彩空间之间的转换颜色(CIEXYZ,Lab,YUV...),
 查看 https://github.com/ibireme/yy_color_convertor
 */
@interface UIColor (WLAdd)


#pragma mark - Normal
///=============================================================================
/// @name 常用的UIColor操作
///=============================================================================

/**
*  @author liuwu     , 16-05-19
*
*  获取随机颜色
*  @return 颜色
*  @since V2.7.9
*/
+ (UIColor *)wl_randomColor;


#pragma mark - Create a UIColor Object
///=============================================================================
/// @name 创建一个UIColor对象
///=============================================================================

///根据给定的rgba值，返回颜色对象
+ (UIColor *)wl_colorWithWholeRed:(CGFloat)red
                            green:(CGFloat)green
                             blue:(CGFloat)blue
                            alpha:(CGFloat)alpha;

///根据给定的rgb值，返回颜色对象
+ (UIColor *)wl_colorWithWholeRed:(CGFloat)red
                            green:(CGFloat)green
                             blue:(CGFloat)blue;

/**
 使用指定的透明度和HSL颜色空间的色值创建并返回一个颜色对象
 
 @param hue        在HSL中的色调值，取值范围：0.0到1.0.
 @param saturation 在HSL中的饱和度值,取值范围：0.0到1.0.
 @param lightness  在HSL中的亮度值，,取值范围：0.0到1.0.
 @param alpha      颜色对象的透明度值,取值范围：0.0到1.0.
 
 @return           颜色对象. 颜色对象代表的是设备的RGB色值.
 */
+ (UIColor *)wl_colorWithHue:(CGFloat)hue
                  saturation:(CGFloat)saturation
                   lightness:(CGFloat)lightness
                       alpha:(CGFloat)alpha;

/**
 使用指定的透明度和CMYK颜色空间的色值创建并返回一个颜色对象。
 
 @param cyan    在CMYK中的青色色值，取值范围：0.0到1.0.
 @param magenta 在CMYK中的洋红色值,取值范围：0.0到1.0.
 @param yellow  在CMYK中的黄色色值,取值范围：0.0到1.0.
 @param black   在CMYK中的黑色色值,取值范围：0.0到1.0.
 @param alpha   颜色对象的透明度值,取值范围：0.0到1.0.
 
 @return        颜色对象. 颜色对象代表的是设备的RGB色值.
 */
+ (UIColor *)wl_colorWithCyan:(CGFloat)cyan
                      magenta:(CGFloat)magenta
                       yellow:(CGFloat)yellow
                        black:(CGFloat)black
                        alpha:(CGFloat)alpha;

/**
 使用十六进制RGB色值创建并返回一个颜色对象。
 
 @param rgbValue  RGB值，如： 0x66ccff.
 @return          颜色对象. 颜色对象代表的是设备的RGB色值.
 */
+ (UIColor *)wl_colorWithRGB:(uint32_t)rgbValue;

/**
 使用十六进制的RGBA色值创建并返回一个颜色对象
 
 @param rgbaValue  rgba值，如： 0x66ccffff.
 @return           颜色对象. 颜色对象代表的是设备的RGB色值.
 */
+ (UIColor *)wl_colorWithRGBA:(uint32_t)rgbaValue;

/**
 使用指定的透明度和RGB十六进制值创建并返回一个颜色对象。
 
 @param rgbValue  rgb值，如： 0x66CCFF.
 @param alpha     颜色对象的透明度值,取值范围：0.0到1.0.
 
 @return          颜色对象. 颜色对象代表的是设备的RGB色值.
 */
+ (UIColor *)wl_colorWithRGB:(uint32_t)rgbValue alpha:(CGFloat)alpha;

/**
 使用指定十六进制字符串中创建并返回的颜色对象。
 
 @讨论:
 有效格式: #RGB #RGBA #RRGGBB #RRGGBBAA 0xRGB ...
 '#'和'0x'标志是不需要的。
 如果透明度设置为1.0将没有透明度。如果解析中发送错误返回nil.
 
 例如: @"0xF0F", @"66ccff", @"#66CCFF88"
 
 @param hexStr  十六进制字符串值.
 
 @return        UIColor对象, 如果出错返回nil.
 */
+ (nullable UIColor *)wl_colorWithHexString:(NSString *)hexStr;

/**
 通过添加新的颜色创建并返回一个颜色对象
 
 @param add        添加的颜色
 @param blendMode  添加颜色的混合模式
 */
- (UIColor *)wl_colorByAddColor:(UIColor *)add blendMode:(CGBlendMode)blendMode;

/**
 通过改变组件创建并返回一个颜色对象。
 
 @param hueDelta         色调变化的范围：-1.0到1.0. 0表示不变。
 @param saturationDelta  饱和度变化范围：-1.0到1.0. 0表示不变.
 @param brightnessDelta  亮度的变化范围：-1.0到1.0. 0表示不变.
 @param alphaDelta       透明度变化范围：-1.0到1.0. 0表示不变.
 */
- (UIColor *)wl_colorByChangeHue:(CGFloat)hueDelta
                      saturation:(CGFloat)saturationDelta
                      brightness:(CGFloat)brightnessDelta
                           alpha:(CGFloat)alphaDelta;


#pragma mark - Get color's description
///=============================================================================
/// @name Get 颜色的描述
///=============================================================================

/**
 返回十六进制的RGB值
 @return 十六进制RGB值,如： 0x66ccff.
 */
- (uint32_t)wl_rgbValue;

/**
 返回十六进制的RGBA值.
 
 @return 十六进制RGBA值，如：0x66ccffff.
 */
- (uint32_t)wl_rgbaValue;

/**
 返回十六进制RGB值的字符串（小写），如：@"0066cc".
 如果色值不是RGB返回nil.
 @return 颜色的十六进制字符串.
 */
- (nullable NSString *)wl_hexString;

/**
 返回十六进制RGBA值字符串(小写).如：@"0066ccff".
 如果色值不是RGBA值返回nil.
 @return 颜色的十六进制字符串.
 */
- (nullable NSString *)wl_hexStringWithAlpha;


#pragma mark - Retrieving Color Information
///=============================================================================
/// @name 获取颜色信息
///=============================================================================

/**
 返回在HSL颜色控件中构成颜色的色值
 
 @param hue         On return, 颜色对象的色调,范围0.0到1.0.
 @param saturation  On return, 颜色对象的饱和度,范围0.0到1.0.
 @param lightness   On return, 颜色对象的亮度,范围0.0到1.0.
 @param alpha       On return, 颜色对象的透明度,范围0.0到1.0.
 @return            如果颜色可以转换返回YES，否则NO.
 */
- (BOOL)wl_getHue:(CGFloat *)hue
       saturation:(CGFloat *)saturation
        lightness:(CGFloat *)lightness
            alpha:(CGFloat *)alpha;

/**
 返回在CMYK颜色控件中构成颜色的值。
 
 @param cyan     On return, 颜色对象的青色色值,范围0.0到1.0.
 @param magenta  On return, 颜色对象的红色色值,范围0.0到1.0.
 @param yellow   On return, 颜色对象的黄色色值,范围0.0到1.0.
 @param black    On return, 颜色的黑色色值,范围0.0到1.0.
 @param alpha    On return, 颜色的透明度色值,范围0.0到1.0.
 @return         如果颜色可以转换返回YES，否则NO.
 */
- (BOOL)wl_getCyan:(CGFloat *)cyan
           magenta:(CGFloat *)magenta
            yellow:(CGFloat *)yellow
             black:(CGFloat *)black
             alpha:(CGFloat *)alpha;

/**
 在RGB颜色空间的红色色值。
 此属性的值范围是：0.0到1.0。
 */
@property (nonatomic, readonly) CGFloat wl_red;

/**
 在RGB颜色空间的绿色色值。
 此属性的值范围是：0.0到1.0。
 */
@property (nonatomic, readonly) CGFloat wl_green;

/**
 在RGB颜色空间的蓝色色值。
 此属性的值范围是：0.0到1.0。
 */
@property (nonatomic, readonly) CGFloat wl_blue;

/**
 在HSB颜色空间的色调值。
 此属性的值范围是：0.0到1.0。
 */
@property (nonatomic, readonly) CGFloat wl_hue;

/**
 在HSB颜色空间的饱和度值。
 此属性的值范围是：0.0到1.0。
 */
@property (nonatomic, readonly) CGFloat wl_saturation;

/**
 在HSB颜色空间的亮度值。
 此属性的值范围是：0.0到1.0。
 */
@property (nonatomic, readonly) CGFloat wl_brightness;

/**
 颜色的透明度值。
 此属性的值范围是：0.0到1.0。
 */
@property (nonatomic, readonly) CGFloat wl_alpha;

/**
 颜色的颜色空间模型
 */
@property (nonatomic, readonly) CGColorSpaceModel wl_colorSpaceModel;

/**
 颜色控件字符串
 */
@property (nullable, nonatomic, readonly) NSString *wl_colorSpaceString;



@end

NS_ASSUME_NONNULL_END
