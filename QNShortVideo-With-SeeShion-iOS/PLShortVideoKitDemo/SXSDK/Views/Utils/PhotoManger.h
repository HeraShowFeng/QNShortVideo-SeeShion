//
//  PhotoManger.h
//  CustomImagePickerController
//
//  Created by 李记波 on 2018/11/13.
//  Copyright © 2018年 李记波. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Header.h"
NS_ASSUME_NONNULL_BEGIN

@interface PhotoManger : NSObject


+ (void)getPhotoAblumList:(BOOL)allowSelectVideo allowSelectImage:(BOOL)allowSelectImage complete:(void (^)(NSArray<ZLAlbumListModel *> *))complete;

+ (ZLAlbumListModel *)getAlbumModeWithTitle:(NSString *)title result:(PHFetchResult<PHAsset *> *)result allowSelectVideo:(BOOL)allowSelectVideo allowSelectImage:(BOOL)allowSelectImage;

+ (PHImageRequestID)requestImageForAsset:(PHAsset *)asset size:(CGSize)size resizeMode:(PHImageRequestOptionsResizeMode)resizeMode completion:(void (^)(UIImage *, NSDictionary *))completion;
/**
 * @brief 获取原图
 */
+ (void)requestOriginalImageForAsset:(PHAsset *)asset completion:(void (^)(UIImage *, NSDictionary *))completion;
/**
 * @brief 根据传入size获取图片
 */
+ (PHImageRequestID)requestImageForAsset:(PHAsset *)asset size:(CGSize)size completion:(void (^)(UIImage *, NSDictionary *))completion;

+ (void)requestOriginalImageDataForAsset:(PHAsset *)asset completion:(void (^)(NSData *, NSDictionary *))completion;

+ (float)sd_frameDurationAtIndex:(NSUInteger)index source:(CGImageSourceRef)source;

/**
 * @brief 获取视频
 */
+ (void)requestVideoForAsset:(PHAsset *)asset completion:(void (^)(AVPlayerItem *item, NSDictionary *info))completion;

+ (void)analysisEverySecondsImageForAsset:(PHAsset *)asset interval:(NSTimeInterval)interval size:(CGSize)size complete:(void (^)(AVAsset *, NSArray<UIImage *> *))complete;

+ (void)analysisAVAsset:(AVAsset *)asset interval:(NSTimeInterval)interval size:(CGSize)size complete:(void (^)(AVAsset *, NSArray<UIImage *> *))complete;

+ (UIImage *)scaleImage:(UIImage *)image original:(BOOL)original;

+ (void)requestSelectedImageForAsset:(ZLPhotoModel *)model isOriginal:(BOOL)isOriginal allowSelectGif:(BOOL)allowSelectGif completion:(void (^)(UIImage *, NSDictionary *))completion;

@end

NS_ASSUME_NONNULL_END
