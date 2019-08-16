//
//  SXPinTuAssetModel.m
//  ShiPinDemo
//
//  Created by Zhiqiang Li on 07/11/2017.
//  Copyright © 2017 杨思宇. All rights reserved.
//

#import "SXPinTuAssetModel.h"
#import "SXTextLayoutView.h"
#import "ZLPhotoActionSheet.h"
@interface SXPinTuAssetModel()
{
    PinTuAssetType mAssetType;
}
@property(nonatomic, strong) NSMutableArray<UIImage*> * mAssetImages;
@property(nonatomic, strong) SXTextLayoutView * mSXTextLayoutView;
@property(nonatomic, strong) NSNumber * mMute;
@end

@implementation SXPinTuAssetModel

+(void) refreshAssetFolder
{
    NSString * path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"TempFolder"];
    [[SXFileManager shared] createDirectoryForPath:path];
}

+(NSString *) assetFolder
{
    return [NSTemporaryDirectory() stringByAppendingPathComponent:@"TempFolder"];
}

+(NSString *) generateRandomNamedFileWithExtension:(NSString *) extension
{
    NSString *str = [[SXCommonUtil getTimeMarkString] stringByAppendingString:[SXCommonUtil getRandomNumber:@"1" to:@"1000"]];
    NSString *imageID = [[[NSUUID UUID] UUIDString] stringByAppendingString:str];
    return [[SXPinTuAssetModel assetFolder] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@", imageID, extension]];
}


+(ZLPhotoActionSheet *) createBasicPhotoTool
{
    ZLPhotoActionSheet  *actionSheet = [[ZLPhotoActionSheet  alloc] init];
    actionSheet.allowSelectOriginal = NO;
    actionSheet.allowEditImage = NO;
    actionSheet.allowEditVideo = NO;
    actionSheet.navBarColor = [UIColor blackColor];
    actionSheet.sortAscending = NO;
    actionSheet.bottomBtnsNormalTitleColor = [UIColor colorWithRed:1.0 green:119.0 / 255.0 blue:51.0 / 255.0 alpha:1.0];
    return actionSheet;
}

+(void) pickMultipleMediaAsset:(UIViewController*) sender amount:(NSUInteger) amount callback:(MultiAssetsPickCallback) callback
{
    ZLPhotoActionSheet * tool = [SXPinTuAssetModel createBasicPhotoTool];
    tool.sender = sender;
    tool.maxSelectCount = amount;
    [tool setSelectImageBlock:^(NSArray<UIImage *> * _Nullable images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
        NSMutableArray *mediaPaths = [NSMutableArray array];//视频路径
        NSString * placeHolder = @"";
        for (NSUInteger i = 0; i < images.count; i++)
        {
            [mediaPaths addObject:placeHolder];
        }
        
        for (int i = 0; i < assets.count; i++) {
            PHAsset *phAsset = assets[i];
            if (phAsset.mediaType == PHAssetMediaTypeVideo) {
                PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
                PHImageManager *manager = [PHImageManager defaultManager];
                [manager requestAVAssetForVideo:phAsset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
                    AVURLAsset *urlAsset = (AVURLAsset *)asset;
                    NSURL *url = urlAsset.URL;
                    NSString *lastStr = [[[url absoluteString] componentsSeparatedByString:@"."] lastObject];
                    NSData *data = [NSData dataWithContentsOfURL:url];
                    NSString *path = [SXPinTuAssetModel generateRandomNamedFileWithExtension:[NSString stringWithFormat:@".%@",lastStr]];
                    //写入
                    [data writeToFile:path atomically:YES];
                    [mediaPaths replaceObjectAtIndex:i withObject:path];
                    if (![mediaPaths containsObject:placeHolder])
                    {
                        callback(images, mediaPaths);
                    }
                }];
            }else if (phAsset.mediaType == PHAssetMediaTypeImage){
                UIImage *img = images[i];
                NSData *data = UIImageJPEGRepresentation(img, 0.5);
                NSString *path = [SXPinTuAssetModel generateRandomNamedFileWithExtension:@".jpg"];
                //写入
                [data writeToFile:path atomically:YES];
                [mediaPaths replaceObjectAtIndex:i withObject:path];
                
                if (![mediaPaths containsObject:placeHolder])
                {
                    callback(images, mediaPaths);
                }
            }
        }
    }];
    [tool showPhotoLibrary];
}

