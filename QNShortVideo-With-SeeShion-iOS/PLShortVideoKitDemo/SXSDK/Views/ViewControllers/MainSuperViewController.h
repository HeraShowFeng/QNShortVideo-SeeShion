//
//  MainSuperViewController.h
//  CustomImagePickerController
//
//  Created by 李记波 on 2018/12/7.
//  Copyright © 2018年 李记波. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"


@interface MainSuperViewController : UIViewController

@property (nonatomic, strong) UIView *navbarView;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *leftImageBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UIButton *rightImageBtn;
@property (nonatomic, strong) UILabel  *titLabel;
@property (nonatomic, strong) UILabel  *lineLabel;

- (void)backView;
- (void)goToNextViewController;

@end

