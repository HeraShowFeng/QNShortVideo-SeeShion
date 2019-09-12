//
//  SXLicense.h
//  SXVideoEnging
//
//  Created by Yin Xie on 2019/3/12.
//  Copyright © 2019 Zhiqiang Li. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    SXCustomTemplate = 0,                   // 由用户手动调用接口创建的模板
    SXFeatureTypeNormalTemplate = 1,        // 从ve文件载入的普通模板，只支持固定数量的素材
    SXFeatureTypeDynamicTemplate = 1 << 1   // 从ve文件载入的动态模板，支持随机数量的素材
} SXFeatureType;

@interface SXLicense : NSObject

/**
 设置日志输出等级,低于该级别的日志将不会在控制台输出

 @param level 1    //跟踪信息 - release 版不建议输出
              2    //调试 - 调试信息, release 版不建议输出
              3    //普通输出 - 必要的普通信息,比如打印一些日志体现一些步骤
              4    //警告 - 不会造成渲染出错,比如可选数据,传错了
              5    //错误 - 会造成渲染出错,比如传入的数据有问题,渲染已经无法执行,或者即使执行,效果也是错误的
              6    //严重错误 - 遇到不可处理的错误,比如内存无法访问,无法申请的时候
 */
+ (void)setLogLevel:(int)level;

/**
 * 注册license
 * @warning 该方法应该只被调用一次
 * @param license license字符串
 */
+(void)setLicense:(NSString *)license;

/**
 检查证书是否可用
 @return 返回是否可用
 */
+ (BOOL)isLicenseValid;

/**
 获取icense平台

 @return 平台类型 0:Server, 1:IOS, 2:Android, 3：Exporter
 */
+ (int)getPlatform;

/**
 获取平台字符串描述

 @return 平台类型字符串
 */
+ (NSString *)getPlatformString;

/**
 获取bundle name

 @return bundle name
 */
+ (NSString *)getBundleName;

/**
 获取license版本

 @return 版本号
 */
+ (NSString *)getVersion;

/**
 获取license类型

 @return 0:正式版, 1:测试版
 */
+ (int)getLicenseType;

/**
 获取测试license过期时间

 @return 测试版本过期时间
 */
+ (NSString *)getTestExpire;

/**
 　检查产品是否可用
 
 @param type 产品类型
 @return 没有对应的产品信息返回false， 否则返回true
 */
+ (BOOL)checkFeature:(SXFeatureType)type;

@end

NS_ASSUME_NONNULL_END
