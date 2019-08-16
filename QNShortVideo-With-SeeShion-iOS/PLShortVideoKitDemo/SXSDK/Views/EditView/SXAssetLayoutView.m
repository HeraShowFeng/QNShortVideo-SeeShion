//
//  SXAssetLayoutView.m
//  SXEditDemo
//
//  Created by Yin Xie on 2018/11/19.
//  Copyright © 2018 Yin Xie. All rights reserved.
//

#import "SXAssetLayoutView.h"
#import "SXTextLayoutView.h"
#import "ChoosePhotoViewController.h"

const int kStartTag = 100;
@interface SXAssetLayoutView() <UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIImageView *foregroundImageView;
@property (nonatomic, strong) NSMutableArray *editViews;
@property (nonatomic, strong) NSMutableArray *textImageViews;
@property (nonatomic, strong) UIImageView *currentImageView;
@property (nonatomic, weak)   SXAssetModel *model;
@property (nonatomic, weak)   SXGroupModel *group;
@property (nonatomic, assign) CGFloat viewScale;
@end

@implementation SXAssetLayoutView

- (instancetype)initWithAssetGroup:(SXGroupModel *)group presentSize:(CGSize)presentSize {
    _group = group;
    _textImageViews = [NSMutableArray array];
    _editViews = [NSMutableArray array];
    CGRect frame = CGRectZero;
    frame.size = [self getAdaptSize:group.groupSize maxSize:presentSize];
    if (self = [super initWithFrame:frame]) {
        _viewScale = self.bounds.size.height / _group.groupSize.height;
        _foregroundImageView = [[UIImageView alloc] initWithFrame:frame];
        _foregroundImageView.image = group.shadeImage;
        [self addSubview:_foregroundImageView];
        for (int i = 0; i < group.assetModels.count; i++) {
            SXAssetModel *model = group.assetModels[i];
            [self initAssetModel:model];
            _currentImageView.tag = i + kStartTag;
        }
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [tap cancelsTouchesInView];
        [self addGestureRecognizer:tap];

        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [self addGestureRecognizer:panGesture];
        panGesture.delegate = self;
        UIRotationGestureRecognizer *rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotation:)];
        [self addGestureRecognizer:rotationGesture];
        rotationGesture.delegate = self;
        UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
        [self addGestureRecognizer:pinchGesture];
        pinchGesture.delegate = self;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectVideo:) name:kEditorVideoNotification object:nil];
    }
    return self;
  
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kEditorVideoNotification object:nil];
}

- (void)selectVideo:(NSNotification *)notification {
    NSString *path = [[notification userInfo] objectForKey:kEditorVideoKey];
    UIImage *image = [[notification userInfo] objectForKey:kEditorVideoFirstImage];
    SXPinTuAssetModel *asset = [SXPinTuAssetModel mediaAssetWithFile:path image:image];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_model setAsset:asset];
        [self updateAsset];
    });
}

- (void)initAssetModel:(SXAssetModel *)model {
    self.clipsToBounds = true;
    _model = model;
    UIImageView *editView = [[UIImageView alloc] initWithFrame:self.bounds];
    _currentImageView = editView;
    if (model.editModel.assetModel.getCoverImage) {
        [self updateAsset];
    }
    if (_model.editModel.type == SXAssetTypeImage) {
        UIImageView *maskImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        CGAffineTransform transform = CGAffineTransformMakeScale(_viewScale, _viewScale);
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        [layer setPath:CGPathCreateWithRect(model.editModel.area, &transform)];
        maskImageView.layer.mask = layer;
        [maskImageView addSubview:editView];
        editView.userInteractionEnabled = true;
        [self insertSubview:maskImageView belowSubview:_foregroundImageView];
        [_editViews addObject:editView];
    }else if (model.editModel.type == SXAssetTypeText) {
        editView.backgroundColor = [kMainColor colorWithAlphaComponent:0.1];
        editView.layer.borderColor = kMainColor.CGColor;
        editView.layer.borderWidth = 1.0;
        UIView *foreView = _textImageViews.lastObject;
        if (!foreView) {
            foreView = _foregroundImageView;
        }
        [self insertSubview:editView aboveSubview:foreView];
        [_textImageViews addObject:editView];
    }
    
}

