//
//  SXSetting.h
//  SXEditDemo
//
//  Created by Yin Xie on 2018/12/8.
//  Copyright © 2018 Yin Xie. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SXSetting : NSObject

@property (nonatomic, strong) UIColor* mainColor;

+ (instancetype)shared;

@end

NS_ASSUME_NONNULL_END
