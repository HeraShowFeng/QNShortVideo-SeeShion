//
//  CustomImageView.h
//  CustomImagePickerController
//
//  Created by 李记波 on 2018/11/12.
//  Copyright © 2018年 李记波. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"
#import "ZLPhotoModel.h"
//#import "PhotoManger.h"

@interface CustomImageView : UIView

@property (nonatomic, strong) UIButton    *deleteButton;
@property (nonatomic, strong) UILabel     *chooseLabel;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, assign) ViewCellType    viewType;
@property (nonatomic, strong) UILabel     *timeLabel;
@property (nonatomic, strong) UIImageView *chooseImageView;
@property (nonatomic, strong) UIView      *chooseView;
@property (nonatomic, strong) ZLPhotoModel *model;

- (instancetype)initWithFrame:(CGRect)frame type:(ViewCellType)type;
- (void)upData;

@end

