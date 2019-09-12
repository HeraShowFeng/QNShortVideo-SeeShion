//
//  comp_single_video_composite.h
//  compositor
//
//  Created by Zhiqiang Li on 15/12/1.
//  Copyright © 2015年 Zhiqiang Li. All rights reserved.
//

#include <UIKit/UIKit.h>
#import <CoreMedia/CoreMedia.h>

typedef enum
{
	VIDEO_EXPORT_PRESET_LOW,	// 低质量视频
	VIDEO_EXPORT_PRESET_MEDIUM, // 中等质量视频，建议默认使用这一项
	VIDEO_EXPORT_PRESET_HIGH,	// 高质量视频，文件较大
    VIDEO_EXPORT_PRESET_PASSTHROUGH
} SXVideoCompositorExportPreset;

@interface SXVideoCompositor : NSObject


/**
 初始化  
  
 @param input_video 输入视频的url  
 @param output_url 输出视频的url  
 @return SXVideoCompositor 实例  
 */
-(instancetype _Nullable) init:(NSURL * _Nonnull) input_video
						output:(NSURL * _Nonnull) output_url;

/**
 设置视频meta信息

 @param meta_string 信息内容
 */
-(void)setOutputMetaString:(NSString * _Nullable) meta_string;

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
 添加一个文件水印

 @param file 水印图片文件路径
 @param time_range 水印显示的时间区间
 */
-(void)addWatermark:(NSString *_Nonnull)file
          timeRange:(CMTimeRange) time_range;

/**
 添加个水印文件。这个方法会将水印添加到整个视频从开始到结尾

 @param file 水印图片文件路径
 */
-(void)addWatermark:(NSString * _Nonnull) file;

/**
 添加一个UIView作为水印

 @param view 要作为水印的UIView
 @param time_range 水印显示的时间段
 */
-(void)addViewWatermark:(UIView *_Nonnull)view
              timeRange:(CMTimeRange) time_range;

/**
 添加一个UIView作为水印，这个函数会将水印添加到整个视频从开始到结束

 @param view 要作为水印的UIView
 */
-(void)addViewWatermark:(UIView * _Nonnull) view;

/**
 添加一个音频轨道

 @param file 音频文件  
 @param start_time 音频在视频中的起点时间  
 @param time_range 要插入的音频时间段（这个时间段指的是音频文件的时间段，如，想截取音频文件的前1秒钟插入可传CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(1.0, 6000))）  
 @param volume 这段音频的音量 0~1  
 */
-(void)addMusic:(NSString *_Nonnull)file
      startTime:(CMTime)start_time
      timeRange:(CMTimeRange)time_range
         volume:(float) volume;

/**
 添加一个音频轨道

 @param file 音频文件（这个函数讲一个音频文件从第0秒开始添加到视频，结束时间以音频的长度和视频的长度中较短为准）
 */
-(void)addMusic:(NSString * _Nonnull) file;

/**
 添加一个重复音轨（所谓重复音轨就是说如果音频文件的长度不够长，后面的部分会重头开始复播）

 @param file 文件路径
 @param volume 音量
 */
-(void)addRepeatMusic:(NSString *_Nonnull)file volume:(float) volume;

/**
 添加一个重复音轨

 @param file 文件路径  
 @param timeRange 要插入的音频时间段（这个时间段指的是音频文件的时间段，如，想截取音频文件的前1秒钟插入可传CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(1.0, 6000))）  
 @param volume 音量  
 */
-(void)addRepeatMusic:(NSString *_Nonnull)file timeRange:(CMTimeRange)timeRange volume:(float) volume;

/**
 添加一个重复音轨
 
 @param file 文件路径
 @param videoTimeRange 音频在视频中的时间段
 @param musicTimeRange 要插入的音频时间段（这个时间段指的是音频文件的时间段，如，想截取音频文件的前1秒钟插入可传CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(1.0, 6000))）
 @param volume 音量
 */
-(void)addRepeatMusic:(NSString *_Nonnull)file videoTimeRange:(CMTimeRange)videoTimeRange musicTimeRange:(CMTimeRange)timeRange volume:(float) volume;
/**
 导出

 @param preset 导出质量预设  
 @param finishHandle 导出结束回调函数  
 */
-(void)finish:(SXVideoCompositorExportPreset)preset finishHandle:(void(^ _Nullable)(BOOL))finishHandle;

@end

