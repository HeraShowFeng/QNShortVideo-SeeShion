//
//  SXUICalculateUtil.h
//  SXEditDemo
//
//  Created by Yin Xie on 2018/12/11.
//  Copyright © 2018 Yin Xie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface SXUICalculateUtil : NSObject

#pragma mark 占满minSize的最小缩放比
+ (CGFloat)getScale:(CGSize)originSize minSize:(CGSize)minSize;
+ (CGSize)getImageSizeWithImageView:(UIImageView*)ImageView;
@end

NS_ASSUME_NONNULL_END
