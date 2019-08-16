//
//  CostumCollectionViewCell.m
//  CustomImagePickerController
//
//  Created by 李记波 on 2018/11/13.
//  Copyright © 2018年 李记波. All rights reserved.
//

#import "CostumCollectionViewCell.h"

@implementation CostumCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.isChoose = true;
        __block UIView * view = self;
        [self.contentView addSubview:self.customImageView];
        [_customImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view.mas_left);
            make.bottom.equalTo(view.mas_bottom);
            make.top.equalTo(view.mas_top);
            make.right.equalTo(view.mas_right);
        }];
    };
    return self;
}

- (void)reloadData:(ZLPhotoModel*)model Type:(ViewCellType) type {
    self.customImageView.model = model;
    self.customImageView.viewType = type;
    [self.customImageView upData];

}

- (void)deleteImageNow {
    
}
- (CustomImageView*)customImageView {
    if (_customImageView == nil) {
        _customImageView = [[CustomImageView alloc] initWithFrame:CGRectZero type:chooseType];
    }
    return _customImageView;
}

@end
