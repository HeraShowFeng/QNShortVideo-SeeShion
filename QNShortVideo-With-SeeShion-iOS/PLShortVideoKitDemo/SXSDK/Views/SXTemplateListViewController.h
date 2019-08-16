//
//  SXTemplateListViewController.h
//  SXEditDemo
//
//  Created by Yin Xie on 2018/12/18.
//  Copyright © 2018 Yin Xie. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SXTemplateListViewController : UIViewController
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSString *folderPath;
@property (nonatomic, copy)   NSString *navTitle;
@end

NS_ASSUME_NONNULL_END
