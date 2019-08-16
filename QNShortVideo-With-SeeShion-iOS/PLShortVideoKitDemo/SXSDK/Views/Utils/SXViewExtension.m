//
//  SXViewExtension.m
//  SXEditDemo
//
//  Created by Yin Xie on 2018/11/14.
//  Copyright © 2018 Yin Xie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SXViewExtension.h"

@implementation UIColor (Hex)

// 颜色转换三：iOS中十六进制的颜色（以#开头）转换为UIColor
+ (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6)
    {
        return [UIColor clearColor];
    }
    
    // 判断前缀并剪切掉
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6 && [cString length] != 8)
        return [UIColor clearColor];
    
    // 从六位数值中找到RGB对应的位数并转换
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //R、G、B
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    CGFloat alpha = 1.0;
    
    if ([cString length] == 8) {
        range.location = 6;
        NSString *aString = [cString substringWithRange:range];
        unsigned int a;
        [[NSScanner scannerWithString:aString] scanHexInt:&a];
        alpha = (float) a / 255.f;
    }
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:alpha];
}
@end

@implementation UILabel (ContentSize)

- (CGSize)contentSize {
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = self.lineBreakMode;
    paragraphStyle.alignment = self.textAlignment;
    NSDictionary * attributes = @{NSFontAttributeName : self.font,
                                  NSParagraphStyleAttributeName : paragraphStyle};
    CGSize contentSize = [self.text boundingRectWithSize:self.frame.size
                                                 options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                              attributes:attributes
                                                 context:nil].size;
    return contentSize;
}

@end

@implementation UIImage(Color)

+ (UIImage *)imageWithCorner:(CGFloat)corner size:(CGSize)size fillColor:(UIColor *)fillColor {
    UIGraphicsBeginImageContextWithOptions(size, false, 0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect imageRect = CGRectMake(0.0, 0.0, size.width, size.height);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:imageRect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(corner, corner)];
    CGContextAddPath(context, path.CGPath);
    
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    CGContextFillPath(context);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)imageWithBorderWidth:(CGFloat)width corner:(CGFloat)corner size:(CGSize)size fillColor:(UIColor *)fillColor {
    UIGraphicsBeginImageContextWithOptions(size, false, 0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect imageRect = CGRectMake(width / 2, width / 2, size.width - width, size.height - width);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:imageRect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(corner, corner)];
    [path closePath];
    CGContextAddPath(context, path.CGPath);
    
    CGContextSetLineWidth(context, width);
    CGContextSetStrokeColorWithColor(context, fillColor.CGColor);
    CGContextStrokePath(context);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}
@end
