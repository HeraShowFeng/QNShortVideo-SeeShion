//
//  SXTextColorCollectionViewCell.m
//  SXEditDemo
//
//  Created by 李记波 on 2018/12/13.
//  Copyright © 2018年 Yin Xie. All rights reserved.
//

#import "SXTextColorCollectionViewCell.h"

@implementation SXTextColorCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.colorView = [[UIView alloc] init];
        self.colorView.layer.cornerRadius = 16;
        [self.contentView addSubview:self.colorView];
        
        self.selectView = [[UIView alloc] init];
        self.selectView.hidden = YES;
        self.selectView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        self.selectView.layer.cornerRadius = 16;
        [self.contentView addSubview:self.selectView];
        
        self.selectImageView = [[UIImageView alloc] init];
        self.selectImageView.image = [UIImage imageNamed:@"xzphoto_icon"];
        self.selectImageView.hidden = YES;
        [self.contentView addSubview:self.selectImageView];
        
        kWeakSelf(self);
        [self.colorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf.contentView);
        }];
        [self.selectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf.contentView);
        }];
        [self.selectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(weakSelf.contentView);
            make.size.mas_equalTo(CGSizeMake(10, 7));
        }];
        
    }
    return self;
}
- (void)setSelected:(BOOL)selected {
    self.selectView.hidden = selected ? NO : YES;
    self.selectImageView.hidden = selected ? NO : YES;
}

- (void)upDateWith:(NSDictionary*)dict {
    self.colorView.backgroundColor = [UIColor colorWithRed:[self getDictionaryObject:dict WithKey:@"r"] green:[self getDictionaryObject:dict WithKey:@"g"] blue:[self getDictionaryObject:dict WithKey:@"b"] alpha:1.0f];
}
- (CGFloat)getDictionaryObject:(NSDictionary*)dict WithKey:(NSString*)key {
    NSNumber* object = [dict objectForKey:key];
    CGFloat color = object.doubleValue / 255.0f;
    NSLog(@"这个值是%f",color);
    return color;
}
@end
