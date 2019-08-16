//
//  VideoEditorViewController.m
//  CustomImagePickerController
//
//  Created by 李记波 on 2018/11/15.
//  Copyright © 2018年 李记波. All rights reserved.
//

#import "VideoEditorViewController.h"
#import "SXUICalculateUtil.h"
@interface VideoEditorViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIButton          *isSoundBtn;
@property (nonatomic, strong) UIButton          *widthBtn;
@property (nonatomic, strong) UIButton          *higthBtn;
@property (nonatomic, strong) UILabel           *timeLabel;
@property (nonatomic, strong) ChooseVideoView   *videoView;
@property (nonatomic, strong) UIView            *bgView;
@property (nonatomic, strong) AVPlayerLayer     *playerLayer;
@property (nonatomic, strong) UIView            *playerBGview;
@property (nonatomic, strong) AVPlayer          *player;
@property (nonatomic, strong) NSTimer           *repeatTimer;
@property (nonatomic, copy)  NSString           *tempVideoPath;
@property (nonatomic, strong) AVAsset           *avAsset;
@property (nonatomic, assign) BOOL              isSound;
@property (nonatomic, strong) UIButton          *stopBtn;
@property (nonatomic, strong) NSArray           *btnsArr;
@property (nonatomic, assign) BOOL              isSelectBtn;
@property (nonatomic, assign) BOOL              isSelectBtn1;
@property (nonatomic, assign) BOOL              isSelectBtn2;
@property (nonatomic, strong) UIImage           *firstImage;
@property (nonatomic, strong) NSArray           *videoImages;
@property (nonatomic, assign) BOOL              isFitHeight;

@end

