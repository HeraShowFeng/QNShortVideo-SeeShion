//
//  TextEditButton.h
//  ShiPinDemo
//
//  Created by 杨思宇 on 2017/11/9.
//  Copyright © 2017年 杨思宇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextEditButton : UIButton
@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, assign) NSInteger btnTag;
- (instancetype)initWithFrame:(CGRect)frame WithImgName:(NSString *)imgName;
@end