- (CGSize)getAdaptSize:(CGSize)originSize maxSize:(CGSize)maxSize {
    CGSize size;
    float widthScale = originSize.width / maxSize.width;
    float heightScale = originSize.height / maxSize.height;
    float maxScale = MAX(widthScale, heightScale);
    size.width = originSize.width / maxScale;
    size.height = originSize.height / maxScale;
    return size;
}

- (void)updateAsset {
    CGRect editFrame = CGRectZero;
    CGSize coverSize = _model.editModel.assetModel.getCoverImage.size;
    editFrame.size = CGSizeMake(coverSize.width * _viewScale, coverSize.height * _viewScale);
    _currentImageView.transform = CGAffineTransformIdentity;
    _currentImageView.frame = editFrame;
    CGAffineTransform transform = _model.editModel.transform;
    _currentImageView.transform = transform;
    _currentImageView.image = _model.editModel.assetModel.getCoverImage;
    _currentImageView.center = CGPointMake(_currentImageView.center.x + _model.editModel.translation.x * _viewScale, _currentImageView.center.y + _model.editModel.translation.y * _viewScale);
    if (_model.editModel.type == SXAssetTypeText) {
        [self updateTextView];
    }else {
        [self updateCoverImage];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if (![self seekImageView:point imageViews:_editViews]) {
        _currentImageView = nil;
        _model = nil;
    }
}

- (void)handlePan:(UIPanGestureRecognizer *)pan {
    if (pan.state == UIGestureRecognizerStateBegan || pan.state == UIGestureRecognizerStateChanged) {
        _foregroundImageView.alpha = 0.6;
        CGPoint translation = [pan translationInView:_currentImageView];
        _currentImageView.center = CGPointMake(_currentImageView.center.x + translation.x, _currentImageView.center.y + translation.y);
        _model.editModel.translation = CGPointMake(_model.editModel.translation.x + translation.x / _viewScale, _model.editModel.translation.y + translation.y / _viewScale);
        [pan setTranslation:CGPointZero inView:_currentImageView];
    }else {
        [self updateCoverImage];
        _foregroundImageView.alpha = 1.0;
    }
}

- (void)handlePinch:(UIPinchGestureRecognizer *)pinch {
    if (pinch.state == UIGestureRecognizerStateBegan || pinch.state == UIGestureRecognizerStateChanged) {
        _foregroundImageView.alpha = 0.6;
        _currentImageView.transform = CGAffineTransformScale(_currentImageView.transform, pinch.scale, pinch.scale);
        pinch.scale = 1.0;
    }else {
        [self updateCoverImage];
        _foregroundImageView.alpha = 1.0;
    }
}

- (void)handleRotation:(UIRotationGestureRecognizer *)rotation {
    if (rotation.state == UIGestureRecognizerStateBegan || rotation.state == UIGestureRecognizerStateChanged) {
        _currentImageView.transform = CGAffineTransformRotate(_currentImageView.transform, rotation.rotation);
        [rotation setRotation:0];
    }else {
        [self updateCoverImage];
    }
}

- (void)updateCoverImage {
    CGAffineTransform transform = CGAffineTransformMakeScale(_viewScale, _viewScale);
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    [layer setPath:CGPathCreateWithRect(_model.editModel.area, &transform)];
    _currentImageView.superview.layer.mask = layer;
    _model.editModel.transform = _currentImageView.transform;
    [self getRenderTransform];
    [_model updateRenderImage];
    _model.editModel.renderImage = _model.editModel.renderImage;
    [_group updateAsset];
    [_delegate updateThumb];
}

- (void)getRenderTransform {
    CGAffineTransform transform = _currentImageView.transform;
    CGSize imageSize = _model.editModel.assetModel.getCoverImage.size;
    transform.tx = _currentImageView.center.x / _viewScale;
    transform.ty = _currentImageView.center.y / _viewScale;
    transform = CGAffineTransformTranslate(transform, -imageSize.width * 0.5, -imageSize.height * 0.5);
    _model.editModel.renderTransform = transform;
}

- (void)handleTap:(UITapGestureRecognizer *)tap {
    CGPoint point = [tap locationInView:self];
    if (![self getCurrentImageView:point]) {
        return;
    }
    if (_model.editModel.type == SXAssetTypeImage) {
        CGAffineTransform transform = CGAffineTransformMakeScale(_viewScale, _viewScale);
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        [layer setPath:CGPathCreateWithRect(_model.editModel.area, &transform)];
        _currentImageView.superview.layer.mask = layer;
        _model.editModel.transform = _currentImageView.transform;
//        UIViewController *viewController = UIApplication.sharedApplication.keyWindow.rootViewController;
//        UIViewController *topVC = viewController;
//        if (topVC.presentedViewController) {
//            topVC = topVC.presentedViewController;
//        }
        __weak typeof(self) weakSelf = self;
        ChoosePhotoViewController *chooseVC = [[ChoosePhotoViewController alloc] init];
        chooseVC.isMoreSelect = NO ;
        chooseVC.allowSelectVideo = YES;
        chooseVC.allowSelectImage = YES;
        chooseVC.needVideoTime = _model.editModel.duration;
        chooseVC.needEditorSize = _model.editModel.size;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:chooseVC];
        [chooseVC setSelectBlock:^(NSArray * _Nonnull images, NSArray * _Nonnull files) {
            if (images.count == 1 && files.count == 1) {
                SXPinTuAssetModel * asset = [SXPinTuAssetModel mediaAssetWithFile:files[0] image:images[0]];
                [weakSelf.model setAsset:asset];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf updateAsset];
                });
            }
        }];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [topVC presentViewController:chooseVC animated:YES completion:nil];
