//
//  SXTemplatePlayer.h
//  SXVideoEnging
//
//  Created by Yin Xie on 2019/1/2.
//  Copyright © 2019 Zhiqiang Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SXTemplate.h"
NS_ASSUME_NONNULL_BEGIN

/**
 * SXTemplatePlayer播放进度委托
 */
@protocol SXTemplatePlayerDelegate <NSObject>
/**
 * 播放进度更新  
 * @param frameIndex 当前播放的帧序列号  
 */
- (void)playFrameIndex:(int)frameIndex;

@optional

/**
 录制失败回调
 
 @param error 错误信息
 @warning 当erro中userinfo包含request， 且为"/render/charge/cpt/confirm", 请记录路径和订单流水号(必须对应)，以便稍后调用decodeFile重新尝试输出视频文件
 渲染回调的文件如果不是直接再次导出，请注意保存该文件，不然可能会被覆盖
 
 */
- (void)recordFailed:(NSError *)error;

/**
 录制取消回调
 */
- (void)recordCancelled;

/**
 录制成功回调

 @param url 视频文件的路径
 */
- (void)recordSuccess:(NSURL *)url;
@end

/**
 * 配合SXTemplate对象对模板进行预览输出到屏幕
 */
@interface SXTemplatePlayer: NSObject

/**
 * 获取和设置当前播放的模板对象
 */
@property (nonatomic, strong) SXTemplate *sxTemplate;
/**
 * 播放状态委托
 */
@property (nonatomic, weak)   id<SXTemplatePlayerDelegate> delegate;

/**
 * 创建一个SXTemplatePlayer实例对象  
 * @param sxTemplate 需要预览的合成对象  
 * @param audioPath	背景音乐路径，可以为空  
 * @return 实例  
 */
- (instancetype)initWithTemplate:(SXTemplate *)sxTemplate audioPath:(NSString *)audioPath;

/**
 * 替换背景音乐  
 * @param audioPath 新的背景音乐文件路径  
 */
- (void)replaceAudio:(NSString *)audioPath;

/**
 * 开始预览  
 * @return 是否成功  
 */
- (BOOL)start;

/**
 * 暂停预览  
 * @return 是否成功  
 */
- (BOOL)pause;

/**
 * 停止预览  
 * @return 是否成功  
 */
- (BOOL)stop;

/**
 * 设置时间进度  
 * @param second 新的时间进度，秒为单位  
 * @return 是否设置成功  
 */
- (BOOL)seek:(float)second;

/**
 * 获取播放器所使用的视图对象  
 * @return UIView视图对象，获取到之后可以添加显示到界面上  
 */
- (UIView *)getPlayerView;


/**
 开始录制当前预览的界面
 */
- (void)startRecord;

/**
 取消本次录制
 */
- (void)cancelRecord;

/**
 结束录制当前预览的界面
 */
- (void)stopRecord;


/**
 是否正在录制

 @return YES为正在录制
 */
- (BOOL)isRecord;


/**
 已经录制的时长

 @return 录制时长(s)
 */
- (float)recordDuration;

- (NSArray *)getPreviewImages:(int)count;

/**
 录制文件导出失败后重试接口,参数由录制回调的错误中获得
 
 @param filePath 加密文件路径, 对应key - filePath
 @param orderSN 订单流水号, 对应key - orderSN
 @param featureString 订单功能, 对应key - featureString
 @param outputPath 解密文件输出路径
 @param completeHandler 完成回调
 
 @warning 一个订单对应一个加密文件，参数不要修改，不要用来解密其他文件，可能造成文件错误且扣费成功
 解压完成后不会删除原文件
 */
+ (void)decodeFile:(NSString *)filePath
           orderSN:(NSString *)orderSN
     featureString:(NSString *)featureString
        outputPath:(NSString *)outputPath
   completeHandler:(void (^)(NSError *))completeHandler;
@end

NS_ASSUME_NONNULL_END
