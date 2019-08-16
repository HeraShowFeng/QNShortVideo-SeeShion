//
//  PhotoTool.h
//  ShiPinDemo
//
//  Created by 杨思宇 on 2017/11/2.
//  Copyright © 2017年 杨思宇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
@class PhotoTool;
@interface PhotoTool : NSObject

/**
 根据网络url获取UIImage
 */
+(UIImage *_Nullable) getImageFromURL:(NSString *_Nullable)fileURL;

/**
 压缩图片
 */
+(UIImage*_Nullable)modifyImage:(UIImage *_Nullable)image scaleToSize:(CGSize)size;

+(UIImage *) convertImageToDeviceColorSpace:(UIImage *) source;
@end