//        });
        UIViewController * controller = [self viewControllerFromView];
        [controller presentViewController:nav animated:YES completion:nil];
        
        
    }else if (_model.editModel.type == SXAssetTypeText) {
        [_delegate shouldShowTextEditBoard:_model];
    }
}

- (BOOL)getCurrentImageView:(CGPoint )point {
    return [self seekImageView:point imageViews:_textImageViews] || [self seekImageView:point imageViews:_editViews];
}

- (UIViewController *)viewControllerFromView{
    
    UIResponder *responder = self.nextResponder;
    
    do {
        
        if ([responder isKindOfClass:[UIViewController class]]) {
            
            return (UIViewController *)responder;
            
        }
        
        responder = responder.nextResponder;
        
    } while (responder);
    
    return nil;
    
}

- (BOOL)seekImageView:(CGPoint)point imageViews:(NSMutableArray *)imageViews {
    for (NSInteger i = imageViews.count - 1; i >= 0; i--) {
        UIImageView *imageView = imageViews[i];
        NSInteger index = imageView.tag - kStartTag;
        if (index < _group.assetModels.count) {
            SXAssetModel *model = _group.assetModels[index];
            CGRect area = CGRectApplyAffineTransform(model.editModel.area, CGAffineTransformMakeScale(_viewScale, _viewScale));
            if (CGRectContainsPoint(area, point)) {
                _model = model;
                _currentImageView = imageView;
                _currentImageView.superview.layer.mask = nil;
                return true;
            }
        }
    }
    return false;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([otherGestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        return false;
    }
    return true;
}

- (void)updateTextView {
    [_model.editModel.assetModel updateTextAsset];
    [_model updateRenderImage];
    _currentImageView.image = _model.editModel.assetModel.getCoverImage;
    [_group updateText];
    [_delegate updateThumb];
}

@end
