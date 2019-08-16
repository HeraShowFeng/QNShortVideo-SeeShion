//
//  ChooseVideoView.h
//  CustomImagePickerController
//
//  Created by 李记波 on 2018/11/19.
//  Copyright © 2018年 李记波. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"
#import <Masonry.h>
//#import "DragEditView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChooseVideoView : UIView <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *imageScrollView;
@property (nonatomic, strong) UIView *conteView;
@property (nonatomic, assign) CGFloat needVedioTime;
//@property (nonatomic, strong) DragEditView *leftView;
//@property (nonatomic, strong) DragEditView *rightView;
@property (nonatomic, strong) UIView *topBorder;
@property (nonatomic, strong) UIView *bottomBorder;
@property (nonatomic, strong) UIView *chooseView;
@property (nonatomic, assign) CGFloat  indexHight;
@property (nonatomic, assign) CGFloat  indexWeith;
@property (nonatomic, strong) NSTimer *lineMoveTimer;
@property (nonatomic, assign) CGFloat startTime;
@property (nonatomic, assign) CGFloat endTime;
@property (nonatomic, assign) CGFloat touchPointX;
@property (nonatomic, assign) CGFloat boderX;
@property (nonatomic, assign) CGFloat boderWidth;
@property (nonatomic, assign) CGFloat startPointX;
@property (nonatomic, assign) CGFloat endPointX;
@property (nonatomic, assign) CGPoint leftStartPoint;
@property (nonatomic, assign) CGPoint rightStartPoint;
@property (nonatomic, assign) BOOL   isEdited;
@property (nonatomic, assign) BOOL   isDraggingRightOverlayView;
@property (nonatomic, assign) BOOL   isDraggingLeftOverlayView;

- (void)addVideoImages:(NSArray*)imageArr;

@end

NS_ASSUME_NONNULL_END
