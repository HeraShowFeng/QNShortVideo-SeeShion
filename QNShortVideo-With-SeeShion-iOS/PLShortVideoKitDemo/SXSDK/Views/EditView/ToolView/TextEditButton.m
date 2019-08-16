
//
//  TextEditButton.m
//  ShiPinDemo
//
//  Created by 杨思宇 on 2017/11/9.
//  Copyright © 2017年 杨思宇. All rights reserved.
//

#import "TextEditButton.h"

#define YSYImageNamed(imageName)  [UIImage imageNamed:imageName]

@interface TextEditButton()
@property (nonatomic, strong)UIImageView *imgView;
@property (nonatomic, strong)UIImageView *lineView;
@property (nonatomic, copy) NSString *imgName;
@end
@implementation TextEditButton

- (instancetype)initWithFrame:(CGRect)frame WithImgName:(NSString *)imgName
{
    self = [super initWithFrame:frame];
    if (self) {
        _imgName = imgName;
        [self creatSubViewWithFrame:frame];
        
    }
    return self;
}

-(void)creatSubViewWithFrame:(CGRect)frame{
    _imgView = [[UIImageView alloc] init];
    CGFloat imgV_W = CGRectGetWidth(frame)/2;
    _imgView.frame = CGRectMake(imgV_W/2, imgV_W/2, imgV_W, imgV_W);
    NSString *imgName = [NSString stringWithFormat:@"%@_un",_imgName];
    _imgView.image = YSYImageNamed(imgName);
    _imgView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_imgView];
    
    _lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(frame)-3, CGRectGetWidth(frame), 3)];
    _lineView.image = [UIImage imageNamed:@""];
    [self addSubview:_lineView];
    
}

-(void)setIsSelect:(BOOL)isSelect{
    if (isSelect) {
        NSString *imgName = [NSString stringWithFormat:@"%@_sel",_imgName];
        _imgView.image = YSYImageNamed(imgName);
        _lineView.image = YSYImageNamed(@"05_icon_progress_set");
    }else{
        NSString *imgName = [NSString stringWithFormat:@"%@_un",_imgName];
        _imgView.image = YSYImageNamed(imgName);
        _lineView.image = [UIImage imageNamed:@""];
    }
}
@end
