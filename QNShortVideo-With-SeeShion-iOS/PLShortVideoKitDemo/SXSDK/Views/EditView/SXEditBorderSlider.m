//
//  SXEditBorderSlider.m
//  SXEditDemo
//
//  Created by 李记波 on 2018/12/14.
//  Copyright © 2018年 Yin Xie. All rights reserved.
//

#import "SXEditBorderSlider.h"

@interface SXEditBorderSlider ()

@property (nonatomic, strong) UIButton *numberBtn;
@property (nonatomic, strong) UIView *thumbView;

@end

@implementation SXEditBorderSlider

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //self.backgroundColor = [UIColor redColor];
        [self addTarget:self action:@selector(changeValueNow:) forControlEvents:UIControlEventValueChanged];
    }
    return self;
}
- (void)setValueText:(NSString *)valueText {
    
    if (![_valueText isEqualToString:valueText]) {
        _valueText = valueText;
        
        [self.numberBtn setTitle:valueText forState:UIControlStateNormal];
        [self.numberBtn sizeToFit];
        self.numberBtn.center = CGPointMake(self.thumbView.bounds.size.width / 2, self.numberBtn.bounds.size.height/2 + self.thumbView.bounds.size.height + 4);
        
        if (!self.numberBtn.superview) {
            [self.thumbView addSubview:self.numberBtn];
        }
    }
}
- (void)setValue:(float)value animated:(BOOL)animated {
    
    [super setValue:value animated:animated];
    [self changeValueNow:self];
}

- (void)setValue:(float)value {
    
    [super setValue:value];
    [self changeValueNow:self];
}

- (UIView*)thumbView {
    NSLog(@"自试图有多少@%lu",(unsigned long)self.subviews.count);
    if (!_thumbView && self.subviews.count > 2) {
        _thumbView = self.subviews[2];
    }
    return _thumbView;
}
- (UIButton*)numberBtn {
    if (_numberBtn == nil) {
        _numberBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_numberBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _numberBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, -4, 0);
        [_numberBtn setBackgroundImage:[UIImage imageNamed:@"stroke_szbg"] forState:UIControlStateNormal];
        _numberBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _numberBtn;
}
- (void)changeValueNow:(UISlider*)sender {
    if (self.valueChanged) {
        self.valueChanged((SXEditBorderSlider*)sender);
    }
    self.valueText = [NSString stringWithFormat:@"%.1f",sender.value];
}

- (CGRect)trackRectForBounds:(CGRect)bounds {
    bounds = [super trackRectForBounds:bounds];
    return CGRectMake(bounds.origin.x, bounds.origin.y-1, bounds.size.width, 4);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
