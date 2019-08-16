//
//  MainSuperViewController.m
//  CustomImagePickerController
//
//  Created by 李记波 on 2018/12/7.
//  Copyright © 2018年 李记波. All rights reserved.
//

#import "MainSuperViewController.h"

@interface MainSuperViewController ()

@end

@implementation MainSuperViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden = YES;
    self.navbarView = [[UIView alloc] init];
    self.navbarView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.navbarView];
    
    self.titLabel = [[UILabel alloc] init];
    self.titLabel.font = [UIFont systemFontOfSize:14];
    self.titLabel.textColor = [UIColor blackColor];
    self.titLabel.textAlignment = NSTextAlignmentCenter;
    [self.navbarView addSubview:self.titLabel];
//    [self prefersStatusBarHidden];
//    [self performSelector:@selector(prefersStatusBarHidden)];
    
    self.leftImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.leftImageBtn setBackgroundImage:[UIImage imageNamed:@"return_icon"] forState:UIControlStateNormal];
    [self.leftImageBtn addTarget:self action:@selector(backView) forControlEvents:UIControlEventTouchUpInside];
    [self.navbarView addSubview:self.leftImageBtn];
    
    self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.leftBtn addTarget:self action:@selector(backView) forControlEvents:UIControlEventTouchUpInside];
    [self.leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.navbarView addSubview:self.leftBtn];
    
    UIImage *img = [UIImage imageNamed:@"return_icon"];
    UIImage *image = [UIImage imageWithCGImage:img.CGImage scale:2.0 orientation:UIImageOrientationDown];
    
    self.rightImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rightImageBtn setBackgroundImage:image forState:UIControlStateNormal];
    [self.rightImageBtn addTarget:self action:@selector(goToNextViewController) forControlEvents:UIControlEventTouchUpInside];
    self.rightImageBtn.hidden = YES;
    [self.rightImageBtn sizeToFit];
    [self.navbarView addSubview:self.rightImageBtn];
    
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rightBtn addTarget:self action:@selector(goToNextViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.rightBtn.hidden = YES;
    [self.navbarView addSubview:self.rightBtn];
    
    self.lineLabel = [[UILabel alloc] init];
    self.lineLabel.backgroundColor = [UIColor lightGrayColor];
    [self.navbarView addSubview:self.lineLabel];
    
    kWeakSelf(self);
    CGRect statusFrame = [[UIApplication sharedApplication] statusBarFrame];
    NSLog(@"这个是多少？%lf",statusFrame.size.height);
    [self.navbarView mas_makeConstraints:^(MASConstraintMaker *make) {
        kStrongify(weakSelf);
        make.left.equalTo(strongSelf.view.mas_left);
        make.right.equalTo(strongSelf.view.mas_right);
        make.top.equalTo(strongSelf.view.mas_top).offset(statusFrame.size.height);
        make.height.mas_equalTo(@(44));
    }];
    [self.leftImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        kStrongify(weakSelf);
        make.left.equalTo(strongSelf.navbarView.mas_left);
        make.top.equalTo(strongSelf.navbarView.mas_top);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        kStrongify(weakSelf);
        make.left.equalTo(strongSelf.leftImageBtn.mas_right);
        make.top.equalTo(strongSelf.leftImageBtn.mas_top);
        make.size.mas_equalTo(CGSizeMake(34, 44));
    }];
    [self.rightImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        kStrongify(weakSelf);
        make.right.equalTo(strongSelf.navbarView.mas_right);
        make.top.equalTo(strongSelf.navbarView.mas_top);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        kStrongify(weakSelf);
        make.right.equalTo(strongSelf.rightImageBtn.mas_left);
        make.top.equalTo(strongSelf.rightImageBtn.mas_top);
        make.size.mas_equalTo(CGSizeMake(50, 44));
    }];
    [self.titLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.navbarView.mas_centerX);
        make.top.equalTo(weakSelf.navbarView.mas_top);
        make.bottom.equalTo(weakSelf.navbarView.mas_bottom);
        make.width.mas_equalTo(@(150));
    }];
    [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.navbarView.mas_bottom);
        make.left.right.equalTo(weakSelf.navbarView);
        make.height.mas_equalTo(@(0.5));
    }];
}
- (void)backView {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)goToNextViewController {
}
//- (BOOL)prefersStatusBarHidden
//{
//    return YES;//隐藏为YES，显示为NO
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
