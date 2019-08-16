//
//  DeleteCollectionViewCell.h
//  CustomImagePickerController
//
//  Created by 李记波 on 2018/12/8.
//  Copyright © 2018年 李记波. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"

@interface DeleteCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, copy) MyBlock  deleteBlcok;
@property (nonatomic, strong) ZLPhotoModel *deleteModel;

- (void)upDataViewWithModel:(ZLPhotoModel*)model;

@end


