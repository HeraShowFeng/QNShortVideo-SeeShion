//
//  DeleteChooseView.m
//  CustomImagePickerController
//
//  Created by 李记波 on 2018/12/7.
//  Copyright © 2018年 李记波. All rights reserved.
//

#import "DeleteChooseView.h"
#import "DeleteCollectionViewCell.h"


@implementation DeleteChooseView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame: frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        //毛玻璃视图
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        [self addSubview:effectView];
        self.sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        self.sureBtn.backgroundColor = [UIColor colorWithHexString:kYellowColor];
        self.sureBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.sureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.sureBtn.layer.cornerRadius = 14;
        [self addSubview:self.sureBtn];
        
        self.chooseNumberLabel = [[UILabel alloc] init];
        self.chooseNumberLabel.textColor = [UIColor whiteColor];
        self.chooseNumberLabel.backgroundColor = [UIColor clearColor];
        self.chooseNumberLabel.font = [UIFont systemFontOfSize:14];
        self.chooseNumberLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:self.chooseNumberLabel];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        layout.itemSize = CGSizeMake(85, 85);
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 5;
        self.deleteCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        self.deleteCollectionView.backgroundColor = [UIColor clearColor];
        self.deleteCollectionView.dataSource = self;
        self.deleteCollectionView.delegate = self;
        if (@available(iOS 10.0,*)) {
            self.deleteCollectionView.prefetchingEnabled = NO;
        }
        [self addSubview:self.deleteCollectionView];
        [self.deleteCollectionView registerClass:[DeleteCollectionViewCell class] forCellWithReuseIdentifier:@"cellId"];
        kWeakSelf(self);
        [effectView mas_makeConstraints:^(MASConstraintMaker *make) {
            kStrongify(weakSelf);
            make.edges.equalTo(strongSelf);
        }];
        [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            kStrongify(weakSelf);
            make.right.equalTo(strongSelf.mas_right).offset(-15);
            make.top.equalTo(strongSelf.mas_top).offset(10);
            make.size.mas_equalTo(CGSizeMake(60, 28));
            
        }];
        [self.chooseNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            kStrongify(weakSelf);
            make.left.equalTo(strongSelf.mas_left).offset(15);
            make.centerY.equalTo(strongSelf.sureBtn.mas_centerY);
            make.width.lessThanOrEqualTo(@(kScreen_Width/2));
            make.height.mas_equalTo(@(28));
        }];
        [self.deleteCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            kStrongify(weakSelf);
            make.top.equalTo(strongSelf.sureBtn.mas_bottom).offset(5);
            make.left.equalTo(strongSelf.mas_left).offset(15);
            make.right.equalTo(strongSelf.mas_right).offset(-10);
            make.bottom.equalTo(strongSelf.mas_bottom).offset(-20);
        }];
    }
    return self;
}
- (void)reloadDataWithArr:(NSMutableArray*)arr {
    self.chooseArr = arr;
    NSString *numberStr = [NSString stringWithFormat:@"%lu",(unsigned long)arr.count];
    NSString *str = kNumberText(arr.count, self.maxNumberImage);
    NSMutableAttributedString *attribut = [[NSMutableAttributedString alloc]initWithString:str];
    [attribut addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:kYellowColor] range:NSMakeRange(3, numberStr.length)];
    self.chooseNumberLabel.attributedText = attribut;
    
    [CATransaction setDisableActions:YES];
    [self.deleteCollectionView reloadData];
    [CATransaction commit];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.chooseArr.count;
}
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    DeleteCollectionViewCell *cell = (DeleteCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    cell.tag = 1000 +indexPath.row;
    ZLPhotoModel *model = self.chooseArr[indexPath.row];
    cell.deleteBlcok = ^(ZLPhotoModel *model, NSInteger number) {
        model.selected = !model.selected;
        [self.chooseArr removeObject:model];
        [self reloadDataWithArr:self.chooseArr];
        if (self.chooseBlcok) {
            self.chooseBlcok(model, indexPath.row);
        }
    };
    [cell upDataViewWithModel:model];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}
@end
