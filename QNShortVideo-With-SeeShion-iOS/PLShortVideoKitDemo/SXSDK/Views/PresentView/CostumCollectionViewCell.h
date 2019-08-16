//
//  CostumCollectionViewCell.h
//  CustomImagePickerController
//
//  Created by 李记波 on 2018/11/13.
//  Copyright © 2018年 李记波. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry.h>
#import "CustomImageView.h"
#import "Header.h"


NS_ASSUME_NONNULL_BEGIN


@interface CostumCollectionViewCell : UICollectionViewCell

@property (nonatomic, assign) ViewCellType    viewType;
@property (nonatomic, assign) BOOL         isChoose;
@property (nonatomic, strong) CustomImageView *customImageView;
@property (nonatomic, strong) NSArray *selectArr;

- (void)reloadData:(ZLPhotoModel*)model Type:(ViewCellType) type;

@end

NS_ASSUME_NONNULL_END
