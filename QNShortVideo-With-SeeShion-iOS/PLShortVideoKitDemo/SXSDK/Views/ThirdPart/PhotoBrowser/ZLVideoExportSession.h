//
//  ZLVideoExportSession.h
//  ShiPinDemo
//
//  Created by Zhiqiang Li on 08/11/2017.
//  Copyright © 2017 杨思宇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>

typedef enum
{
    VIDEO_EXPORT_PRESET_LOW,        // 低质量视频
    VIDEO_EXPORT_PRESET_MEDIUM,     // 中等质量视频
    VIDEO_EXPORT_PRESET_HIGH,       // 高质量视频，文件较大
} ZLVideoExportPreset;

@interface ZLVideoExportSession : NSObject


/**
 初始化
 
 @param input_video 输入视频的url
 @param output_url 输出视频的url
 @return ZLVideoExportSession 实例
 */
-(instancetype _Nullable) init:(NSString * _Nonnull) input_video
                        output:(NSString * _Nonnull) output_url;

/**
 初始化

 @param asset 输入视频的AVAsset
 @param output 输出视频的路径
 @return ZLVideoExportSession 实例
 */
-(instancetype _Nullable) initWithAsset:(AVAsset * _Nonnull) asset
                                 output:(NSString * _Nonnull) output;

/**
 设置输出的大小
 
 @param size 大小宽高
 */
-(void)setOutputSize:(CGSize) size;

/**
 设置输出的帧频
 
 @param frameRate 输出的帧频，应该大于0，并且小于等于视频实际的帧频
 */
-(void)setOutputFrameRate:(int)frameRate;

/**
 设置输出视频应用的transform
 @warning 注意，这里的transform坐标系是以左上角为坐标原点的，区别于UIView的transform
 
 @param transform CGAffineTransform
 */
-(void)setOutputTransform:(CGAffineTransform) transform;

/**
 设置输出的音量
 
 @param volume 音量 0~1
 */
-(void)setOutputVolume:(float) volume;

/**
 设置输出的时间区间
 
 @param range 时间区间
 */
-(void)setOutputRange:(CMTimeRange) range;

/**
 设置输入的视频自带音频的音量
 
 @param volume 音量 0~1
 */
-(void)setSourceVolume:(float) volume;

/**
 导出
 
 @param preset 导出质量预设
 @param finishHandle 导出结束回调函数
 */
-(void)finish:(ZLVideoExportPreset)preset finishHandle:(void(^ _Nullable)(BOOL))finishHandle;


@end