@implementation VideoEditorViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.needVideoHeight = 300;
        self.needVideoWeight = kScreen_Width;
        self.isFitHeight = YES;
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_player.currentItem removeObserver:self forKeyPath:@"status"];
    [_player removeObserver:self forKeyPath:@"timeControlStatus"];
    [_player pause];
    [_repeatTimer invalidate];
    _repeatTimer = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.btnsArr = @[@{@"select":@"btn_jy_icon_sel",@"noSelect":@"btn_jy_icon_nor"},@{@"select":@"btn_kd_icon_sel",@"noSelect":@"btn_kd_icon_nor"},@{@"select":@"btn_gd_icon_sel",@"noSelect":@"btn_gd_icon_nor"}];
    _isSelectBtn = YES;
    _isSelectBtn1 = YES;
    _isSelectBtn2 = YES;
    self.view.backgroundColor = [UIColor blackColor];
    [self.leftBtn setTitle:@"返回" forState:UIControlStateNormal];
    self.rightBtn.hidden = NO;
    self.rightImageBtn.hidden = NO;
    [self.rightBtn setTitle:@"下一步" forState:UIControlStateNormal];
    self.timeLabel.text = [NSString stringWithFormat:@"%.2fs",_videoNeedTime];
    _isSound = YES;
    [self setUpViews];
    [self reloadVideoPlayer];
}
- (void)reloadVideoPlayer {
    kWeakSelf(self);
    [self.view layoutIfNeeded];
    [self.view setNeedsLayout];
    if (self.model) {
        [PhotoManger analysisEverySecondsImageForAsset:_model.asset interval:1 size:CGSizeMake(self.videoView.bounds.size.height, self.videoView.bounds.size.height) complete:^(AVAsset * _Nonnull asset, NSArray<UIImage *> * _Nonnull arry) {
            kStrongify(weakSelf);
            strongSelf.videoView.needVedioTime = strongSelf.videoNeedTime;
            [strongSelf.videoView addVideoImages:arry];
            [strongSelf initWithPlayer:asset];
            strongSelf.avAsset = asset;
            strongSelf.videoView.endTime = strongSelf.videoNeedTime;
        }];
        [PhotoManger analysisEverySecondsImageForAsset:_model.asset interval:1 size:CGSizeMake(_model.asset.pixelWidth, _model.asset.pixelHeight) complete:^(AVAsset * _Nonnull aseet, NSArray<UIImage *> * _Nonnull arry) {
            if (arry.count != 0) {
                weakSelf.videoImages = arry;
                weakSelf.firstImage = arry[0];
            }
            
        }];
    }
}
- (void)initWithPlayer:(AVAsset*)asset {
    [self.playerBGview layoutIfNeeded];
    [self.playerBGview setNeedsLayout];
    self.playerLayer = [[AVPlayerLayer alloc] init];
    _avAsset = asset;
   CGSize playerSize = [self getVideoNeedSize:CGSizeMake(self.needVideoWeight, self.needVideoHeight) WithisHeight:self.isFitHeight];
    self.playerLayer.bounds = CGRectMake(0, 0, playerSize.width, playerSize.height);
    self.playerLayer.position = CGPointMake(self.playerBGview.frame.size.width/2, self.playerBGview.frame.size.height/2);
    [self.playerBGview.layer addSublayer:self.playerLayer];
    AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:asset];
    self.player = [AVPlayer playerWithPlayerItem:item];
    self.playerLayer.player = self.player;
    [item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [self.player addObserver:self forKeyPath:@"timeControlStatus" options:NSKeyValueObservingOptionNew context:nil];
    _stopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_stopBtn setTitle:@"停止" forState:UIControlStateNormal];
    [_stopBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _stopBtn.titleLabel.font = [UIFont systemFontOfSize:25];
    NSArray *array = asset.tracks;
    CGSize videoSize = CGSizeZero;
    for (AVAssetTrack *track in array) {
        if ([track.mediaType isEqualToString:AVMediaTypeVideo]) {
            videoSize = track.naturalSize;
        }
    }
    [_stopBtn addTarget:self action:@selector(isStopVideo) forControlEvents:UIControlEventTouchUpInside];
    _stopBtn.center = self.playerBGview.center;
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItemStatus status = [change[NSKeyValueChangeNewKey] intValue];
        switch (status) {
            case AVPlayerItemStatusFailed:
                
                break;
            case AVPlayerItemStatusUnknown:
                
                break;
            case AVPlayerItemStatusReadyToPlay: {
                [self.player play];
            }
                
                break;
                
            default:
                break;
        }
    } else if ([keyPath isEqualToString:@"timeControlStatus"]) {
        
    }
}
- (void)moveOverlayView:(UIPanGestureRecognizer *)gesture {

}
//- (void)startTimer {
//    _repeatTimer = [NSTimer timerWithTimeInterval:_videoNeedTime target:self selector:@selector(repeatPlay) userInfo:nil repeats:YES];
//    [_repeatTimer fire];
//}
- (void)repeatPlay {
  CMTime time = CMTimeMakeWithSeconds(_videoView.startTime, _player.currentTime.timescale);
    [_player seekToTime:time toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    [_player play];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_repeatTimer invalidate];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self repeatPlay];
    //[self startTimer];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    CMTime start;
    if (offsetX >= 0) {
        start = CMTimeMakeWithSeconds((offsetX + _videoView.startPointX)/_videoView.indexWeith, _player.currentTime.timescale);
        CGFloat duration = _videoView.endTime - _videoView.startTime;
        _videoView.startTime = (offsetX + _videoView.startPointX)/_videoView.indexWeith;
        _videoView.endTime = _videoView.startTime + duration;
    } else {
        start = CMTimeMakeWithSeconds(_videoView.startPointX, _player.currentTime.timescale);
    }
    [_player seekToTime:start toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}
- (void)isStopVideo {
    if (_isSound) {
        //[_repeatTimer setFireDate:[NSDate distantFuture]];
        [self.player pause];
        [_stopBtn setTitle:@"开始" forState:UIControlStateNormal];
    } else {
        //[_repeatTimer setFireDate:[NSDate distantPast]];
        [self.player play];
        [_stopBtn setTitle:@"停止" forState:UIControlStateNormal];
    }
    _isSound = !_isSound;
}

