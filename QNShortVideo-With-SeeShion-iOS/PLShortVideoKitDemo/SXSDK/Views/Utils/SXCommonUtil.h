//
//  SXCommonUtil.h
//  SXEditDemo
//
//  Created by Yin Xie on 2018/11/13.
//  Copyright © 2018 Yin Xie. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SXCommonUtil : NSObject

#pragma mark -- 生成时间戳
+(NSString *)getTimeMarkString;

#pragma mark -- 生成随机数
+(NSString *)getRandomNumber:(NSString *)from to:(NSString *)to;

#pragma mark 判断字符串是否为空
+ (BOOL) isBlank:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
