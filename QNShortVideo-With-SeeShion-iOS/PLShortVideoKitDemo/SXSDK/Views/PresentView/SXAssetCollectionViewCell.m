//
//  SXAssetCollectionViewCell.m
//  SXEditDemo
//
//  Created by Yin Xie on 2018/11/14.
//  Copyright © 2018 Yin Xie. All rights reserved.
//

#import "SXAssetCollectionViewCell.h"

@implementation SXAssetCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _numberLabel.backgroundColor = kMainColor;
    _borderImageView.image = [[UIImage imageWithBorderWidth:2.0 corner:0.0 size:CGSizeMake(8.0, 8.0) fillColor:kMainColor] resizableImageWithCapInsets:UIEdgeInsetsMake(2.0, 2.0, 2.0, 2.0) resizingMode:UIImageResizingModeStretch];
}

- (void)setSelected:(BOOL)selected {
    _borderImageView.hidden = !selected;
}

- (void)setData:(SXGroupModel *)model index:(NSInteger)index {
    _numberLabel.text = [NSString stringWithFormat:@"%li", (long)index];
    _previewImageView.image = model.shadeImage;
    _assetImageView.image = model.assetImage;
    _textImageView.image = model.textImage;
}
@end