- (void)setUpViews {
    //[self.view addSubview:self.bgView];
    [self.view addSubview:self.timeLabel];
    [self.view addSubview:self.isSoundBtn];
    [self.view addSubview:self.widthBtn];
    [self.view addSubview:self.higthBtn];
    [self.view addSubview:self.videoView];
    [self.view addSubview:self.playerBGview];
    [_higthBtn addTarget:self action:@selector(buttonClock:) forControlEvents:UIControlEventTouchUpInside];
    [_widthBtn addTarget:self action:@selector(buttonClock:) forControlEvents:UIControlEventTouchUpInside];
    [_isSoundBtn addTarget:self action:@selector(buttonClock:) forControlEvents:UIControlEventTouchUpInside];
    _videoView.imageScrollView.delegate = self;
    if (self.model.duration.doubleValue < self.videoNeedTime) {
        self.videoView.endTime = self.model.duration.doubleValue;
    } else {
        self.videoView.endTime = self.videoNeedTime;
    }
    kWeakSelf(self);
    [_videoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.higthBtn.mas_bottom).offset(14);
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.height.mas_equalTo(60);
    }];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left).offset(15);
        make.centerY.equalTo(weakSelf.widthBtn.mas_centerY);
        make.height.mas_equalTo(28);
        make.right.equalTo(weakSelf.isSoundBtn.mas_left).offset(-10);
    }];
   
    [_isSoundBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.timeLabel.mas_centerY);
        make.right.equalTo(weakSelf.widthBtn.mas_left).offset(-15);
        make.size.mas_equalTo(CGSizeMake(60, 28));
    }];
    [_higthBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.view.mas_right).offset(-15);
        make.top.equalTo(weakSelf.playerBGview.mas_bottom).offset(14);
        make.size.mas_equalTo(CGSizeMake(80, 28));
    }];
    [_widthBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.higthBtn.mas_left).offset(-8);
        make.centerY.equalTo(weakSelf.higthBtn.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(80, 28));
    }];
    [_playerBGview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.navbarView.mas_bottom).offset(25);
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.height.mas_equalTo(@(448));
    }];
//    [_playerBGview mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(weakSelf.bgView);
//        make.size.mas_equalTo(CGSizeMake(weakSelf.needVideoWeight, weakSelf.needVideoHeight));
//    }];
}

- (void)buttonClock:(UIButton*)sender {
    UIColor *bgColor;
    UIColor *titColor;
    NSString *selectStr;
    NSInteger index = 0;
    if (sender.tag == 10086) {
        if (_isSelectBtn) {
            self.playerLayer.player.volume = 0;
            bgColor = [UIColor colorWithHexString:kYellowColor];
            titColor = [UIColor blackColor];
            selectStr = [_btnsArr[index] objectForKey:@"select"];
            sender.layer.borderColor = [UIColor colorWithHexString:kYellowColor].CGColor;
        } else {
            self.playerLayer.player.volume = 10;
            bgColor = [UIColor clearColor];
            titColor = [UIColor whiteColor];
            selectStr = [_btnsArr[index] objectForKey:@"noSelect"];
            sender.layer.borderColor = [UIColor whiteColor].CGColor;
        }
        [self changeBtn:sender ImageName:selectStr ColorName:bgColor BcakColor:titColor];
        _isSelectBtn = !_isSelectBtn;
        
    } else {
        for (int i = 0 ; i < 2; i++) {
            UIView *view = [self.view viewWithTag:10087 + i];
            if ([view isKindOfClass:[UIButton class]]) {
                [(UIButton*)view setEnabled:view != sender];
            }
        }
        self.isFitHeight = sender.tag == 10088 ? YES:NO;
        [self changePlayerLayerFrame];
    }
}
- (void)changeBtn:(UIButton*)btn ImageName:(NSString*)name ColorName:(UIColor*)nameColor BcakColor:(UIColor*)color {
    [btn setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn setBackgroundColor:nameColor];
}
- (void)backView {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)goToNextViewController {
    //[self nextView];
    [self editorVideoInPutNewPath];
}

