//
//  SXTextFontTableViewCell.m
//  SXEditDemo
//
//  Created by 李记波 on 2018/12/12.
//  Copyright © 2018年 Yin Xie. All rights reserved.
//

#import "SXTextFontTableViewCell.h"

@interface SXTextFontTableViewCell ()

@property (nonatomic, strong) UIImageView *rightImageView;

@end

@implementation SXTextFontTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //self.backgroundColor = [UIColor blackColor];
        self.contentView.backgroundColor = [UIColor blackColor];
        self.rightImageView = [[UIImageView alloc] init];
        self.rightImageView.image = [UIImage imageNamed:@"colour_xz_icon"];
        self.rightImageView.layer.masksToBounds = YES;
        self.rightImageView.layer.cornerRadius = 10;
        self.rightImageView.layer.borderWidth = 1.0f;
        self.rightImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        [self.contentView addSubview:self.rightImageView];
        kWeakSelf(self);
        [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.contentView.mas_centerY);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-15);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        UILabel *line = [[UILabel alloc] init];
        line.backgroundColor = [UIColor colorWithHexString:kGreyishColor];
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(weakSelf.contentView);
            make.bottom.equalTo(weakSelf.contentView.mas_bottom);
            make.height.mas_equalTo(1);
        }];
    }
    return self;
}
- (void)upDateWithText:(NSString*)textStr {
    self.textLabel.text = textStr;
    self.textLabel.font = [UIFont fontWithName:textStr size:14];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        self.contentView.backgroundColor = [UIColor colorWithHexString:kGreyishColor];
    } else {
        self.contentView.backgroundColor = [UIColor blackColor];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.rightImageView.layer.borderColor = kMainColor.CGColor;
        self.textLabel.textColor = kMainColor;
        self.rightImageView.image = [UIImage imageNamed:@"font_xz_icon"];
        self.contentView.backgroundColor = [UIColor colorWithHexString:kGreyishColor];
    } else {
        self.rightImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        self.textLabel.textColor = [UIColor whiteColor];
        self.rightImageView.image = [UIImage imageNamed:@"colour_xz_icon"];
        self.contentView.backgroundColor = [UIColor blackColor];
    }

    // Configure the view for the selected state
}

@end
