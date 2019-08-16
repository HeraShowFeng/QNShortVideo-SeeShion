//
//  SXUICalculateUtil.m
//  SXEditDemo
//
//  Created by Yin Xie on 2018/12/11.
//  Copyright © 2018 Yin Xie. All rights reserved.
//

#import "SXUICalculateUtil.h"

@implementation SXUICalculateUtil

#pragma mark 占满minSize的最小缩放比
+ (CGFloat)getScale:(CGSize)originSize minSize:(CGSize)minSize {
    float widthScale = originSize.width / minSize.width;
    float heightScale = originSize.height / minSize.height;
    float minScale = MIN(widthScale, heightScale);
    return minScale;
}
+ (CGSize)getImageSizeWithImageView:(UIImageView*)ImageView {
    CGFloat scale = UIScreen.mainScreen.scale;
    CGSize imageSize = ImageView.bounds.size;
    return CGSizeMake(imageSize.width*scale, imageSize.height*scale);
}

@end