- (void)editorVideoInPutNewPath{
    ZLProgressHUD *hud = [[ZLProgressHUD alloc] init];
    [hud show];
    AVURLAsset *urlAsset = (AVURLAsset*)self.avAsset;
    NSURL *inPutUrl = urlAsset.URL;
    NSString *outPutpath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%dMov.mp4",arc4random() % 1000]];
    NSURL *outPutUrl = [NSURL fileURLWithPath:outPutpath];
    
    AVAssetTrack *clipVideoTrack = [[_avAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    CGSize videoSize = clipVideoTrack.naturalSize;
    SXVideoCompositor *dvVideoCompositor = [[SXVideoCompositor alloc] init:inPutUrl output:outPutUrl];
    [dvVideoCompositor setOutputSize:CGSizeMake(self.needVideoWeight, self.needVideoHeight)];
    if (!self.isSelectBtn) {
        [dvVideoCompositor setOutputVolume:0];
    } else {
        [dvVideoCompositor setOutputVolume:clipVideoTrack.preferredVolume];
    }
    CGFloat videoWidth = self.needVideoHeight == 0 ? videoSize.width:self.needVideoWeight;
    CGFloat videoHeight = self.needVideoHeight == 0?videoSize.height:self.needVideoHeight;
    
    CMTime start = CMTimeMakeWithSeconds(_videoView.startTime, self.player.currentTime.timescale);
    CMTime duration = CMTimeMakeWithSeconds(_videoView.endTime - _videoView.startTime, self.player.currentTime.timescale);
    CMTimeRange range = CMTimeRangeMake(start, duration);
    [dvVideoCompositor setOutputRange:range];
    
    
    CGPoint moveCenter = CGPointMake(videoWidth / 2, videoHeight / 2);
    CGPoint videoCenter = CGPointMake(videoSize.width / 2, videoSize.height / 2);
    CGAffineTransform t = clipVideoTrack.preferredTransform;
    if((t.a == 0 && t.b == 1.0 && t.c == -1.0 && t.d == 0) ||
       (t.a == 0 && t.b == -1.0 && t.c == 1.0 && t.d == 0)) {
        CGFloat width = videoSize.height;
        videoSize.height = videoSize.width;
        videoSize.width = width;
    }
    
    CGFloat viewScale = 0.0;
    if (self.isFitHeight) {
        viewScale = videoHeight / videoSize.height;
        
    } else {
        viewScale = videoWidth / videoSize.width;
    }
    
    t = CGAffineTransformScale(t, viewScale, viewScale);
    t.tx = moveCenter.x;
    t.ty = moveCenter.y;
    t = CGAffineTransformTranslate(t,  -videoCenter.x, -videoCenter.y);
    [dvVideoCompositor setOutputTransform:t];
    [dvVideoCompositor finish:VIDEO_EXPORT_PRESET_HIGH finishHandle:^(BOOL success) {
        NSLog(@"成功了么？");
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"这个成功了么？%@",outPutUrl.path);
                [hud hide];
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
                AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:outPutUrl options:nil];
                AVAssetImageGenerator *assetGen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
                
                assetGen.appliesPreferredTrackTransform = YES;
                CMTime time = CMTimeMakeWithSeconds(0.0, 600);
                NSError *error = nil;
                CMTime actualTime;
                CGImageRef image = [assetGen copyCGImageAtTime:time actualTime:&actualTime error:&error];
                UIImage *videoImage = [[UIImage alloc] initWithCGImage:image];
                CGImageRelease(image);
                [dict setObject:outPutUrl.path forKey:kEditorVideoKey];
                [dict setObject:videoImage forKey:kEditorVideoFirstImage];
                [[NSNotificationCenter defaultCenter] postNotificationName:kEditorVideoNotification object:nil userInfo:dict];
                UIViewController *first = [self.navigationController viewControllers][0];
                [first dismissViewControllerAnimated:YES completion:nil];
            });
        } else {
            
        }
    }];
}

