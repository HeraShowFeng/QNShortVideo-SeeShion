//
//  SXCommonUtil.m
//  SXEditDemo
//
//  Created by Yin Xie on 2018/11/13.
//  Copyright © 2018 Yin Xie. All rights reserved.
//

#import "SXCommonUtil.h"

@implementation SXCommonUtil

#pragma mark -- 生成时间戳
+(NSString *)getTimeMarkString{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
    NSString *str = [formatter stringFromDate:[NSDate date]];
    return str;
}

#pragma mark -- 生成随机数
+(NSString *)getRandomNumber:(NSString *)from to:(NSString *)to
{
    NSInteger fromNum = [from integerValue];
    NSInteger toNum = [to integerValue];
    return  [NSString stringWithFormat:@"%ld",(fromNum + (arc4random() % (toNum - fromNum  + 1)))]  ;
}

#pragma mark 判断字符串是否为空
+ (BOOL) isBlank:(NSString *)string {
    if (string == nil || string == NULL || [string  isKindOfClass:[NSNull class]]) {
        return YES;
    }
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (string.length == 0) {
        return YES;
    }
    return NO;
}
@end
