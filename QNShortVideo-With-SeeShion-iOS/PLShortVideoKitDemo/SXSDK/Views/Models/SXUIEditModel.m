//
//  SXUIEditModel.m
//  SXEditDemo
//
//  Created by Yin Xie on 2018/11/13.
//  Copyright © 2018 Yin Xie. All rights reserved.
//

#import "SXUIEditModel.h"
#import "SXUICalculateUtil.h"
#import <Accelerate/Accelerate.h>

@implementation SXUIEditModel

- (instancetype)initWithDictionary:(NSDictionary *)data {
    if (self = [super init]) {
        [self setEditData: data];
        return self;
    }
    return nil;
}

- (void)setEditData:(NSDictionary *)data {
    _group = [data[@"group"] intValue];
    _index = [data[@"index"] intValue];
    _type = [data[@"type"] intValue];
    _duration = [data[@"duration"] floatValue];
    _file = [NSString stringWithFormat:@"%@", data[@"f"]];
    _position = [SXParseJsonUtil initPointWithArray:data[@"p"]];
    _anchor = [SXParseJsonUtil initPointWithArray:data[@"a"]];
    _alpha = [data[@"t"] floatValue];
    _rotation = [data[@"r"] floatValue];
    _scale = [SXParseJsonUtil initPointWithArray:data[@"s"]];
    _area = [SXParseJsonUtil initRectWithArray:data[@"area"]];

    _defaultText = data[@"default"];
    _maxLength = [data[@"max"] intValue];
    _font = data[@"font"];
    _fontSize = [data[@"size"] intValue];
    _fillColor = [UIColor colorWithHexString:data[@"fill"]];
    _strokeColor = [UIColor colorWithHexString:data[@"stroke"]];
    _width = [data[@"width"] intValue];
    _align = [data[@"align"] intValue];
    _shadowColor = [UIColor colorWithHexString:data[@"stroke"]];
    _shadowAlpha = [data[@"s_alpha"] floatValue];
    _shadowAngle = [data[@"s_angle"] intValue];
    _shadowDistance = [data[@"s_dist"] intValue];
    _shadowSize = [data[@"s_size"] intValue];
    
    CGFloat rotation = _rotation * M_PI / 180;
    CGFloat cs = cos(rotation), sn = sin(rotation);
    CGFloat mA = cs * _scale.x;
    CGFloat mB = sn * _scale.x;
    CGFloat mC = -sn * _scale.y;
    CGFloat mD = cs * _scale.y;
    CGFloat mE = _position.x;
    CGFloat mF = _position.y;
    _transform = CGAffineTransformMake(mA, mB, mC, mD, 0, 0);
    
    
    _renderTransform = _transform;
    _renderTransform.tx = mE;
    _renderTransform.ty = mF;
    _renderTransform =
    CGAffineTransformTranslate(_renderTransform, -_anchor.x, -_anchor.y);
    _originTransform = _renderTransform;
    _invertTransform = [self invertTransform:_originTransform];
    
    [self setSize: [SXParseJsonUtil initSizeWithArray:data[@"editSize"]]];
}

- (void)setSize:(CGSize)size {
    _size = size;
    CGAffineTransform form = CGAffineTransformTranslate(_renderTransform, _size.width / 2, _size.height / 2);
    _translation = CGPointMake(form.tx - _size.width / 2, form.ty - _size.height / 2);
}

- (void)setAsset:(SXPinTuAssetModel *)assetModel {
    _assetModel = assetModel;
    if (_type == SXAssetTypeImage) {
        CGSize size = assetModel.getCoverImage.size;
        float widthScale = _size.width / size.width;
        float heightScale = _size.height / size.height;
        float maxScale = MAX(widthScale, heightScale);
        
        CGFloat rotation = _rotation * M_PI / 180;
        CGFloat cs = cos(rotation), sn = sin(rotation);
        CGFloat mA = cs * _scale.x;
        CGFloat mB = sn * _scale.x;
        CGFloat mC = -sn * _scale.y;
        CGFloat mD = cs * _scale.y;
        CGFloat mE = _position.x;
        CGFloat mF = _position.y;
        
        _renderTransform = CGAffineTransformMake(mA, mB, mC, mD, mE, mF);
        _renderTransform =
        CGAffineTransformTranslate(_renderTransform, -_anchor.x, -_anchor.y);
        _renderTransform = CGAffineTransformScale(_renderTransform, maxScale, maxScale);
        CGAffineTransform form = CGAffineTransformTranslate(_renderTransform, size.width / 2, size.height / 2);
        _translation = CGPointMake(form.tx - size.width / 2, form.ty - size.height / 2);
        _transform = _renderTransform;
        _transform.tx = 0;
        _transform.ty = 0;
    }
    [self updateRenderImage];
}

- (void)updateRenderImage {
    if (_type == SXAssetTypeText) {
        _renderImage = _assetModel.getCoverImage;
    }else {
        CGAffineTransform transform = [self multTransform:_renderTransform transform:_invertTransform];

        CGSize size = _assetModel.getCoverImage.size;
        
        CGRect frame = CGRectMake(0.0, 0.0, size.width, size.height);
        UIGraphicsBeginImageContext(_size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextConcatCTM(context, transform);
        CGContextRotateCTM(context, M_PI);
        CGContextScaleCTM(context, -1, 1);
        CGContextTranslateCTM(context, 0, -size.height);
        CGContextDrawImage(context, frame, _assetModel.getCoverImage.CGImage);
        _renderImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
}

- (CGAffineTransform)invertTransform:(CGAffineTransform)transform {
    double inMatrix[] = {transform.a, transform.b, 0,
                         transform.c, transform.d, 0,
        transform.tx, transform.ty, 1} ;
    int r = 3;
    __CLPK_integer ipiv[r];
    __CLPK_integer info;
    __CLPK_doublereal workspace;
    dgetrf_(&r, &r, inMatrix, &r, ipiv, &info);
    dgetri_(&r, inMatrix, &r, ipiv, &workspace, &r, &info);
    transform.a = inMatrix[0];
    transform.b = inMatrix[1];
    transform.c = inMatrix[3];
    transform.d = inMatrix[4];
    transform.tx = inMatrix[6];
    transform.ty = inMatrix[7];
    return transform;
}

- (CGAffineTransform)multTransform:(CGAffineTransform)transform1 transform:(CGAffineTransform)transform2 {
    double a[] = {transform1.a, transform1.b, 0,
        transform1.c, transform1.d, 0,
        transform1.tx, transform1.ty, 1};
    double b[] = {transform2.a, transform2.b, 0,
        transform2.c, transform2.d, 0,
        transform2.tx, transform2.ty, 1} ;
    double *result = calloc(9, sizeof(double));
    
    vDSP_mmulD(a, 1, b, 1, result, 1, 3, 3, 3);
    
    CGAffineTransform transform;
    transform.a = result[0];
    transform.b = result[1];
    transform.c = result[3];
    transform.d = result[4];
    transform.tx = result[6];
    transform.ty = result[7];
    
    free(result);
    return transform;
}
@end