- (CGSize)getVideoNeedSize:(CGSize)size  WithisHeight:(BOOL)isHeight{
    [self.playerBGview layoutIfNeeded];
    [self.playerBGview setNeedsLayout];
    CGSize bgViewSize = self.playerBGview.bounds.size;
    CGSize newSize ;
    CGFloat scale;
    AVAssetTrack *clipVideoTrack = [[_avAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    CGSize videoSize = clipVideoTrack.naturalSize;
    CGAffineTransform t = clipVideoTrack.preferredTransform;
    if((t.a == 0 && t.b == 1.0 && t.c == -1.0 && t.d == 0) ||
       (t.a == 0 && t.b == -1.0 && t.c == 1.0 && t.d == 0)) {
        CGFloat width = videoSize.height;
        videoSize.height = videoSize.width;
        videoSize.width = width;
    }
    float widthScale = self.needVideoWeight / bgViewSize.width;
    float heightScale = self.needVideoHeight / bgViewSize.height;
    float playerScale = MAX(widthScale, heightScale);
    scale = videoSize.width / videoSize.height;
    if (self.isFitHeight) {
        newSize = CGSizeMake(self.needVideoHeight / playerScale * scale, self.needVideoHeight / playerScale);
    } else {
        newSize = CGSizeMake(self.needVideoWeight / playerScale, self.needVideoWeight / playerScale / scale);
    }
    return newSize;
}
- (void)changePlayerLayerFrame {
    CGSize playerSize = [self getVideoNeedSize:CGSizeMake(self.needVideoWeight, self.needVideoHeight) WithisHeight:self.isFitHeight];
    [UIView animateWithDuration:0.5f animations:^{
       self.playerLayer.bounds = CGRectMake(0, 0, playerSize.width, playerSize.height);
    } completion:^(BOOL finished) {
        
    }];
}
- (UIButton*)isSoundBtn {
    if (_isSoundBtn == nil) {
        _isSoundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_isSoundBtn setTitle:@"静音" forState:UIControlStateNormal];
        [_isSoundBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_isSoundBtn setImage:[UIImage imageNamed:@"btn_jy_icon_nor"] forState:UIControlStateNormal];
        _isSoundBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        _isSoundBtn.layer.masksToBounds = YES;
        _isSoundBtn.layer.borderWidth = 1;
        _isSoundBtn.layer.cornerRadius = 14;
        _isSoundBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _isSoundBtn.tag = 10086;
    }
    return _isSoundBtn;
}
- (UIButton*)widthBtn {
    if (_widthBtn == nil) {
        _widthBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_widthBtn setTitle:@"适应宽度" forState:UIControlStateNormal];
        [_widthBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_widthBtn setTitleColor:[UIColor blackColor] forState:UIControlStateDisabled];
        [_widthBtn setImage:[UIImage imageNamed:@"btn_kd_icon_nor"] forState:UIControlStateNormal];
        [_widthBtn setImage:[UIImage imageNamed:@"btn_kd_icon_sel"] forState:UIControlStateDisabled];
        [_widthBtn setBackgroundImage:[UIImage imageWithBorderWidth:1 corner:14 size:CGSizeMake(80, 28) fillColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [_widthBtn setBackgroundImage:[UIImage imageWithCorner:14 size:CGSizeMake(80, 28) fillColor:kMainColor] forState:UIControlStateDisabled];
        _widthBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        _widthBtn.tag = 10087;
    }
    return _widthBtn;
}
- (UIButton*)higthBtn {
    if (_higthBtn == nil) {
        _higthBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_higthBtn setTitle:@"适应高度" forState:UIControlStateNormal];
        [_higthBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_higthBtn setTitleColor:[UIColor blackColor] forState:UIControlStateDisabled];
        [_higthBtn setImage:[UIImage imageNamed:@"btn_gd_icon_nor"] forState:UIControlStateNormal];
        [_higthBtn setImage:[UIImage imageNamed:@"btn_gd_icon_sel"] forState:UIControlStateDisabled];
        [_higthBtn setBackgroundImage:[UIImage imageWithBorderWidth:1 corner:14 size:CGSizeMake(80, 28) fillColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [_higthBtn setBackgroundImage:[UIImage imageWithCorner:14 size:CGSizeMake(80, 28) fillColor:kMainColor] forState:UIControlStateDisabled];
        _higthBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        _higthBtn.tag = 10088;
        
    }
    return _higthBtn;
}
- (UILabel*)timeLabel {
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textColor = [UIColor colorWithHexString:kYellowColor];
        _timeLabel.numberOfLines = 0;
        _timeLabel.text = @"20.02s";
    }
    return _timeLabel;
}
- (UIView*)bgView {
    if (_bgView == nil) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor clearColor];
    }
    return _bgView;
}
- (ChooseVideoView*)videoView {
    if (_videoView ==nil) {
        _videoView = [[ChooseVideoView alloc] initWithFrame:CGRectZero];
    }
    return _videoView;
}

- (UIView*)playerBGview {
    if (_playerBGview == nil) {
        _playerBGview = [[UIView alloc] init];
        _playerBGview.backgroundColor = [UIColor colorWithWhite:0.0f alpha:.5];
        _playerBGview.layer.masksToBounds = YES;
    }
    return _playerBGview;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
