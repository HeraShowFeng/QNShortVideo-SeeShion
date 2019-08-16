//
//  DeleteChooseView.h
//  CustomImagePickerController
//
//  Created by 李记波 on 2018/12/7.
//  Copyright © 2018年 李记波. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"
#import "CostumCollectionViewCell.h"

@interface DeleteChooseView : UIView <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *deleteCollectionView;
@property (nonatomic, strong) UILabel   *chooseNumberLabel;
@property (nonatomic, strong) UIButton  *sureBtn;
@property (nonatomic, strong) NSMutableArray *chooseArr;
@property (nonatomic, assign) NSInteger maxNumberImage;
@property (nonatomic, copy) MyBlock   chooseBlcok;

- (void)reloadDataWithArr:(NSMutableArray*)arr;

@end

