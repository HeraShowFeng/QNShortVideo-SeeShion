//
//  DeleteChooseImageView.m
//  CustomImagePickerController
//
//  Created by 李记波 on 2018/11/14.
//  Copyright © 2018年 李记波. All rights reserved.
//

#import "DeleteChooseImageView.h"
#import "Header.h"


@interface DeleteChooseImageView ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) NSMutableArray *viewArr;
@property (nonatomic, assign) NSInteger  number;
@property (nonatomic, strong) NSArray *modelArr;

@end

@implementation DeleteChooseImageView

- (instancetype)initWithFrame:(CGRect)frame withMaxPage:(NSInteger)number {
    self = [super initWithFrame:frame];
    if (self) {
        self.viewArr = [[NSMutableArray alloc] initWithCapacity:0];
        [self addSubview:self.bgScrollView];
        self.bgView = [[UIView alloc] init];
        //self.bgView.backgroundColor = [UIColor redColor];
        [self.bgScrollView addSubview:_bgView];
        self.number = number;
        //[self addMaxPageView:self.number];
    }
    return self;
}
- (void)addMaxPageView:(NSInteger)page {
    for (int i = 0 ; i < page; i++) {
        CustomImageView *view = [[CustomImageView alloc] initWithFrame:CGRectMake(50*i+(i+1)*kSpeaceCGFloat, kSpaceHeight, 50, 50) type:deleteType];
        view.tag = i + 300;
        [_bgView addSubview:view];
        [_viewArr addObject:view];
    }
    self.bgScrollView.contentSize = CGSizeMake(50*(page-1)+page*kSpeaceCGFloat, 80);
}
- (void)deleteImageNow:(UIButton*)sender {
    
    NSInteger index = sender.tag - 700;
    CustomImageView *imageView = [self viewWithTag:index + 300];
    [imageView removeFromSuperview];
    ZLPhotoModel *model = self.modelArr[index];
    if (_deleteBlock) {
        self.deleteBlock(model,index);
    }
    [_viewArr removeObjectAtIndex:index];
    //[self addChooseImageViewWithArr:_viewArr];
}
- (void)addChooseImageViewWithArr:(NSArray*)arr {
    self.modelArr = arr;
    kWeakSelf(self);
    CustomImageView *nextView;
    if (self.viewArr.count != 0) {
        for (CustomImageView *view in _viewArr) {
            [view removeFromSuperview];
        }
    }
    if (arr.count <= 1) {
        return;
    }
    for (int a = 0 ; a < arr.count; a++) {
        CustomImageView *view = [[CustomImageView alloc] initWithFrame:CGRectZero type:deleteType];
        ZLPhotoModel *model = arr[a];
        view.model = model;
        [view upData];
        //view.backgroundColor = [UIColor greenColor];
        view.deleteButton.tag = 700 + a;
        [view.deleteButton addTarget:self action:@selector(deleteImageNow:) forControlEvents:UIControlEventTouchUpInside];
        [_viewArr addObject:view];
        [_bgView addSubview:view];
        view.tag = a + 300;
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            kStrongify(weakSelf);
            if (a == 0) {
                make.left.equalTo(strongSelf.bgView.mas_left).offset(kSpeaceCGFloat);
                make.top.equalTo(strongSelf.bgView.mas_top).offset(kSpeaceHight);
                make.bottom.equalTo(strongSelf.bgView.mas_bottom).offset(-kSpaceHeight);
            } else if (a == arr.count - 1) {
                make.left.equalTo(nextView.mas_right).offset(kSpeaceCGFloat);
                make.top.equalTo(nextView.mas_top);
                make.right.equalTo(strongSelf.bgView.mas_right).offset(-kSpeaceCGFloat);
            } else {
                make.left.equalTo(nextView.mas_right).offset(kSpeaceCGFloat);
                make.top.equalTo(nextView.mas_top);
                make.bottom.equalTo(nextView.mas_bottom);
            }
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        nextView = view;
    }
    [self layoutIfNeeded];
    [self setNeedsLayout];
    CGFloat indexHeight = _bgScrollView.bounds.size.height;
    self.bgScrollView.contentSize = CGSizeMake(_bgView.bounds.size.width, indexHeight);
}
-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *view = [super hitTest:point withEvent:event];
    if (view == nil) {
        for (UIView *subView in self.subviews) {
            CGPoint myPoint = [subView convertPoint:point fromView:self];
            if (CGRectContainsPoint(subView.bounds, myPoint)) {
                return subView;
            }
        }
    }
    return view;
}

- (UIScrollView*)bgScrollView {
    if (_bgScrollView == nil) {
        _bgScrollView = [[UIScrollView alloc] init];
        _bgScrollView.showsHorizontalScrollIndicator = NO;
        _bgScrollView.delegate = self;
        _bgScrollView.backgroundColor = [UIColor whiteColor];
    }
    return _bgScrollView;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    kWeakSelf(self);
    [_bgScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        kStrongify(weakSelf);
        make.edges.equalTo(strongSelf);
    }];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        kStrongify(weakSelf);
        make.left.equalTo(strongSelf.bgScrollView.mas_left);
        make.top.equalTo(strongSelf.bgScrollView.mas_top);
        make.bottom.equalTo(strongSelf.bgScrollView.mas_bottom);
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
