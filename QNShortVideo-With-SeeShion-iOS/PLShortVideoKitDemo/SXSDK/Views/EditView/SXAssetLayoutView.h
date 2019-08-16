//
//  SXAssetLayoutView.h
//  SXEditDemo
//
//  Created by Yin Xie on 2018/11/19.
//  Copyright © 2018 Yin Xie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SXGroupModel.h"
NS_ASSUME_NONNULL_BEGIN
@protocol SXAssetLayoutViewDelegate <NSObject>
- (void)updateThumb;
- (void)shouldShowTextEditBoard:(SXAssetModel *)asset;
@end

@interface SXAssetLayoutView : UIView
@property (nonatomic, weak)id delegate;

- (instancetype)initWithAssetGroup:(SXGroupModel *)group presentSize:(CGSize)presentSize;
- (void)updateTextView;
@end

NS_ASSUME_NONNULL_END
