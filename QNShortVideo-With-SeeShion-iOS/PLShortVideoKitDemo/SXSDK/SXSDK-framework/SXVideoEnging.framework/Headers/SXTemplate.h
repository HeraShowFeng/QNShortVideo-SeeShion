//
//  SXTemplate.h
//  SXVideoEnging
//
//  Created by Yin Xie on 2019/1/5.
//  Copyright © 2019 Zhiqiang Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SXCamera.h"
#import "SXFilter.h"
NS_ASSUME_NONNULL_BEGIN

/**
 * 模板使用模式
 */
typedef enum : NSUInteger {
    SXTemplateUsagePreview,     // 该模板是用于实时预览的
    SXTemplateUsageRender,      // 该模板是用于渲染视频文件的
} SXTemplateUsage;

/**
 * 模板来源类型
 */
typedef enum : NSUInteger {
    SXTemplateSourceConfig,     //来源为模板文件
    SXTemplateSourceCamera,     //来源为摄像机
    SXTemplateSourceVideo,      //来源为视频文件
} SXTemplateSource;

/**
 * 模板对象类，负责读取模板文件内容，创建一个可使用的模板实例，并对模板内容进行自定义修改
 * @warning 注意，SXTemplate 对象遵循一次性使用原则，一旦提交给一个SXTemplatePlayer或者一个SXTemplateRender使用后
 * 			无法将其重复利用，使用完后应该立即释放销毁。如需再次使用，需要重新创建。创建速度极快，不会影响性能和用户体验
 */
@interface SXTemplate : NSObject

/**
 * 读取和设置模板的背景颜色
 * @warning 注意，设置背景颜色只能在commit之前调用
 */
@property (nonatomic, strong) UIColor *backgroundColor;

//是否包含原视频素材里的声音
@property (nonatomic, assign) BOOL isKeepAssetVoice;

@property (nonatomic, assign, readonly) SXTemplateUsage type;
@property (nonatomic, assign, readonly) SXTemplateSource source;
@property (nonatomic, strong, readonly) SXCamera *camera;

@property (nonatomic, copy, readonly) NSString *videoPath;
@property (nonatomic, copy, readonly) NSArray *replaceFilePaths;
//针对模板路径类型，检查路径合法性
@property (nonatomic, assign, readonly) BOOL isVaild;
//模板版本号
@property (nonatomic, strong, readonly) NSString *version;

/**
 获取当前VE引擎版本号
 可用来和template实例中的版本号作对比,模板是否被当前引擎全部支持
 
 @return 返回当前版本号
 */
+ (NSString *)getVECurrentVersion;

/**
 * 初始化一个模板实例
 * @param templateFolder 模板文件夹路径
 * @param type	该模板的使用模式。注意，这里设置完使用模式后模板的使用方式要和模式一直，不然不会生效
 * @return 模板实例
 */
-(instancetype) init:(NSString *)templateFolder type:(SXTemplateUsage)type;

/**
 * 初始化一个模板实例
 * @param camera 相机对象
 * @return 模板实例
 */
- (instancetype)initWithCamera:(SXCamera *)camera;

/**
 * 初始化一个模板实例
 * @param videoPath 视频文件夹路径
 * @param type    该模板的使用模式。注意，这里设置完使用模式后模板的使用方式要和模式一直，不然不会生效
 * @return 模板实例
 */
- (instancetype)initWithVideo:(NSString *)videoPath type:(SXTemplateUsage)type;

/**
 检测模板的 version 是否被当前引擎全部支持

 @return  1 表示模板版本高于引擎版本，不是完整支持， 返回 0， -1 表示可以完整支持
 */
- (int)compareWithCurrentVersion;

/**
 * 获取配置文件内记录的主视频合成宽度
 * @return 视频宽度，像素为单位，如果为0表示模板载入失败
 */
-(int) mainCompWidth;

/**
 * 获取配置文件内记录的主视频合成高度
 * @return 视频高度，像素为单位，如果为0表示模板载入失败
 */
-(int) mainCompHeight;

