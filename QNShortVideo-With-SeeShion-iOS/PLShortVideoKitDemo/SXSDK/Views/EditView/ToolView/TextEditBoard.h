//
//  TextEditView.h
//  ShiPinDemo
//
//  Created by 杨思宇 on 2017/11/9.
//  Copyright © 2017年 杨思宇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SXAssetModel.h"
#import "Header.h"

@class TextEditBoard;
@protocol TextEditBoardDelegate <NSObject>
-(void) textEditBoardTitleContentChanged:(NSString*) content;
-(void) textEditBoardTextFontSizeChanged:(CGFloat) size;
-(void) textEditBoardTextAlignmentChanged:(NSTextAlignment) alignment;
-(void) textEditBoardFontChanged:(UIFont *) font;
-(void) textEditBoardContentAlphaChanged:(CGFloat) alpha;
-(void) textEditBoardTextColorChanged:(UIColor *) color;
-(void) textEditBoardRequestForStyleReset;
-(void) textEditBoardDone:(NSMutableDictionary *)txtDic;
@end

@interface TextEditBoard : UIView
@property (nonatomic, copy, readonly) NSString *titleStr;
@property (nonatomic, copy, readonly) NSString *fontName;
@property (nonatomic, assign, readonly) CGFloat fontSzie;
@property (nonatomic, assign, readonly) CGFloat fontAlhpa;
@property (nonatomic, assign, readonly) NSInteger txtAlignment;
@property (nonatomic, strong, readonly) NSDictionary *txtColorDic;
@property (nonatomic, strong, readonly) NSDictionary *bgColorDic;

@property (nonatomic, assign)id<TextEditBoardDelegate>delegate;

-(void) setTitle:(NSString *) title;
-(void) setFontSize:(CGFloat) size;
-(void) setTextAlpha:(CGFloat) alpha;

-(void) showWithAsset:(SXAssetModel *) asset inView:(UIView*) view;
-(void) dismiss;

@end
