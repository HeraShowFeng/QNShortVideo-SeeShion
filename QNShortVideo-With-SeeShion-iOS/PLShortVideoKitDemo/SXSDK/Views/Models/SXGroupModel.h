//
//  SXGroupModel.h
//  SXEditDemo
//
//  Created by Yin Xie on 2018/12/13.
//  Copyright © 2018 Yin Xie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SXAssetModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SXGroupModel : NSObject
@property (nonatomic, strong) UIImage *shadeImage;
@property (nonatomic, strong) UIImage *assetImage;
@property (nonatomic, strong) UIImage *textImage;
@property (nonatomic, assign) CGSize  groupSize;

@property (nonatomic, strong, readonly) NSMutableArray *assetModels;

- (void)setAssetModels:(NSMutableArray * _Nonnull)assetModels;
- (void)updateAsset:(SXPinTuAssetModel *)asset index:(NSInteger)index;
- (void)updateAsset;
- (void)updateImages;
- (void)updateText;
@end

NS_ASSUME_NONNULL_END
