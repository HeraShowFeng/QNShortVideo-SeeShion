//
//  ChoosePhotoViewController.h
//  CustomImagePickerController
//
//  Created by 李记波 on 2018/11/13.
//  Copyright © 2018年 李记波. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomImageView.h"
#import "DeleteChooseImageView.h"
#import "DeleteChooseView.h"
#import "Header.h"
#import "SXPinTuAssetModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^SelectImageBlock)(NSArray*, NSArray*);

@interface ChoosePhotoViewController : MainSuperViewController

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger  maxPage;
@property (nonatomic, assign) CGFloat    needVideoTime;
@property (nonatomic, assign) BOOL  isMoreSelect;
@property (nonatomic, assign) BOOL allowSelectVideo;
@property (nonatomic, assign) BOOL allowSelectImage;
//图片过多可以先设置为no，只有路径，没有图片。
@property (nonatomic, assign) BOOL shouldAnialysisAsset;
//配合上面一起使用。
@property (nonatomic, copy)   void(^selectImagesPath)(NSArray*);

@property (nonatomic, copy)   SelectImageBlock  selectBlock;
@property (nonatomic, assign) CGSize needEditorSize;
@property (nonatomic, assign) BOOL  isPushNextView;
@property (nonatomic, assign) BOOL noNeedCutVideo;
@end

NS_ASSUME_NONNULL_END
