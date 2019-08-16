//
//  SXTextEditFontView.h
//  SXEditDemo
//
//  Created by 李记波 on 2018/12/12.
//  Copyright © 2018年 Yin Xie. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SXTextEditFontView : UIView <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *fontArr;
@property (nonatomic, copy) void(^selectTextFontBlock)(NSString*);

- (void)upDateTableView;

@end

