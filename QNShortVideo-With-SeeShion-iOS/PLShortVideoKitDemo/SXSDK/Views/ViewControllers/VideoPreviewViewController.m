//
//  VideoPreviewViewController.m
//  SXEditDemo
//
//  Created by 李记波 on 2019/1/14.
//  Copyright © 2019年 Yin Xie. All rights reserved.
//

#import "VideoPreviewViewController.h"
#import "ChoosePhotoViewController.h"
#import <AVKit/AVKit.h>
#import "PlayViewController.h"

@interface VideoPreviewViewController () <SXTemplatePlayerDelegate,SXTemplateRenderDelegate>

@property (nonatomic, strong) UIView      *bgView;
@property (nonatomic, strong) UISlider    *slider;
@property (nonatomic, strong) NSArray     *buttonArr;
@property (nonatomic, strong) NSMutableArray *viewsArr;

@property (nonatomic, strong) SXTemplatePlayer *indexTemplatePlayer;
@property (nonatomic, strong) SXTemplate *sxTemplate;
@property (nonatomic, copy)   NSString *templatePath;
@property (nonatomic, strong) NSMutableArray *groupArray;
@property (nonatomic, strong) NSMutableArray *keys;
@property (nonatomic, strong) NSMutableArray *resourcePath;
@property (nonatomic, assign) BOOL isSelce;
@property (nonatomic, assign) BOOL isChangeMusic;
@property (nonatomic, copy) NSString *simpleStr;
@property (nonatomic, copy) NSString *chineseStr;
@property (nonatomic, copy) NSString *musicPath;
@property (nonatomic, copy) NSString *musicOtherPath;
@property (nonatomic, assign) int frmeRate;
@property (nonatomic, strong) SXTemplateRender *templateRender;
@property (nonatomic, strong) ZLProgressHUD *hud;

@end

@implementation VideoPreviewViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.buttonArr = @[@"模板一",@"模板二",@"换音乐",@"暂停"];
        self.viewsArr = [[NSMutableArray alloc] initWithCapacity:0];
        self.isSelce = YES;
        self.musicPath = [[NSBundle mainBundle] pathForResource:@"testmusic.m4a" ofType:nil];
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.interactivePopGestureRecognizer setEnabled:NO];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.navigationController.interactivePopGestureRecognizer setEnabled:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setHidden:YES];
    self.navbarView.backgroundColor = [UIColor whiteColor];
    self.titLabel.text = @"模板实时预览";
    self.leftBtn.hidden = NO;
    [self.leftImageBtn setBackgroundImage:[UIImage imageNamed:@"topmenu_fanhuiicon"] forState:UIControlStateNormal];
    [self.leftImageBtn addTarget:self action:@selector(backAct:) forControlEvents:UIControlEventTouchUpInside];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.rightBtn.hidden = NO;
    [self.rightBtn setTitle:@"渲染" forState:UIControlStateNormal];
    [self.rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self setViews];
    NSLog(@"这个是多少%@",self.imagePaths);
    self.simpleStr = [self manageList:0];
    [self resetRenderWithPath:self.simpleStr withMusicPath:self.musicPath];
    [self.indexTemplatePlayer start];
}

- (void)backAct:(id)sender {
    [self.indexTemplatePlayer stop];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setViews {
    
    self.bgView = [[UIView alloc] init];
    self.bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bgView];
    
    self.slider = [[UISlider alloc] init];
    self.slider.minimumValue = 0;
    self.slider.value = 0;
    self.slider.continuous = NO;
    [self.slider addTarget:self action:@selector(changeValueNow:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.slider];
    
    for (int i = 0; i < self.buttonArr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:[self.buttonArr objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = [UIColor blackColor].CGColor;
        btn.layer.cornerRadius = 5;
        btn.tag = 2340 + i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        [self.viewsArr addObject:btn];
    }
    kWeakSelf(self);
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.navbarView.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.view.mas_left).offset(15);
        make.right.equalTo(weakSelf.view.mas_right).offset(-15);
        make.height.equalTo(@(448));
    }];
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.bgView.mas_bottom).offset(15);
        make.left.equalTo(weakSelf.view.mas_left).offset(15);
        make.right.equalTo(weakSelf.view.mas_right).offset(-15);
        make.height.equalTo(@(35));
    }];
    [self.viewsArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:15 leadSpacing:15 tailSpacing:15];
    [self.viewsArr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.slider.mas_bottom).offset(10);
        make.height.equalTo(@(35));
    }];
    
}
- (NSString*)manageList:(NSInteger)index {
    NSString *folderPath = [[NSBundle mainBundle] pathForResource:@"dynamic" ofType:nil inDirectory:@"test"];
    NSString *infoPath = [folderPath stringByAppendingPathComponent:@"info.json"];
    NSData *data = [NSData dataWithContentsOfFile:infoPath];
    NSError *error;
    NSArray *typeArr = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    NSString *folderName = [typeArr objectAtIndex:index][@"folder"];
    NSString*path = [folderPath stringByAppendingPathComponent:folderName];
    return path;
}

