//
//  Header.h
//  CustomImagePickerController
//
//  Created by 李记波 on 2018/11/15.
//  Copyright © 2018年 李记波. All rights reserved.
//

#ifndef Header_h
#define Header_h

#import "ZLProgressHUD.h"
//#import "UIColor+Addation.h"
#import <Masonry.h>
#import <Photos/Photos.h>
#import "ZLPhotoModel.h"
#import "PhotoManger.h"
#import "MainSuperViewController.h"
#import <SXVideoEnging/SXVideoEnging.h>


#define kSpaceHeight 5
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kViewHeight ([UIScreen mainScreen].bounds.size.width - (kSpaceHeight*3))/4
#define kMaxImageWidth 500
#define kMaxPage 9
#define kWeakSelf(var) __weak typeof(self) weakSelf = var
#define kStrongify(var) __strong typeof(var) strongSelf = var
#define kNumberText(a,b) [NSString stringWithFormat:@"已选择%lu张(最多选%d张)",a,b]
#define kSpeaceCGFloat 15
#define kSpeaceHight 15
#define kIsiOS11 @available(iOS 11.0,*)
#define kScreen_Width [UIScreen mainScreen].bounds.size.width
#define kYellowColor @"ffe131"
#define kGreyishColor @"1a1a1a"
#define kSelectMaskColor @"7cccff"
#define kEditorVideoNotification @"editorVideoNotification"
#define kEditorVideoKey @"VideoPath"
#define kEditorVideoFirstImage @"FirstImage"


typedef void(^MyBlock)(ZLPhotoModel*,NSInteger);

typedef enum _viewCellType {
    chooseType = 0,
    deleteType
    
} ViewCellType;


#endif /* Header_h */
