//
//  PhotoTool.m
//  ShiPinDemo
//
//  Created by 杨思宇 on 2017/11/2.
//  Copyright © 2017年 杨思宇. All rights reserved.
//

#import "PhotoTool.h"
@implementation PhotoTool

#pragma mark -- 根据网络url获取UIImage
+(UIImage *) getImageFromURL:(NSString *)fileURL
{
    
    UIImage * result;
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    return result;
}

//压缩图片
+ (UIImage*)modifyImage:(UIImage *)image scaleToSize:(CGSize)size {
    
    if (size.width > 960) {
        size.height = 960 * size.height / size.width;
        size.width = 960;
    }
    if (size.height > 960) {
        size.width = 960 * size.width / size.height;
        size.height = 960;
    }
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

+(UIImage *) convertImageToDeviceColorSpace:(UIImage *) source
{
    // Get the CGImageRef
    CGImageRef imageRef = [source CGImage];
    
    // Find width and height
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    
    CGColorSpaceRef colorSpace =  CGColorSpaceCreateDeviceRGB();
    
    // Create a CGBitmapContext to draw an image into
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(NULL, width, height,
                                                 bitsPerComponent, bytesPerRow, CGColorSpaceCreateDeviceRGB(),
                                                 kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(colorSpace);
    // Draw the image which will populate rawData
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    
    UIImage * result = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
    CGContextRelease(context);
    
    return result;
}
@end
