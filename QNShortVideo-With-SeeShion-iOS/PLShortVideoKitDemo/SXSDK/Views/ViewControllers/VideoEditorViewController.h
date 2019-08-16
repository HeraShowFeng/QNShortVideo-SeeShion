//
//  VideoEditorViewController.h
//  CustomImagePickerController
//
//  Created by 李记波 on 2018/11/15.
//  Copyright © 2018年 李记波. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"
#import "ChooseVideoView.h"

NS_ASSUME_NONNULL_BEGIN


@interface VideoEditorViewController : MainSuperViewController

@property (nonatomic, strong) ZLPhotoModel *model;
@property (nonatomic, assign) CGFloat videoNeedTime;
@property (nonatomic, assign) CGFloat needVideoHeight;
@property (nonatomic, assign) CGFloat needVideoWeight;
@property (nonatomic, copy) void(^editVideoBlock)(BOOL,NSString*);

@end

NS_ASSUME_NONNULL_END
