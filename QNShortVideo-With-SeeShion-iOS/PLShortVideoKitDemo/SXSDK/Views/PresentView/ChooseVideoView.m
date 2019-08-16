//
//  ChooseVideoView.m
//  CustomImagePickerController
//
//  Created by 李记波 on 2018/11/19.
//  Copyright © 2018年 李记波. All rights reserved.
//

#import "ChooseVideoView.h"


@interface ChooseVideoView ()


@end

@implementation ChooseVideoView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.isEdited = NO;
        _startTime = 0;
        _endTime = 20;
        self.isDraggingLeftOverlayView = NO;
        self.isDraggingRightOverlayView = NO;
        _imageScrollView = [[UIScrollView alloc] initWithFrame:frame];
        //_imageScrollView.delegate = self;
        _imageScrollView.showsVerticalScrollIndicator = NO;
        _imageScrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:self.imageScrollView];
        _conteView = [[UIView alloc] init];
        [self.imageScrollView addSubview:_conteView];
        kWeakSelf(self);
        [_imageScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            kStrongify(weakSelf);
            make.left.right.equalTo(strongSelf);
            make.top.equalTo(strongSelf.mas_top).offset(7);
            make.bottom.equalTo(strongSelf.mas_bottom).offset(-7);
        }];
        [_conteView mas_makeConstraints:^(MASConstraintMaker *make) {
            kStrongify(weakSelf);
            make.left.equalTo(strongSelf.imageScrollView.mas_left).offset(7.5 + 2);
            make.top.equalTo(strongSelf.imageScrollView.mas_top);
            make.bottom.equalTo(strongSelf.imageScrollView.mas_bottom);
        }];
    }
    return self;
}
- (void)addVideoImages:(NSArray*)imageArr {
    UIImageView *indexImageView;
    [self layoutIfNeeded];
    [self setNeedsLayout];
    _startPointX = 7.5 + 2;
    _endPointX = kScreen_Width - 15 - 4;
    self.indexHight = 60;
    self.indexWeith = (self.bounds.size.width - 15 - 4)/_needVedioTime;
    kWeakSelf(self);
    for (int a = 0; a < imageArr.count; a ++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = imageArr[a];
        imageView.tag = 500 + a;
        imageView.userInteractionEnabled = YES;
        [self.conteView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            kStrongify(weakSelf);
            if (a == 0) {
                make.left.equalTo(strongSelf.conteView.mas_left);
                
            } else {
                make.left.equalTo(indexImageView.mas_right);
            }
            make.top.equalTo(strongSelf.conteView.mas_top);
            make.size.mas_offset(CGSizeMake(strongSelf.indexWeith, strongSelf.indexHight));
            //make.bottom.equalTo(strongSelf.conteView.mas_bottom);
        }];
        indexImageView = imageView;
    }
    [self.conteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(indexImageView.mas_right).offset(5);
    }];
    [_conteView layoutIfNeeded];
    [_conteView setNeedsLayout];
    NSLog(@"zhegshi %f,%f",_conteView.frame.size.height,_conteView.frame.size.width);
    self.imageScrollView.contentSize = CGSizeMake(_conteView.frame.size.width + 19, _conteView.frame.size.height);
    
    //NSLog(@"%@",_conteView.frame);
    [self addChooseViews];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}
- (void)addChooseViews {
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.0];
    bgView.userInteractionEnabled = NO;
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 8;
    bgView.layer.borderWidth = 2.0f;
    bgView.layer.borderColor = [UIColor colorWithHexString:kYellowColor].CGColor;
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(7.5);
        make.right.equalTo(self.mas_right).offset(-7.5);
        make.top.bottom.equalTo(self);
    }];
    
    _boderX = 7.50;
    _boderWidth = kScreen_Width-15;
    _topBorder = [[UIView alloc] initWithFrame:CGRectZero];
    _topBorder.backgroundColor = [UIColor colorWithHexString:kYellowColor];
    [bgView addSubview:_topBorder];
//    _topBorder.backgroundColor = [UIColor colorWithHexString:kYellowColor];
//    _topBorder.layer.cornerRadius = 1;
//    [self addSubview:_topBorder];
    _bottomBorder = [[UIView alloc] initWithFrame:CGRectZero];
    _bottomBorder.backgroundColor = [UIColor colorWithHexString:kYellowColor];
    [bgView addSubview:_bottomBorder];
    [_topBorder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top);
        make.left.equalTo(bgView.mas_left).offset(1);
        make.right.equalTo(bgView.mas_right).offset(-1);
        make.height.mas_equalTo(@(7));
    }];
    [_bottomBorder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bgView.mas_bottom);
        make.left.equalTo(bgView.mas_left).offset(1);
        make.right.equalTo(bgView.mas_right).offset(-1);
        make.height.mas_equalTo(@(7));
    }];
//    _bottomBorder.backgroundColor = [UIColor colorWithHexString:kYellowColor];
//    [self addSubview:_bottomBorder];
//
//    _leftView = [[DragEditView alloc] initWithFrame:CGRectMake(-(kScreen_Width - 15), 0, kScreen_Width, _indexHight) left:YES];
//    _leftView.backgroundColor = [UIColor redColor];
//    _leftView.hitTestEdgeInsets = UIEdgeInsetsMake(0, -20.0, 0, -20.0);
//    [self addSubview:self.leftView];
//
//    _rightView = [[DragEditView alloc] initWithFrame:CGRectMake(kScreen_Width - 50, 0, kScreen_Width, _indexHight) left:NO];
//    _rightView.backgroundColor = [UIColor blueColor];
//    _rightView.hitTestEdgeInsets = UIEdgeInsetsMake(0, -20.0, 0, -20.0);
//    [self addSubview:self.rightView];
   
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
   // CGFloat offsetX = _imageScrollView.contentOffset.x;
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
