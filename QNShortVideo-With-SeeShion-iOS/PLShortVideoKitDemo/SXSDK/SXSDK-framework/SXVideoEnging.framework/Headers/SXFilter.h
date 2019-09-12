//
//  SXFilter.h
//  SXVideoEnging
//
//  Created by Yin Xie on 2019/4/17.
//  Copyright © 2019 Zhiqiang Li. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    SXFilterTransitDirectionRightToLeft = 0,
    SXFilterTransitDirectionLeftToRight,
    SXFilterTransitDirectionBottomToTop,
    SXFilterTransitDirectionTopToBottom,
} SXFilterTransitDirection;

@interface SXFilter : NSObject
//滤镜名称
@property (nonatomic, copy, readonly) NSString *name;
//滤镜版本号
@property (nonatomic, strong, readonly) NSString *version;

/**
 * 初始化一个滤镜实例
 * @param filePath 滤镜文件夹路径
 * @return 滤镜实例
 */
- (instancetype)initWithFilePath:(NSString *)filePath;

/**
 检测滤镜的 version 是否被当前引擎全部支持
 
 @return  1 表示滤镜版本高于引擎版本，不是完整支持， 返回 0， -1 表示可以完整支持
 */
- (int)compareWithCurrentVersion;
@end

NS_ASSUME_NONNULL_END
