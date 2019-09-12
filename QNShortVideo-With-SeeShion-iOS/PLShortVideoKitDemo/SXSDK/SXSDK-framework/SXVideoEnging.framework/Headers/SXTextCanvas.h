//
//  SXTextCanvas.h
//  SXVideoEnging
//
//  Created by Yin Xie on 2019/1/7.
//  Copyright © 2019 Zhiqiang Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

/**
 * 文字对齐方式
 */
typedef enum : NSUInteger {
    SXTextCanvasAlignmentLeft,      // 左对齐
    SXTextCanvasAlignmentRight,     // 右对齐
    SXTextCanvasAlignmentCenter,    // 居中对齐
} SXTextCanvasAlignment;

/**
 * 文字换行方式
 */
typedef enum : NSUInteger {
    SXLineBreakByWordWrapping,
    SXLineBreakByCharWrapping,
    SXLineBreakByClipping,
    SXLineBreakByTruncatingHead,
    SXLineBreakByTruncatingTail,
    SXLineBreakByTruncatingMiddle
} SXLineBreak;

/**
 * 文字画板，通过读取VE模板文字素材配置信息绘制生成文字图片文件
 */
@interface SXTextCanvas : NSObject

/**
 * 读取和设置文字输入框范围
 */
@property (nonatomic, assign) CGRect area;

/**
 * 读取和设置画布大小
 */
@property (nonatomic, assign) CGSize canvasSize;

/**
 * 读取和设置字体大小
 */
@property (nonatomic, assign) int fontSize;

/**
 * 当前字体样式
 */
@property (nonatomic, copy)   NSString *font;

/**
 * 读取和设置文字填充颜色
 */
@property (nonatomic, strong) UIColor *fillColor;

/**
 * 读取和设置文字描边颜色
 */
@property (nonatomic, strong) UIColor *strokeColor;

/**
 * 读取和设置文字描边大小
 */
@property (nonatomic, assign) int strokeWidth;

/**
 * 读取和设置要绘制的文字内容
 */
@property (nonatomic, copy)   NSString *content;

/**
 * 读取和设置文字对齐方式
 */
@property (nonatomic, assign) SXTextCanvasAlignment alignment;

/**
 * 读取和设置文字换行方式
 */
@property (nonatomic, assign) SXLineBreak lineBreak;

/**
 *	创建一个文字画板对象
 * @param dictionary 文字样式配置数据，格式为config.json文字素材的配置格式
 * @return 实例
 */
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

/**
 * 根据用户设置的文字内容，字体样式和输入框范围调节字号大小来使文字完整显示出来
 */
- (void)adjustSize;

/**
 * 保存结果到文件
 * @param path png文件路径
 */
- (void)saveToPath:(NSString *)path;
@end

NS_ASSUME_NONNULL_END
