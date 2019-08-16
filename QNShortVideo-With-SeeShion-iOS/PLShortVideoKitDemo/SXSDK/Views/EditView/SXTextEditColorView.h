//
//  SXTextEditColorView.h
//  SXEditDemo
//
//  Created by 李记波 on 2018/12/13.
//  Copyright © 2018年 Yin Xie. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SXTextEditColorView : UIView

//返回yes说明是字体颜色；No说明是边框y颜色。
@property (nonatomic, copy) void(^selectColorBlock)(BOOL,NSDictionary*);

@property (nonatomic, copy) void(^selectBorderWidthBlock)(CGFloat);

- (void)updateColllectionView:(NSArray*)textArr WithBorderColors:(NSArray*)borderArr;

@end

NS_ASSUME_NONNULL_END