+(void) pickSingleMediaAsset:(UIViewController*) sender callback:(AssetPickCallback) callback
{
    ZLPhotoActionSheet * tool = [SXPinTuAssetModel createBasicPhotoTool];
    tool.sender = sender;
    tool.maxSelectCount = 1;
    [tool setSelectImageBlock:^(NSArray<UIImage *> * _Nullable images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
        NSMutableArray *mediaPaths = [NSMutableArray array];//视频路径
        NSString * placeHolder = @"";
        for (NSUInteger i = 0; i < images.count; i++)
        {
            [mediaPaths addObject:placeHolder];
        }
        
        for (int i = 0; i < assets.count; i++) {
            PHAsset *phAsset = assets[i];
            if (phAsset.mediaType == PHAssetMediaTypeVideo) {
                PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
                PHImageManager *manager = [PHImageManager defaultManager];
                [manager requestAVAssetForVideo:phAsset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
                    AVURLAsset *urlAsset = (AVURLAsset *)asset;
                    NSURL *url = urlAsset.URL;
                    NSString *lastStr = [[[url absoluteString] componentsSeparatedByString:@"."] lastObject];
                    NSData *data = [NSData dataWithContentsOfURL:url];
                    NSString *path = [SXPinTuAssetModel generateRandomNamedFileWithExtension:[NSString stringWithFormat:@".%@",lastStr]];
                    //写入
                    [data writeToFile:path atomically:YES];
                    [mediaPaths replaceObjectAtIndex:i withObject:path];
                    if (![mediaPaths containsObject:placeHolder])
                    {
                        callback(images.firstObject, mediaPaths.firstObject);
                    }
                }];
            }else if (phAsset.mediaType == PHAssetMediaTypeImage){
                UIImage *img = images[i];
                NSData *data = UIImageJPEGRepresentation(img, 0.5);
                NSString *path = [SXPinTuAssetModel generateRandomNamedFileWithExtension:@".jpg"];
                //写入
                [data writeToFile:path atomically:YES];
                [mediaPaths replaceObjectAtIndex:i withObject:path];
                
                if (![mediaPaths containsObject:placeHolder])
                {
                    callback(images.firstObject, mediaPaths.firstObject);
                }
            }
        }
    }];
    [tool showPhotoLibrary];
}

+(void) pickSinglePictureAsset:(UIViewController*) sender callback:(AssetPickCallback) callback
{
    ZLPhotoActionSheet * tool = [SXPinTuAssetModel createBasicPhotoTool];
    tool.sender = sender;
    tool.maxSelectCount = 1;
    tool.allowSelectVideo = NO;
    [tool setSelectImageBlock:^(NSArray<UIImage *> * _Nullable images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
        NSMutableArray *mediaPaths = [NSMutableArray array];//视频路径
        NSString * placeHolder = @"";
        for (NSUInteger i = 0; i < images.count; i++)
        {
            [mediaPaths addObject:placeHolder];
        }
        
        for (int i = 0; i < assets.count; i++) {
            PHAsset *phAsset = assets[i];
            if (phAsset.mediaType == PHAssetMediaTypeVideo) {
                PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
                PHImageManager *manager = [PHImageManager defaultManager];
                [manager requestAVAssetForVideo:phAsset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
                    AVURLAsset *urlAsset = (AVURLAsset *)asset;
                    NSURL *url = urlAsset.URL;
                    NSData *data = [NSData dataWithContentsOfURL:url];
                    NSString *path = [SXPinTuAssetModel generateRandomNamedFileWithExtension:@".mp4"];
                    //写入
                    [data writeToFile:path atomically:YES];
                    [mediaPaths replaceObjectAtIndex:i withObject:path];
                    if (![mediaPaths containsObject:placeHolder])
                    {
                        callback(images.firstObject, mediaPaths.firstObject);
                    }
                }];
            }else if (phAsset.mediaType == PHAssetMediaTypeImage){
                UIImage *img = images[i];
                NSData *data = UIImageJPEGRepresentation(img, 0.5);
                NSString *path = [SXPinTuAssetModel generateRandomNamedFileWithExtension:@".jpg"];
                //写入
                [data writeToFile:path atomically:YES];
                [mediaPaths replaceObjectAtIndex:i withObject:path];
                
                if (![mediaPaths containsObject:placeHolder])
                {
                    callback(images.firstObject, mediaPaths.firstObject);
                }
            }
        }
    }];
    [tool showPhotoLibrary];
}

+(void) pickMultiplePictureAsset:(UIViewController*) sender amount:(NSUInteger) amount callback:(MultiAssetsPickCallback) callback
{
    ZLPhotoActionSheet * tool = [SXPinTuAssetModel createBasicPhotoTool];
    tool.sender = sender;
    tool.maxSelectCount = amount;
    tool.allowSelectVideo = NO;
    [tool setSelectImageBlock:^(NSArray<UIImage *> * _Nullable images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
        NSMutableArray *mediaPaths = [NSMutableArray array];//视频路径
        NSString * placeHolder = @"";
        for (NSUInteger i = 0; i < images.count; i++)
        {
            [mediaPaths addObject:placeHolder];
        }
        
        for (int i = 0; i < assets.count; i++) {
            UIImage *img = images[i];
            NSData *data = UIImageJPEGRepresentation(img, 0.5);
            NSString *path = [SXPinTuAssetModel generateRandomNamedFileWithExtension:@".jpg"];
            [data writeToFile:path atomically:YES];
            [mediaPaths replaceObjectAtIndex:i withObject:path];
            
            if (![mediaPaths containsObject:placeHolder])
            {
                callback(images, mediaPaths);
            }
        }
    }];
    [tool showPhotoLibrary];
}

