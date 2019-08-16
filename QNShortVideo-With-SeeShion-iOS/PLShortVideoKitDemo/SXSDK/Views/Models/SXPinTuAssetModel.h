//
//  SXPinTuAssetModel.h
//  ShiPinDemo
//
//  Created by Zhiqiang Li on 07/11/2017.
//  Copyright © 2017 杨思宇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
typedef enum : NSUInteger {
    kTextAsset,
    kSingleMediaAsset,
    kPictureSlideAsset,
} PinTuAssetType;

typedef void(^MultiAssetsPickCallback)(NSArray<UIImage *>* , NSArray<NSString *>*);
typedef void(^AssetPickCallback)(UIImage * , NSString *);

@class SXTextLayoutView;
@interface SXPinTuAssetModel : NSObject
@property(nonatomic, strong) NSMutableArray<NSString *>* mAssetFiles;

+(void) refreshAssetFolder;

/**
 The asset folder for manage user assets and temp output files

 @return the asset folder path
 */
+(NSString *) assetFolder;

/**
 Generate a random named file in the asset folder

 @param extension the extension for the file, with a dot at the begining
 @return the full file path
 */
+(NSString *) generateRandomNamedFileWithExtension:(NSString *) extension;

+(void) pickMultipleMediaAsset:(UIViewController*) sender amount:(NSUInteger) amount callback:(MultiAssetsPickCallback) callback;

+(void) pickSingleMediaAsset:(UIViewController*) sender callback:(AssetPickCallback) callback;

+(void) pickSinglePictureAsset:(UIViewController*) sender callback:(AssetPickCallback) callback;

+(void) pickMultiplePictureAsset:(UIViewController*) sender amount:(NSUInteger) amount callback:(MultiAssetsPickCallback) callback;

-(instancetype) initWithType:(PinTuAssetType) type;

+(instancetype) textAssetWithSXTextLayoutView:(SXTextLayoutView *) view;

+(instancetype) mediaAssetWithFile:(NSString *) file image:(UIImage *) image;

+(instancetype) slideAssetWithFiles:(NSArray<NSString *>*) files images:(NSArray<UIImage *>*) images;

-(PinTuAssetType) getAssetType;

-(void) addFile:(NSString *) filePath with:(UIImage *) image;

-(void) replaceFile:(NSString *) filePath with:(UIImage *) image at:(NSUInteger) index;

-(void) setSXTextLayoutView:(SXTextLayoutView *) view;

-(SXTextLayoutView *) getSXTextLayoutView;

-(BOOL) hasContent;

-(BOOL) hasVideo;

-(BOOL) shouldMute;

-(void) setShouldMute:(BOOL) mute;

-(CGFloat) getAssetDuration;

-(UIImage *) getCoverImage;

-(void) updateAssetWithDisplaySize:(CGSize) size;

-(void) updateTextAsset;

-(void) prepareAssetForOutput;

@end
