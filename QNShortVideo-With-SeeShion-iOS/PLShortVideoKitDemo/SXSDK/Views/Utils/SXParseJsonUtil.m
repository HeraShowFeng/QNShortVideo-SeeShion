//
//  SXParseJsonUtil.m
//  SXEditDemo
//
//  Created by Yin Xie on 2018/11/14.
//  Copyright © 2018 Yin Xie. All rights reserved.
//

#import "SXParseJsonUtil.h"

@implementation SXParseJsonUtil
+ (CGSize)initSizeWithArray:(NSArray *)array {
    if (array.count == 2) {
        return CGSizeMake([array[0] floatValue], [array[1] floatValue]);
    }
    return CGSizeZero;
}

+ (CGPoint)initPointWithArray:(NSArray *)array {
    if (array.count == 2) {
        return CGPointMake([array[0] floatValue], [array[1] floatValue]);
    }
    return CGPointZero;
}

+ (CGRect)initRectWithArray:(NSArray *)array {
    if (array.count == 4) {
        return CGRectMake([array[0] floatValue], [array[1] floatValue], [array[2] floatValue], [array[3] floatValue]);
    }
    return CGRectZero;
}
@end
