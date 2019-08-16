//
//  VideoPreviewViewController.h
//  SXEditDemo
//
//  Created by 李记波 on 2019/1/14.
//  Copyright © 2019年 Yin Xie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"

NS_ASSUME_NONNULL_BEGIN

@interface VideoPreviewViewController : MainSuperViewController

@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) NSArray *imagePaths;

@end

NS_ASSUME_NONNULL_END
