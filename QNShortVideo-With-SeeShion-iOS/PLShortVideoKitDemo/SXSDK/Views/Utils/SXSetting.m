//
//  SXSetting.m
//  SXEditDemo
//
//  Created by Yin Xie on 2018/12/8.
//  Copyright © 2018 Yin Xie. All rights reserved.
//

#import "SXSetting.h"

static SXSetting *shareInstance;
static NSString *kMainColorString = @"ffe131";

@implementation SXSetting

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[SXSetting alloc] init];
        shareInstance.mainColor = [UIColor colorWithHexString:kMainColorString];
    });
    return shareInstance;
}

@end
