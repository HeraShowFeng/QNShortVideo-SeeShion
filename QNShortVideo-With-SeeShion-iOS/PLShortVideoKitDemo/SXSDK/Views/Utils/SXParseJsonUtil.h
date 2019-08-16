//
//  SXParseJsonUtil.h
//  SXEditDemo
//
//  Created by Yin Xie on 2018/11/14.
//  Copyright © 2018 Yin Xie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface SXParseJsonUtil : NSObject
+ (CGSize)initSizeWithArray: (NSArray *)array;
+ (CGPoint)initPointWithArray: (NSArray *)array;
+ (CGRect)initRectWithArray: (NSArray *)array;
@end

NS_ASSUME_NONNULL_END
