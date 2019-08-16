//
//  SXTextColorCollectionViewCell.h
//  SXEditDemo
//
//  Created by 李记波 on 2018/12/13.
//  Copyright © 2018年 Yin Xie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum _collectionViewCellType {
    maskType = 0,
    minCheckType
    
} CollectionViewCellType;

@interface SXTextColorCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIView *selectView;
@property (nonatomic, strong) UIView *colorView;
@property (nonatomic, strong) UIImageView *selectImageView;
@property (nonatomic, assign) CollectionViewCellType type;

- (void)upDateWith:(NSDictionary*)dict;

@end

NS_ASSUME_NONNULL_END
