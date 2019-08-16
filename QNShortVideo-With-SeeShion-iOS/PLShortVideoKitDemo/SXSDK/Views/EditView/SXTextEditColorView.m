//
//  SXTextEditColorView.m
//  SXEditDemo
//
//  Created by 李记波 on 2018/12/13.
//  Copyright © 2018年 Yin Xie. All rights reserved.
//

#import "SXTextEditColorView.h"
#import "SXTextColorCollectionViewCell.h"
#import "SXEditBorderSlider.h"

#define kTextColorIdentifier @"Textcell"
#define kBorderColorIdentifier @"BordercellId"

@interface SXTextEditColorView () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UILabel *textColorLabel;
@property (nonatomic, strong) UILabel *borderColorLabel;
@property (nonatomic, strong) UILabel *borderWidthLabel;
@property (nonatomic, strong) UICollectionView *borderCollectionView;
@property (nonatomic, strong) SXEditBorderSlider *borderSlider;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *minNumberLabel;
@property (nonatomic, strong) UILabel *maxNumberLabel;
@property (nonatomic, strong) NSArray *textColorArr;
@property (nonatomic, strong) NSArray *borderColorArr;

@end

@implementation SXTextEditColorView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        kWeakSelf(self);
        self.textColorLabel = [self setCoustomLabel:14 WithColor:[UIColor whiteColor] WithText:@"字体颜色"];
        self.borderColorLabel = [self setCoustomLabel:14 WithColor:[UIColor whiteColor] WithText:@"描边颜色"];
        self.borderWidthLabel = [self setCoustomLabel:14 WithColor:[UIColor whiteColor] WithText:@"描边粗细"];
        [self addSubview:self.textColorLabel];
       // [self addSubview:self.borderWidthLabel];
       // [self addSubview:self.borderColorLabel];
        
//        self.borderSlider = [[SXEditBorderSlider alloc] init];
//        self.borderSlider.maximumValue = 15;
//        self.borderSlider.value = 0;
//        self.borderSlider.continuous = YES;
//        self.borderSlider.thumbTintColor = kMainColor;
//        UIImage *image = [UIImage imageWithCorner:10 size:CGSizeMake(20, 20) fillColor:kMainColor];
//        [self.borderSlider setThumbImage:image forState:UIControlStateNormal];
//        [self.borderSlider setThumbImage:image forState:UIControlStateHighlighted];
//        self.borderSlider.minimumTrackTintColor = kMainColor;
//        self.borderSlider.valueChanged = ^(SXEditBorderSlider * _Nonnull slider) {
//            if (weakSelf.selectBorderWidthBlock) {
//                weakSelf.selectBorderWidthBlock(slider.value);
//            }
//        };
//        [self addSubview:self.borderSlider];
        
//        self.minNumberLabel = [self setCoustomLabel:14 WithColor:[UIColor whiteColor] WithText:@"0"];
//        self.maxNumberLabel = [self setCoustomLabel:14 WithColor:[UIColor whiteColor] WithText:@"15"];
//        [self addSubview:self.minNumberLabel];
//        [self addSubview:self.maxNumberLabel];

        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        layout.itemSize = CGSizeMake(32, 32);
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.collectionView.tag = 3000;
        self.collectionView.showsHorizontalScrollIndicator = NO;
        [self.collectionView registerClass:[SXTextColorCollectionViewCell class] forCellWithReuseIdentifier:kTextColorIdentifier];
        [self addSubview:self.collectionView];
        
//        self.borderCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
//        self.borderCollectionView.dataSource = self;
//        self.borderCollectionView.delegate = self;
//        self.borderCollectionView.tag = 3001;
//        self.borderCollectionView.showsHorizontalScrollIndicator = NO;
//        [self.borderCollectionView registerClass:[SXTextColorCollectionViewCell class] forCellWithReuseIdentifier:kBorderColorIdentifier];
//        [self addSubview:self.borderCollectionView];
//
        
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf.mas_right);
            make.top.equalTo(weakSelf.mas_top).offset(5);
            make.left.equalTo(weakSelf.textColorLabel.mas_right).offset(10);
            make.height.mas_equalTo(@(32));
        }];
//        [self.borderCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(weakSelf.mas_right);
//            make.top.equalTo(weakSelf.collectionView.mas_bottom).offset(20);
//            make.left.equalTo(weakSelf.collectionView.mas_left);
//            make.height.mas_equalTo(@(32));
//        }];
        [self.textColorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.collectionView.mas_centerY);
            make.left.equalTo(weakSelf.mas_left).offset(15);
            make.size.mas_equalTo(CGSizeMake(60, 32));
        }];
//        [self.borderWidthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(weakSelf.borderSlider.mas_centerY);
//            make.left.equalTo(weakSelf.mas_left).offset(15);
//            make.size.mas_equalTo(CGSizeMake(60, 32));
//        }];
//        [self.borderColorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(weakSelf.borderCollectionView.mas_centerY);
//            make.left.equalTo(weakSelf.mas_left).offset(15);
//            make.size.mas_equalTo(CGSizeMake(60, 32));
//        }];
//        [self.borderSlider mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(weakSelf.maxNumberLabel.mas_left).offset(-8);
//            make.bottom.equalTo(weakSelf.mas_bottom).offset(-40);
//            make.left.equalTo(weakSelf.minNumberLabel.mas_right).offset(8);
//            make.height.mas_equalTo(@(25));
//        }];
//        [self.minNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(weakSelf.borderWidthLabel.mas_right).offset(15);
//            make.centerY.equalTo(self.borderSlider.mas_centerY);
//            make.size.mas_equalTo(CGSizeMake(10, 11));
//        }];
//        [self.maxNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(weakSelf.mas_right).offset(-15);
//            make.centerY.equalTo(self.borderSlider.mas_centerY);
//            make.size.mas_equalTo(CGSizeMake(15, 11));
//        }];
//
    }
    return self;
}
- (void)updateColllectionView:(NSArray*)textArr WithBorderColors:(NSArray*)borderArr {
    self.textColorArr = textArr;
    self.borderColorArr = borderArr;
    [self.collectionView reloadData];
   // [self.borderCollectionView reloadData];
}
- (void)sliderValueChanged:(UISlider*)sender {
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView.tag == 3000) {
        return self.borderColorArr.count;
    } else {
        return self.borderColorArr.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SXTextColorCollectionViewCell *cell;
    if (collectionView.tag == 3000) {
        cell = (SXTextColorCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kTextColorIdentifier forIndexPath:indexPath];
        cell.type = maskType;
        [cell upDateWith:[self.borderColorArr objectAtIndex:indexPath.row]];
    } else {
        cell = (SXTextColorCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kBorderColorIdentifier forIndexPath:indexPath];
        cell.type = minCheckType;
        [cell upDateWith:[self.borderColorArr objectAtIndex:indexPath.row]];
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    BOOL isTextColor = collectionView.tag == 3000? YES:NO;
    if (self.selectColorBlock) {
        self.selectColorBlock(isTextColor, [self.borderColorArr objectAtIndex:indexPath.row]);
    }
}
- (UILabel*)setCoustomLabel:(CGFloat)size WithColor:(UIColor*)color WithText:(NSString*)text {
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:size];
    label.textColor =color;
    label.text = text;
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentLeft;
    return label;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