- (void)resetRenderWithPath:(NSString*)path  withMusicPath:(NSString*)musicPath{
    SXTemplate *late = [[SXTemplate alloc] init:path type:SXTemplateUsagePreview];
    if (self.indexTemplatePlayer) {
        [self.indexTemplatePlayer stop];
        UIView *view = [self.indexTemplatePlayer getPlayerView];
        [view removeFromSuperview];
        self.indexTemplatePlayer.sxTemplate = late;
        [self.indexTemplatePlayer replaceAudio:musicPath];
       // self.indexTemplatePlayer = nil;
    } else {
        self.indexTemplatePlayer = [[SXTemplatePlayer alloc] initWithTemplate:late audioPath:musicPath];
        self.indexTemplatePlayer.delegate = self;
    }
    
    [self.bgView setNeedsLayout];
    [self.bgView layoutIfNeeded];
    UIView *playView = [self.indexTemplatePlayer getPlayerView];
    int videoWidth = [late mainCompWidth];
    int videoHeight = [late mainCompHeight];
    CGFloat slace =videoHeight / self.bgView.bounds.size.height;
    
    playView.bounds = CGRectMake(0, 0, videoWidth / slace, self.bgView.bounds.size.height);
    playView.center = CGPointMake(self.bgView.bounds.size.width/2, self.bgView.bounds.size.height / 2);
    [self.bgView addSubview:playView];
    [late setReplaceableFilePaths:_imagePaths];
    [late commit];
    self.frmeRate = [late frameRate];
    self.slider.maximumValue = [late realDuration] / self.frmeRate;
}
- (void)goPlayer:(NSURL *)url {
    PlayViewController *playViewController = [[PlayViewController alloc] init];
    playViewController.url = url;
    [self presentViewController:playViewController animated:YES completion:nil];
}

#pragma mark -SXTemplatePlayerDelegate
- (void)playFrameIndex:(int)frameIndex {
    CGFloat value = frameIndex / self.frmeRate;
    self.slider.value = value;
}
#pragma mark - SXTemplateRenderDelegate

- (void)templateRenderStarted {
    self.hud = [[ZLProgressHUD alloc] init];
    [self.hud setTitle:@"正在渲染0%"];
    [self.hud show];
}
- (void)templateRenderCancelled {
    [self.hud hide];
}
-(void) templateRenderFailed:(NSError *)error {
    [self.hud hide];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"渲染失效" message:@"渲染程序失效啦！" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"重新渲染" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self goToNextViewController];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
    
}
- (void)templateRenderFinished:(NSURL *)tempUrl {
    [self.hud hide];
    [self goPlayer:tempUrl];
}
- (void)templateRenderProgress:(float)progress {
    [self.hud setTitle:[NSString stringWithFormat:@"正在渲染%i%%",(int)(progress *100)]];
}

#pragma mark -Action
- (void)btnClick:(UIButton*)sender {
    
    if (sender.tag == 2343) {
        if (self.isSelce) {
            [sender setTitle:@"开始" forState:UIControlStateNormal];
            [self.indexTemplatePlayer pause];
        } else {
            [sender setTitle:@"暂停" forState:UIControlStateNormal];
            [self.indexTemplatePlayer start];
        }
        self.isSelce =!_isSelce;
    } else {
        self.slider.value = 0;
        if (sender.tag == 2340) {
            self.simpleStr = [self manageList:0];
        }
        if (sender.tag == 2341) {
            self.simpleStr = [self manageList:2];
        }
        if (sender.tag == 2342) {
            if (!self.isChangeMusic) {
                self.musicPath = [[NSBundle mainBundle] pathForResource:@"test1.mp3" ofType:nil];
            } else {
                self.musicPath = [[NSBundle mainBundle] pathForResource:@"testmusic.m4a" ofType:nil];
            }
            self.isChangeMusic = !_isChangeMusic;
        }
        [self resetRenderWithPath:self.simpleStr withMusicPath:self.musicPath];
        [self.indexTemplatePlayer start];
        
    }
}
- (void)changeValueNow:(UISlider*)sender {
    NSLog(@"数值改变了%f",sender.value);
    [self.indexTemplatePlayer pause];
    [self.indexTemplatePlayer seek:sender.value];
    [self.indexTemplatePlayer start];
}
- (void)goToNextViewController {
    
    SXTemplate *template = [[SXTemplate alloc] init:self.simpleStr type:SXTemplateUsageRender];
    self.templateRender = [[SXTemplateRender alloc] initWithTemplate:template audioPath:self.musicPath];
    self.templateRender.delegate = self;
    [template setReplaceableFilePaths:self.imagePaths];
    [template commit];
    [self.templateRender start];
    if (self.indexTemplatePlayer) {
        [self.indexTemplatePlayer stop];
    }
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
