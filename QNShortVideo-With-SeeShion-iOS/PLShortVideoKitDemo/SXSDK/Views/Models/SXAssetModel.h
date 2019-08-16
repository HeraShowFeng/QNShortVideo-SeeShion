//
//  SXAssetModel.h
//  SXEditDemo
//
//  Created by Yin Xie on 2018/11/13.
//  Copyright © 2018 Yin Xie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SXUIEditModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SXAssetModel : NSObject
@property (nonatomic, assign) int type;
@property (nonatomic, copy)   NSString *key;
@property (nonatomic, copy)   NSString *name;
@property (nonatomic, strong) SXUIEditModel *editModel;
@property (nonatomic, copy)   NSString *dictionaryPath;

- (instancetype)initWithDictionary:(NSDictionary *)data dictionaryPath:(NSString *)path fps:(int)fps;
- (void)setAsset:(SXPinTuAssetModel *)assetModel;
- (void)updateRenderImage;
- (UIImage *)getShadeImage;
@end

NS_ASSUME_NONNULL_END
