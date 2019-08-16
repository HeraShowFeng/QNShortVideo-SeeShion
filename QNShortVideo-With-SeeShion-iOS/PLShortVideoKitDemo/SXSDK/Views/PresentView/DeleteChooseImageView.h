//
//  DeleteChooseImageView.h
//  CustomImagePickerController
//
//  Created by 李记波 on 2018/11/14.
//  Copyright © 2018年 李记波. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry.h>
#import "CustomImageView.h"
#import <Photos/Photos.h>
#import "ZLPhotoModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^MyBlock)(ZLPhotoModel*,NSInteger);

@interface DeleteChooseImageView : UIView <UIScrollViewDelegate>

@property (nonatomic, strong) CustomImageView *customView;
@property (nonatomic, strong) UIScrollView *bgScrollView;
@property (nonatomic, copy) MyBlock deleteBlock;

- (instancetype)initWithFrame:(CGRect)frame withMaxPage:(NSInteger)number;
- (void) addChooseImageViewWithArr:(NSArray*)arr;

@end

NS_ASSUME_NONNULL_END
