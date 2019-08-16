//
//  SXViewExtension.h
//  SXEditDemo
//
//  Created by Yin Xie on 2018/11/14.
//  Copyright © 2018 Yin Xie. All rights reserved.
//

#ifndef SXViewExtension_h
#define SXViewExtension_h

@interface UIColor (Hex)
+ (UIColor *) colorWithHexString: (NSString *)color;
@end

@interface UILabel (ContentSize)

- (CGSize)contentSize;

@end

@interface UIImage(Color)

+ (UIImage *)imageWithCorner:(CGFloat)corner size:(CGSize)size fillColor:(UIColor *)fillColor;

+ (UIImage *)imageWithBorderWidth:(CGFloat)width corner:(CGFloat)corner size:(CGSize)size fillColor:(UIColor *)fillColor;
@end

#endif /* SXViewExtension_h */
