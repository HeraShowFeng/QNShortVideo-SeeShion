//
//  SXAssetModel.m
//  SXEditDemo
//
//  Created by Yin Xie on 2018/11/13.
//  Copyright © 2018 Yin Xie. All rights reserved.
//

#import "SXAssetModel.h"
#import "SXTextLayoutView.h"

@implementation SXAssetModel

- (instancetype)initWithDictionary:(NSDictionary *)data dictionaryPath:(NSString *)path fps:(int)fps {
    if (self = [super init]) {
        _type = [data[@"type"] intValue];
        _name = data[@"name"];
        _key = data[@"key"];
        _dictionaryPath = path;
        if ([data[@"ui"] isKindOfClass:[NSDictionary class]]) {
            _editModel = [[SXUIEditModel alloc] initWithDictionary:data[@"ui"]];
            _editModel.duration = _editModel.duration / fps;
            if (_editModel.type == SXAssetTypeText) {
                SXPinTuAssetModel *assetModel = [SXPinTuAssetModel textAssetWithSXTextLayoutView:[[SXTextLayoutView alloc] init]];
                SXTextLayoutView *textLayoutView = assetModel.getSXTextLayoutView;
                [textLayoutView setMHasDetailLabel:false];
                [textLayoutView setTitleContent:_editModel.defaultText];
//                [textLayoutView setFont:[UIFont fontWithName:_editModel.font size:_editModel.fontSize]];
                [textLayoutView setFontSize:_editModel.fontSize];
                [textLayoutView setColor:_editModel.fillColor];
                [textLayoutView setStrokeColor:_editModel.strokeColor];
                [textLayoutView setStrokeWidth:_editModel.width];
                [textLayoutView setAlignment:_editModel.align];
                [assetModel updateAssetWithDisplaySize:_editModel.size];
                [self setAsset:assetModel];
            }else {
                SXPinTuAssetModel *assetModel = [SXPinTuAssetModel mediaAssetWithFile:[self getDefaultImagePath] image:[UIImage imageWithContentsOfFile:[self getDefaultImagePath]]];
                [_editModel setAsset:assetModel];
            }
        }
        return self;
    }
    return nil;
}

- (void)setAsset:(SXPinTuAssetModel *)assetModel {
    [_editModel setAsset:assetModel];
}

- (void)updateRenderImage {
    [_editModel updateRenderImage];
}

- (NSString *)getDefaultImagePath {
    return [[_dictionaryPath stringByAppendingPathComponent:@"assets"] stringByAppendingPathComponent:_name];
}

- (UIImage *)getShadeImage {
    return [UIImage imageWithContentsOfFile:[[_dictionaryPath stringByAppendingPathComponent:@"ui"] stringByAppendingPathComponent:_editModel.file]];
}
@end
