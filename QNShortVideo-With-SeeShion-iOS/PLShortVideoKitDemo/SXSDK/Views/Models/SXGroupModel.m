//
//  SXGroupModel.m
//  SXEditDemo
//
//  Created by Yin Xie on 2018/12/13.
//  Copyright © 2018 Yin Xie. All rights reserved.
//

#import "SXGroupModel.h"

@implementation SXGroupModel

- (void)setAssetModels:(NSMutableArray *)assetModels {
    _assetModels = assetModels;
    [self updateImages];
}

- (void)updateAsset:(SXPinTuAssetModel *)asset index:(NSInteger)index {
    if (index < _assetModels.count) {
        SXAssetModel *model = _assetModels[index];
        [model setAsset:asset];
        _assetImage = [self updateImage:0];
    }
}

- (void)updateAsset {
    _assetImage = [self updateImage:0];
}

- (void)updateText {
    _textImage = [self updateImage:2];
}

-(void) updateImages {
    _assetImage = [self updateImage:0];
    _shadeImage = [self updateImage:1];
    _textImage = [self updateImage:2];
}
//type 0: assetImage, 1: shadeImage, 2: textImage
- (UIImage *)updateImage:(int)type {
    CGRect frame = CGRectMake(0.0, 0.0, _groupSize.width, _groupSize.height);
    UIGraphicsBeginImageContext(frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGAffineTransform contextTransform = CGContextGetCTM(context);
    for (SXAssetModel *asset in _assetModels) {
        CGAffineTransform invertContextTransform = [asset.editModel invertTransform:CGContextGetCTM(context)];
        CGContextConcatCTM(context, invertContextTransform);
        CGContextConcatCTM(context, contextTransform);
        switch (type) {
            case 0:
            {
                if (asset.editModel.type == SXAssetTypeImage && asset.editModel.renderImage) {
                    CGSize imageSize = asset.editModel.size;
                    CGRect frame = CGRectMake(0.0, 0.0, imageSize.width, imageSize.height);
                    CGContextConcatCTM(context, asset.editModel.originTransform);
                    CGContextRotateCTM(context, M_PI);
                    CGContextScaleCTM(context, -1, 1);
                    CGContextTranslateCTM(context, 0, -imageSize.height);
                    CGContextDrawImage(context, frame, asset.editModel.renderImage.CGImage);
                }
            }
                break;
            case 1:
            {
                UIImage *shadeImage = [asset getShadeImage];
                if (shadeImage) {
                    CGContextRotateCTM(context, M_PI);
                    CGContextScaleCTM(context, -1, 1);
                    CGContextTranslateCTM(context, 0, -_groupSize.height);
                    CGContextDrawImage(context, frame, shadeImage.CGImage);
                }
                
            }
                break;
            case 2:
            {
                if (asset.editModel.type == SXAssetTypeText && asset.editModel.renderImage) {
                    CGSize imageSize = asset.editModel.size;
                    CGRect frame = CGRectMake(0.0, 0.0, imageSize.width, imageSize.height);
                    CGContextConcatCTM(context, asset.editModel.originTransform);
                    CGContextRotateCTM(context, M_PI);
                    CGContextScaleCTM(context, -1, 1);
                    CGContextTranslateCTM(context, 0, -imageSize.height);
                    CGContextDrawImage(context, frame, asset.editModel.renderImage.CGImage);
                }
            }
                break;
            default:
                break;
        }
        
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