+(instancetype) textAssetWithSXTextLayoutView:(SXTextLayoutView *) view
{
    SXPinTuAssetModel * model = [[SXPinTuAssetModel alloc] initWithType:kTextAsset];
    [model setSXTextLayoutView:view];
    return model;
}

+(instancetype) mediaAssetWithFile:(NSString *) file image:(UIImage *) image
{
    SXPinTuAssetModel * model = [[SXPinTuAssetModel alloc] initWithType:kSingleMediaAsset];
    [model addFile:file with:image];
    return model;
}

+(instancetype) slideAssetWithFiles:(NSArray<NSString *>*) files images:(NSArray<UIImage *>*) images
{
    SXPinTuAssetModel * model = [[SXPinTuAssetModel alloc] initWithType:kPictureSlideAsset];
    for (size_t i = 0 ; i < files.count && i < images.count; i++)
    {
        [model addFile:files[i] with:images[i]];
    }
    return model;
}


-(instancetype) initWithType:(PinTuAssetType) type
{
    self = [super init];
    if (self) {
        mAssetType = type;
        _mMute = @(NO);
        _mAssetImages = [NSMutableArray array];
        _mAssetFiles = [NSMutableArray array];
    }
    return self;
}

-(void) addFile:(NSString *) filePath with:(UIImage *) image
{
    switch (mAssetType)
    {
        case kSingleMediaAsset:
        {
            if(_mAssetFiles.count == 0)
            {
                [_mAssetFiles addObject:filePath];
                [_mAssetImages addObject:image];
            }
        }
            break;
        case kPictureSlideAsset:
        {
            [_mAssetFiles addObject:filePath];
            [_mAssetImages addObject:image];
        }
        default:
            break;
    }
}

-(void) replaceFile:(NSString *) filePath with:(UIImage *) image at:(NSUInteger) index
{
    if (mAssetType != kTextAsset && _mAssetFiles.count > index)
    {
        [_mAssetFiles replaceObjectAtIndex:index withObject:filePath];
        [_mAssetImages replaceObjectAtIndex:index withObject:image];
    }
}

-(void) setSXTextLayoutView:(SXTextLayoutView *) view
{
    if(mAssetType == kTextAsset)
    {
        _mSXTextLayoutView = view;
    }
}

-(SXTextLayoutView *) getSXTextLayoutView
{
    return _mSXTextLayoutView;
}

-(PinTuAssetType) getAssetType
{
    return mAssetType;
}

-(BOOL) hasContent
{
    return mAssetType == kTextAsset ? _mSXTextLayoutView != nil : _mAssetFiles.count > 0;
}

-(BOOL) hasVideo
{
    if (mAssetType == kSingleMediaAsset)
    {
        return _mAssetFiles.count > 0 && ([_mAssetFiles.firstObject containsString:@".mp4"] || [_mAssetFiles.firstObject containsString:@".MP4"]  || [_mAssetFiles.firstObject containsString:@".mov"] || [_mAssetFiles.firstObject containsString:@".MOV"]);
    }
    return NO;
}

-(CGFloat) getAssetDuration
{
    if (![self hasVideo])
    {
        return 0;
    }
    
    AVURLAsset * asset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:_mAssetFiles.firstObject]];
    return CMTimeGetSeconds(asset.duration);
}

-(UIImage *) getCoverImage
{
    return _mAssetImages.count > 0 ? _mAssetImages.firstObject : nil;
}

-(void) updateAssetWithDisplaySize:(CGSize) size
{
    if(mAssetType == kTextAsset && _mSXTextLayoutView)
    {
        [_mSXTextLayoutView updateLayout:size];
        [_mAssetImages removeAllObjects];
        [_mAssetImages addObject:[_mSXTextLayoutView snapView]];
    }
}

-(void) updateTextAsset
{
    if(mAssetType == kTextAsset && _mSXTextLayoutView)
    {
        [_mAssetImages removeAllObjects];
        [_mAssetImages addObject:[_mSXTextLayoutView snapView]];
    }
}

-(void) prepareAssetForOutput
{
    if(mAssetType == kTextAsset && _mSXTextLayoutView)
    {
        NSString * path = [SXPinTuAssetModel generateRandomNamedFileWithExtension:@".png"];
        [_mAssetImages removeAllObjects];
        [_mAssetImages addObject:[_mSXTextLayoutView snapViewToPath:path]];
        [_mAssetFiles removeAllObjects];
        [_mAssetFiles addObject:path];
    }
}


-(BOOL) shouldMute
{
    return _mMute.boolValue;
}

-(void) setShouldMute:(BOOL) mute
{
    _mMute = @(mute);
}

@end