/**
 * 获取配置文件内记录的视频帧速率
 * @return 视频帧速率
 */
-(float) frameRate;

/**
 * 设置用户可修改素材文件路径  
 * @warning 该接口只有在commit之前调用有效  
 * @attention 	对于标准模板，这里设置的文件路径的顺序要和config.json内assets数组中素材的先后顺序保持一致  
 * 			对于动态模板，这里直接传入用户添加的所有主图片文件路径即可  
 * @param filePaths 替换素材文件路径的数组
 */
-(void) setReplaceableFilePaths:(NSArray<NSString*>*) filePaths;

/**
 设置用户可替换素材

 @param replaceJson 用户可替换素材,根据规范结构组成
 [规范参考http://www.seeshiontech.com/docs/page_103.html]
 */
-(void)setReplaceableJson:(NSString *)replaceJson;

/**
 * 根据UI key 来修改某个指定素材的文件路径  
 * @warning 该接口只有在commit之前调用有效  
 * @param filePath	新的文件路径  
 * @param uiKey		指定的UI key  
 * @return			是否修改成功  
 */
-(BOOL)setFile:(NSString *)filePath forUIKey:(NSString *)uiKey;

/**
 * 根据一个UI Key来获取config.json中记录的某个指定素材文件的配置信息  
 * @param uiKey	指定的UI key  
 * @return		该素材对应的配置信息  
 */
-(NSDictionary *)getAssetDataForUIKey:(NSString *)uiKey;

/**
 * 获取一个UI Key来获取config.json中记录的某个指定素材文件的附加信息  
 * @param uiKey	指定的UI key  
 * @return		该素材对应的附加信息  
 */
- (NSString *)getExtraDataForUIKey:(NSString *)uiKey;

/**
 commit模板配置信息，创建底层渲染对象

 @return 配置信息是否合法，返回NO为无效，请检查模板内容，后续操作无效
 */
- (BOOL)commit;

/**
 * 获取模板的真实时长  
 * @warning 该接口只有在commit之后调用有效  
 * @return	时长，帧为单位  
 */
- (int)realDuration;

/**
 * 根据UI key来获取所有匹配的合成对象  
 * @warning 该接口只有在commit之后调用有效  
 * @param uikey 	指定层UI key  
 * @return			所有匹配的合成对象  
 */
- (NSArray *)getCompsForUIKey:(NSString *)uikey;

/**
 * 对于动态模板，获取使用了某个指定素材文件的片段合成  
 * @warning 该接口只有在commit之后调用有效  
 * @param path	素材路径  
 * @return		使用了该素材的片段合成的id，可能为0  
 */
- (void *)segmentThatUsesFile:(NSString *)path;

/**
 * 替换某个片段合成中使用的素材文件为一个新的素材文件  
 * @warning 该接口只有在commit之后调用有效  
 * @param oldPath	目前正在使用的素材文件的路径  
 * @param newPath	要替换的新的素材文件的路径  
 * @param segment	指定层片段合成的id  
 * @return			是否替换成功  
 */
- (BOOL)replaceOldFile:(NSString *)oldPath withFile:(NSString *)newPath ForSegment:(void *)segment;

/**
 * 根据指定的UI Key获取一个片段合成中的某个指定的图层  
 * @warning 该接口只有在commit之后调用有效  
 * @param uiKey		指定的UI Key  
 * @param segment	指定层片段合成的id  
 * @return			查找到的图层的id，可能为空  
 */
- (void *)getLayerForUIKey:(NSString *)uiKey from:(void *)segment;

/**
 * 获取某个图层的附加数据  
 * @warning 该接口只有在commit之后调用有效  
 * @param layer	要获取的图层的id  
 * @return	附加数据内容  
 */
- (NSString *)getLayerExtraData:(void *)layer;

/**
 * 该图层是否启用（被启用的图层才会被渲染显示出来）  
 * @warning 该接口只有在commit之后调用有效  
 * @param layer	要查询的图层的ID  
 * @return		是否启用  
 */
