//
//  SXUIEditModel.h
//  SXEditDemo
//
//  Created by Yin Xie on 2018/11/13.
//  Copyright © 2018 Yin Xie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SXPinTuAssetModel.h"
NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    SXAssetTypeImage = 1,
    SXAssetTypeText = 2,
} SXAssetType;

@interface SXUIEditModel : NSObject
@property (nonatomic, assign) SXAssetType type;
@property (nonatomic, assign) int group;
@property (nonatomic, assign) int index;
@property (nonatomic, assign) float duration;
@property (nonatomic, copy)   NSString *file;
@property (nonatomic, assign) CGPoint position;
@property (nonatomic, assign) CGPoint anchor;
@property (nonatomic, assign) float alpha;
@property (nonatomic, assign) int rotation;
@property (nonatomic, assign) CGPoint scale;
@property (nonatomic, assign) CGRect area;
@property (nonatomic, assign) CGSize size;

@property (nonatomic, copy)   NSString *defaultText;
@property (nonatomic, assign) int maxLength;
@property (nonatomic, copy)   NSString *font;
@property (nonatomic, assign) int fontSize;
@property (nonatomic, strong) UIColor *fillColor;
@property (nonatomic, strong) UIColor *strokeColor;
@property (nonatomic, assign) int width;
@property (nonatomic, assign) int align;
@property (nonatomic, strong) UIColor *shadowColor;
@property (nonatomic, assign) float shadowAlpha;
@property (nonatomic, assign) int shadowAngle;
@property (nonatomic, assign) int shadowDistance;
@property (nonatomic, assign) int shadowSize;
@property (nonatomic, strong) UIImage *renderImage;
@property (nonatomic, strong, readonly) SXPinTuAssetModel *assetModel;
@property (nonatomic, assign) CGAffineTransform originTransform;
@property (nonatomic, assign) CGAffineTransform invertTransform;
@property (nonatomic, assign) CGAffineTransform transform;
@property (nonatomic, assign) CGAffineTransform renderTransform;
@property (nonatomic, assign) CGPoint translation;
- (instancetype)initWithDictionary:(NSDictionary *)data;
- (void)setAsset:(SXPinTuAssetModel *)assetModel;
- (void)updateRenderImage;
- (CGAffineTransform)invertTransform:(CGAffineTransform)transform;
@end

NS_ASSUME_NONNULL_END
