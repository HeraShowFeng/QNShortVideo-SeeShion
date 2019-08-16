//
//  SXAssetCollectionViewCell.h
//  SXEditDemo
//
//  Created by Yin Xie on 2018/11/14.
//  Copyright © 2018 Yin Xie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SXGroupModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SXAssetCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UIImageView *assetImageView;
@property (nonatomic, strong) UIImageView *previewImageView;
@property (nonatomic, strong) UIImageView *borderImageView;
@property (nonatomic, strong) UIImageView *textImageView;

- (void)setData:(SXGroupModel *)model index:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
