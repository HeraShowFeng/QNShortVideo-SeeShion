//
//  DeleteCollectionViewCell.m
//  CustomImagePickerController
//
//  Created by 李记波 on 2018/12/8.
//  Copyright © 2018年 李记波. All rights reserved.
//

#import "DeleteCollectionViewCell.h"
#import "SXUICalculateUtil.h"

@interface DeleteCollectionViewCell ()

@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, assign) PHImageRequestID imageRequestID;

@end

@implementation DeleteCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.bgImageView];
        [self.contentView addSubview:self.deleteBtn];
        [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right);
            make.top.equalTo(self.contentView.mas_top);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left);
            make.top.equalTo(self.contentView.mas_top).offset(5);
            make.right.equalTo(self.contentView.mas_right).offset(-5);
            make.bottom.equalTo(self.contentView.mas_bottom);
        }];
    }
    return self;
}
- (void)upDataViewWithModel:(ZLPhotoModel*)model {
    
    self.deleteModel = model;
    kWeakSelf(self);
    [self.bgImageView layoutIfNeeded];
    [self.bgImageView setNeedsLayout];
    
    if (model.asset && self.imageRequestID >= PHInvalidImageRequestID) {
        [[PHCachingImageManager defaultManager] cancelImageRequest:self.imageRequestID];
    }
    self.identifier = model.asset.localIdentifier;
    self.bgImageView.image = nil;
   self.imageRequestID = [PhotoManger requestImageForAsset:model.asset size:[SXUICalculateUtil getImageSizeWithImageView:self.bgImageView] completion:^(UIImage * _Nonnull image, NSDictionary * _Nonnull info) {
        kStrongify(weakSelf);
       if ([strongSelf.identifier isEqualToString:model.asset.localIdentifier]) {
           strongSelf.bgImageView.image = image;
       }
       
       if (![[info objectForKey:PHImageResultIsDegradedKey] boolValue]) {
           strongSelf.imageRequestID = -1;
       }
    }];
}

- (UIImageView*)bgImageView {
    if (_bgImageView == nil) {
        _bgImageView = [[UIImageView alloc] init];
        //_bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _bgImageView;
}
- (UIButton*)deleteBtn {
    if (_deleteBtn == nil) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setBackgroundImage:[UIImage imageNamed:@"delphoto_icon"] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(deleteModelClock) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}
- (void)deleteModelClock {
    //NSLog(@"这个执行了几次了啊？");
    if (self.deleteBlcok) {
        self.deleteBlcok(self.deleteModel, 0);
    }
}

@end
