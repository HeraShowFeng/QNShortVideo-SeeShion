//
//  SXTemplateRender.h
//  SXVideoEnging
//
//  Created by Zhiqiang Li on 2018/11/27.
//  Copyright © 2018 Zhiqiang Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SXTemplate.h"
NS_ASSUME_NONNULL_BEGIN

/**
 * SXTemplateRender 渲染状态委托
 */
@protocol SXTemplateRenderDelegate <NSObject>
/**
 * 渲染开始
 */
-(void) templateRenderStarted;
/**
 * 渲染结束  
 * @param tempUrl 结果文件路径  
 */
-(void) templateRenderFinished:(NSURL *)tempUrl;
/**
 * 渲染被取消
 */
-(void) templateRenderCancelled;

/**
 渲染失败

 @param error 错误信息
 @warning 当erro中userinfo包含request， 且为"/render/charge/cpt/confirm", 请记录路径和订单流水号(必须对应)，以便稍后调用decodeFile重新尝试输出视频文件
          渲染回调的文件如果不是直接再次导出，请注意保存该文件，不然可能会被覆盖
 */
-(void) templateRenderFailed:(NSError *)error;
/**
 * 渲染进度更新  
 * @param progress 渲染进度，0~1  
 */
-(void) templateRenderProgress:(float) progress;

@end

/**
 * 配合SXTemplate对象对模板进行渲染输出到视频文件  
 * @warning 注意，SXTemplateRender 对象遵循一次性使用原则，一次渲染任务结束后需要销毁，无法重复使用，如需再次使用，需要重新创建  
 * 			 SXTemplateRender 对象比较消耗内存，使用完毕后请立即销毁  
 */
@interface SXTemplateRender : NSObject

/**
 * 渲染状态委托
 */
@property (nonatomic, weak)   id<SXTemplateRenderDelegate> delegate;

/**
 * 获取和设置当前渲染使用的模板对象
 */
@property (nonatomic, strong) SXTemplate *sxTemplate;

/**
 * 获取和设置当前渲染输出的文件路径
 */
@property (nonatomic, copy)   NSString *outputPath;

/**
 * 获取和设置当前编码器的比特率系数，默认值为0.25  
 * @attention 编码器的比特率计算公式为 width * height * framerate * bpp  
 */
@property (nonatomic, assign) float bpp;

/**
 * 创建一个模板渲染管理对象实例  
 * @param sxTemplate	渲染使用的模板对象  
 * @param audioPath		背景音乐文件路径  
 * @return	实例  
 */
- (instancetype)initWithTemplate:(SXTemplate *)sxTemplate audioPath:(NSString *)audioPath;

/**
 * 开始渲染  
 * @return 是否开始成功  
 */
-(BOOL) start;

/**
 * 取消渲染
 */
-(void) cancel;

/**
 按次收费文件导出失败后重试接口,参数由渲染回调的错误中获得

 @param filePath 加密文件路径, 对应key - filePath
 @param orderSN 订单流水号, 对应key - orderSN
 @param outputPath 解密文件输出路径
 @param completeHandler 完成回调
 
 @warning 一个订单对应一个加密文件，不要用来解密其他文件，可能造成文件错误且扣费成功
          解压完成后不会删除原文件
 */
+ (void)decodeFile:(NSString *)filePath
           orderSN:(NSString *)orderSN
        outputPath:(NSString *)outputPath
   completeHandler:(void (^)(NSError *))completeHandler;
@end

NS_ASSUME_NONNULL_END
