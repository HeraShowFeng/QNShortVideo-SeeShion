//
//  CustomImageView.m
//  CustomImagePickerController
//
//  Created by 李记波 on 2018/11/12.
//  Copyright © 2018年 李记波. All rights reserved.
//

#import "CustomImageView.h"
#import <Masonry.h>
#import "SXUICalculateUtil.h"

@implementation CustomImageView

- (instancetype)initWithFrame:(CGRect)frame type:(ViewCellType)type {
    self = [super initWithFrame:frame];
    if (self) {
        self.viewType = type;
    
        [self addSubview:self.bgImageView];
        [self addSubview:self.deleteButton];
        [self addSubview:self.timeLabel];
        [self addSubview:self.chooseView];
        [self addSubview:self.chooseImageView];
        [self addSubview:self.chooseLabel];
        
        __block UIView * view = self;
        [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(view);
        }];
        [self.chooseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view.mas_top);
            make.right.equalTo(view.mas_right);
            make.size.mas_equalTo(CGSizeMake(16, 16));
        }];
        [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(view.mas_right).with.offset(5);
            make.top.equalTo(view.mas_top).with.offset(-5);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view.mas_left);
            make.bottom.equalTo(view.mas_bottom);
            make.right.equalTo(view.mas_right);
            make.height.mas_equalTo(20);
        }];
        [self.chooseView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(view);
        }];
        [self.chooseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(view);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
    };
    return self;
}
- (void)upData {
    switch (self.viewType) {
        case chooseType:{
            self.deleteButton.hidden = YES;
            if (self.model.selected) {
                self.chooseLabel.hidden = NO;
                self.chooseImageView.hidden = NO;
                self.chooseView.hidden = NO;
            } else {
                [self hiddenView];
            }
        }
            break;
        case deleteType: {
            self.deleteButton.hidden = NO;
            [self hiddenView];
        }
            break;
        default:
            break;
    }
    if (self.model.type == ZLAssetMediaTypeVideo) {
        self.timeLabel.hidden = NO;
        self.timeLabel.text = self.model.duration;
    } else {
        self.timeLabel.hidden = YES;
    }
    kWeakSelf(self);
    self.chooseLabel.text = [NSString stringWithFormat:@"%ld",_model.indexPath];
    [self.bgImageView layoutIfNeeded];
    [PhotoManger requestImageForAsset:self.model.asset size:[SXUICalculateUtil getImageSizeWithImageView:self.bgImageView] completion:^(UIImage * _Nonnull imgae, NSDictionary * _Nonnull info) {
        weakSelf.bgImageView.image = imgae;
    }];
}
- (void)hiddenView{
    self.chooseLabel.hidden = YES;
    self.chooseImageView.hidden = YES;
    self.chooseView.hidden = YES;
}
//-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
//{
//    UIView *view = [super hitTest:point withEvent:event];
//    if (view == nil) {
//        for (UIView *subView in self.subviews) {
//            CGPoint myPoint = [subView convertPoint:point fromView:self];
//            if (CGRectContainsPoint(subView.bounds, myPoint)) {
//                return subView;
//            }
//        }
//    }
//    return view;
//}

- (UILabel*)chooseLabel {
    if (_chooseLabel == nil) {
        _chooseLabel = [[UILabel alloc] init];
        _chooseLabel.backgroundColor = [UIColor colorWithHexString:kYellowColor];
        _chooseLabel.textColor = [UIColor blackColor];
        _chooseLabel.font = [UIFont systemFontOfSize:12];
        _chooseLabel.textAlignment = NSTextAlignmentCenter;
        _chooseLabel.adjustsFontSizeToFitWidth = YES;
        //_chooseLabel.layer.cornerRadius = 10;
        //_chooseLabel.layer.masksToBounds = YES;
        _chooseLabel.hidden = YES;
    }
    return _chooseLabel;
}
- (UIButton*) deleteButton {
    if (_deleteButton == nil) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setBackgroundImage:[UIImage imageNamed:@"delphoto_icon"] forState:UIControlStateNormal];
        _deleteButton.hidden = YES;
        
    }
    return _deleteButton;
}
- (UIImageView*) bgImageView {
    if (_bgImageView == nil) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.userInteractionEnabled = YES;
        _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
        _bgImageView.clipsToBounds = YES;
    }
    return _bgImageView;
}
- (UILabel*)timeLabel {
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.numberOfLines = 1;
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.font = [UIFont systemFontOfSize:10];
        _timeLabel.hidden = YES;
    }
    return _timeLabel;
}
- (UIView*)chooseView {
    if (_chooseView == nil) {
        _chooseView = [[UIView alloc] init];
        _chooseView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        _chooseView.hidden = YES;
    }
    return _chooseView;
}
- (UIImageView*)chooseImageView {
    if (_chooseImageView == nil) {
        _chooseImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xzphoto_icon"]];
        _chooseImageView.userInteractionEnabled = YES;
        _chooseImageView.hidden = YES;
    }
    return _chooseImageView;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