- (BOOL)isLayerEnable:(void *)layer;

/**
 * 设置某个指定图层的启用状态  
 * @warning 该接口只有在commit之后调用有效  
 * @param layer	要设置的图层的ID  
 * @param isEnabled	是否启用  
 */
- (void)setLayer:(void *)layer isEnabled:(BOOL)isEnabled;

/**
 * 获取某个图层的尺寸，像素为单位  
 * @warning 该接口只有在commit之后调用有效  
 * @param layer	要获取的图层的id  
 * @return		图层尺寸  
 */
- (CGSize)getLayerSize:(void *)layer;

/**
 * 获取某个图层所使用的素材的配置json信息  
 * @warning 该接口只有在commit之后调用有效  
 * @param layer	要获取的图层的id  
 * @return		配置json字符串  
 */
- (NSString *)getLayerAssetJson:(void *)layer;

/**
 * 设置图层使用的素材路径  
 * @warning 该接口只有在commit之后调用有效  
 * @param layer	要设置的图层的ID  
 * @param path	新的素材的路径  
 * @return	是否设置成功  
 */
- (BOOL)setLayer:(void *)layer AVSource:(NSString *)path;

/**
 * 获取config.json的内容  
 * @return config.json的内容  
 */
-(NSString *) getConfig;

/**
  添加水印循环播放
 
 @warning 该接口只有在commit之后调用有效
          水印图片直接放在工程中需要设置compress png files以及remove text metadata from png files 为 NO
 
 @param imagePath 水印图片路径
 @param position 水印起始坐标，以左上角为原点
 @param scale 水印的缩放，默认值为1，以水印自身左上角为原点
 @param startTime 时间区间，以秒为单位
 @param duration duration = 0时，时长为视频时长
 @return 返回水印的ID
 */
- (NSString *)addWaterMark:(NSString *)imagePath position:(CGPoint)position scale:(CGSize)scale startTime:(CGFloat)startTime duration:(CGFloat)duration;

/**
  添加序列帧水印循环播放
 
 @warning 该接口只有在commit之后调用有效
          水印图片直接放在工程中需要设置compress png files以及remove text metadata from png files 为 NO
 
 @param imagePaths 水印序列帧路径
 @param position 水印起始坐标，以左上角为原点
 @param scale 水印的缩放，默认值为1，以水印自身左上角为原点
 @param startTime 时间区间，以秒为单位
 @param duration duration = 0时，时长为视频时长
 @return 返回水印的ID
 */
- (NSString *)addWaterMarks:(NSArray *)imagePaths position:(CGPoint)position scale:(CGSize)scale startTime:(CGFloat)startTime duration:(CGFloat)duration;

/**
 删除水印
 
 @param watermarkId 水印ID
 */
- (void)removeWaterMark:(NSString *)watermarkId;

/**
 强制替换一个滤镜

 @param filter 需要替换上的滤镜对象
 */
- (void)setFilter:(SXFilter *)filter;

/**
 预加载一个滤镜，为动态滤镜切换做准备。
 同一时间最多只有一个正在使用的滤镜,同方向上只有一个预加载的滤镜。

 @param filter 需要预加载的滤镜
 @param direction 预加载的滤镜方向
 */
- (void)preloadFilter:(SXFilter *)filter direction:(SXFilterTransitDirection)direction;

/**
 过渡到目前已经预加载的滤镜。

 @param progress 滤镜切换进度
 @param direction 滤镜切换方向
 */
- (void)transitToFilter:(float)progress direction:(SXFilterTransitDirection)direction;

/**
 设置附加素材数组
 @warning 该接口只有在commit之后调用有效 
 @param infoArray 附加素材数组
 */
- (void)setDynamicSubFiles:(NSArray *)infoArray;

/**
 设置附加文字素材数组
 @warning 该接口只有在commit之后调用有效
 @param infoArray 附加文字素材数组
 */
- (void)setDynamicSubTexts:(NSArray *)infoArray;
@end

NS_ASSUME_NONNULL_END
