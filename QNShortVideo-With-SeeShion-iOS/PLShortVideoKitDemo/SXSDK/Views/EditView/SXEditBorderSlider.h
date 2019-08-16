//
//  SXEditBorderSlider.h
//  SXEditDemo
//
//  Created by 李记波 on 2018/12/14.
//  Copyright © 2018年 Yin Xie. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SXEditBorderSlider : UISlider

@property (nonatomic, copy) void(^valueChanged)(SXEditBorderSlider *);
@property (nonatomic, strong) NSString *valueText;

@end

NS_ASSUME_NONNULL_END
