//
//  AllAblumViewController.h
//  CustomImagePickerController
//
//  Created by 李记波 on 2018/11/15.
//  Copyright © 2018年 李记波. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"

typedef void(^BackBlock)(ZLAlbumListModel*);

NS_ASSUME_NONNULL_BEGIN

@interface AllAblumViewController : MainSuperViewController

@property (nonatomic, assign) BOOL allowSelectVideo;
@property (nonatomic, assign) BOOL allowSelsctImage;
@property (nonatomic, copy) BackBlock backeBlcok;

- (void)backViewWith:(BackBlock)block;

@end

NS_ASSUME_NONNULL_END
