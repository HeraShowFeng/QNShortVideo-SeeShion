//
//  SXEditViewController.m
//  SXEditDemo
//
//  Created by Yin Xie on 2018/11/12.
//  Copyright © 2018 Yin Xie. All rights reserved.
//
#import<AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

#import "SXEditViewController.h"
#import "SXAssetModel.h"
#import "SXAssetCollectionViewCell.h"
#import "SXAssetLayoutView.h"
#import "TextEditBoard.h"
#import "ChoosePhotoViewController.h"
#import "VideoPreviewViewController.h"
#import "PlayViewController.h"

#import <SXVideoEnging/SXVideoEnging.h>

static const CGFloat kBorderWidth = 2.0;
static const CGFloat kCellHeight = 90.0;

@interface SXEditViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, TextEditBoardDelegate, SXAssetLayoutViewDelegate, SXTemplateRenderDelegate>{

    BOOL isSetIndex;
}
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *editView;
@property (nonatomic, strong) UIButton *renderButton;
@property (nonatomic, strong) UILabel *precentLabel;
@property (nonatomic, strong) UICollectionViewFlowLayout *collectionLayout;
@property (nonatomic, strong) UIButton *batchButton;
@property (nonatomic, strong) UIView *progressView;
@property (nonatomic, strong) UILabel *progressLabel;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) NSMutableArray *groupArray;
@property (nonatomic, strong) NSMutableArray *keys;
@property (nonatomic, assign) int assetCount;
@property (nonatomic, strong) TextEditBoard * mTextEditBoard;
@property (nonatomic, strong) SXAssetLayoutView *layoutView;
@property (nonatomic, strong) NSMutableArray *resourcePath;
@property (nonatomic, strong) SXTemplateRender *render;
@property (nonatomic, assign) int fps;
@property (nonatomic, assign) int type;
@property (nonatomic, strong) AVPlayerViewController *aVPlayerViewController;

@property (nonatomic, strong) SXTemplate *sxTemplate;
@property (nonatomic, strong) NSArray *filePaths;
@end

@implementation SXEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    if (!_isPreviews) {
       [self initConfigData];
    }
    [self setupView];
    
    _aVPlayerViewController = [[AVPlayerViewController alloc]init];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!isSetIndex) {
        [self updateEditView:0];
        isSetIndex = true;
    }
//    [self.navigationController setNavigationBarHidden:NO];
}
- (instancetype)init {
    self = [super init];
    if (self) {
        self.isPreviews = NO;
    }
    return self;
}


- (void)setupView {
    
    self.view.backgroundColor = [UIColor blackColor];
    
    _editView = [[UIView alloc] initWithFrame:CGRectMake(0, 80, self.view.bounds.size.width, self.view.bounds.size.height-80-25-107)];
    _editView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_editView];
     
     UIView * collectView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-69-107, self.view.bounds.size.width, 107)];
    [self.view addSubview:collectView];
    
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, collectView.bounds.size.width, self.view.bounds.size.height) collectionViewLayout:flowLayout];
    [_collectionView registerNib:[UINib nibWithNibName:@"SXAssetCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"assetCell"];
    _collectionView.allowsMultipleSelection = false;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [collectView addSubview:_collectionView];
    
    
    _renderButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-70, 45, 50, 30)];
    [_renderButton setTitle:@"渲染" forState:UIControlStateNormal];
    _renderButton.titleLabel.font = [UIFont systemFontOfSize:14];
    _renderButton.titleLabel.tintColor = [UIColor blackColor];
    [_renderButton addTarget:self action:@selector(render:) forControlEvents:UIControlEventTouchUpInside];
    [_renderButton setBackgroundImage:[UIImage imageWithCorner:_renderButton.bounds.size.height / 2 size:_renderButton.bounds.size fillColor:kMainColor] forState: UIControlStateNormal];
    [self.view addSubview:_renderButton];
    
    _batchButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 100, 80, 30)];
    [_batchButton setTitle:@"批量导入" forState:UIControlStateNormal];
    _batchButton.titleLabel.font = [UIFont systemFontOfSize:10];
    [_batchButton setImage:[UIImage imageNamed:@"pldr_icon"] forState:UIControlStateNormal];
    [_batchButton setBackgroundImage:[UIImage imageWithCorner:_batchButton.bounds.size.height / 2 size:_batchButton.bounds.size fillColor:[UIColor colorWithWhite:0.0 alpha:0.64]] forState:UIControlStateNormal];
    [_batchButton addTarget:self action:@selector(selectImages:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_batchButton];
    
    
    self.backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 30, 45, 45)];
    UIImage *image = [UIImage imageNamed:@"return_icon"];
    [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.backButton setImage:image forState:UIControlStateNormal];
    self.backButton.imageView.tintColor = UIColor.blackColor;
    [self.view addSubview:self.backButton];
    
    
    self.progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.progressView.backgroundColor = [UIColor clearColor];
    self.progressView.hidden = YES;
    [self.view addSubview:self.progressView];
    
    self.progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.progressView.bounds.size.height/2+50, self.progressView.bounds.size.width, 100)];
    self.progressLabel.text = @"正在渲染\n0%";
    self.progressLabel.numberOfLines = 2;
    self.progressLabel.textAlignment = NSTextAlignmentCenter;
    self.progressLabel.font = [UIFont systemFontOfSize:23];
    self.progressLabel.textColor = [UIColor whiteColor];
    [self.progressView addSubview:self.progressLabel];
    
}

- (void)initConfigData {
    NSString *configPath = [_templatePath stringByAppendingPathComponent:@"config.json"];
    NSData *data = [NSData dataWithContentsOfFile:configPath];
    NSError *error;
    NSDictionary *configDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (!error) {
        _type = [configDic[@"type"] integerValue];
        if (_type == 1) {
            [self setupStandardTemplate:configDic];
        }else {
//            [self setupDynamicTemplate];
        }
    }
}

- (void)setupStandardTemplate:(NSDictionary *)configDic {
    [SXPinTuAssetModel refreshAssetFolder];
    NSMutableDictionary *groups = [NSMutableDictionary dictionary];
    _keys = [NSMutableArray array];
    _groupArray = [NSMutableArray array];
    _assetCount = 0;
    _fps = [configDic[@"fps"] intValue];
    NSArray *UIGroups = configDic[@"ui_group"];
    NSArray *assetArray = configDic[@"assets"];
    for (NSDictionary *asset in assetArray) {
        SXAssetModel *model = [[SXAssetModel alloc] initWithDictionary:asset dictionaryPath:_templatePath fps:_fps];
        if (model.editModel) {
            [_keys addObject:model.key];
            if (model.editModel.type == SXAssetTypeImage) {
                _assetCount += 1;
            }
            NSMutableDictionary *groupAsset = groups[@(model.editModel.group)];
            if (!groupAsset) {
                groupAsset = [NSMutableDictionary dictionary];
                groups[@(model.editModel.group)] = groupAsset;
            }
            groupAsset[@(model.editModel.index)] = model;
        }
    }
    NSComparator finderSort = ^(id string1,id string2){
        
        if ([string1 integerValue] > [string2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }else if ([string1 integerValue] < [string2 integerValue]){
            return (NSComparisonResult)NSOrderedAscending;
        }
        else
            return (NSComparisonResult)NSOrderedSame;
    };
    for (NSNumber *groupKey in [groups.allKeys sortedArrayUsingComparator:finderSort]) {
        NSDictionary *groupAsset = groups[groupKey];
        NSMutableArray *assetArray = [NSMutableArray array];
        for (NSNumber *indexKey in [groupAsset.allKeys sortedArrayUsingComparator:finderSort]) {
            [assetArray addObject:groupAsset[indexKey]];
        }
        SXGroupModel *groupModel = [[SXGroupModel alloc] init];
        NSDictionary *groupDic = UIGroups[_groupArray.count];
        groupModel.groupSize = [SXParseJsonUtil initSizeWithArray:groupDic[@"size"]];
        [groupModel setAssetModels:assetArray];
        [_groupArray addObject:groupModel];
    }
}

- (void)setupDynamicTemplate {
    [SXPinTuAssetModel refreshAssetFolder];
    ChoosePhotoViewController *chooseVC = [[ChoosePhotoViewController alloc] init];
    chooseVC.isMoreSelect = YES ;
    chooseVC.maxPage = 100;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:chooseVC];
    [chooseVC setSelectBlock:^(NSArray * _Nonnull images, NSArray * _Nonnull files) {
        
        if (_isPreviews) {
            self.filePaths = files;
        }else {
            [self resetRender];
            [_sxTemplate setReplaceableFilePaths:files];
            [self replaceAssetWithUIKey];
            [_render start];
        }
        
    }];
    [self presentViewController:nav animated:NO completion:^{
        
    }];
}

- (void)replaceAssetWithUIKey {
    NSDictionary *titleAsset = [_sxTemplate getAssetDataForUIKey:@"title"];
    if (titleAsset) {
        NSString * outputFile = [SXPinTuAssetModel generateRandomNamedFileWithExtension:@".png"];
        SXTextCanvas *textCanvas = [[SXTextCanvas alloc] initWithDictionary:titleAsset];
        textCanvas.content = [[[NSDate date] description] substringToIndex:11];
        textCanvas.fillColor = UIColor.redColor;
        [textCanvas saveToPath:outputFile];
        [_sxTemplate setFile:outputFile forUIKey:@"title"];
    }
   
}

- (void)resetRender {
    _sxTemplate = [[SXTemplate alloc] init:_templatePath type:SXTemplateUsageRender];
    NSString *musicPath = [[NSBundle mainBundle] pathForResource:@"testmusic.m4a" ofType:nil];
    
    _render = [[SXTemplateRender alloc] initWithTemplate:_sxTemplate audioPath:musicPath];
    
    _render.outputPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"output.mp4"];
    _render.delegate = self;
    
    
}

- (void)updateEditView:(int)selectItem {
    [_layoutView removeFromSuperview];
    if (selectItem < _groupArray.count) {
        _layoutView = [[SXAssetLayoutView alloc] initWithAssetGroup:_groupArray[selectItem] presentSize:self.editView.frame.size];
        CGRect frame = _layoutView.frame;
        frame.origin.x = (_editView.frame.size.width - _layoutView.frame.size.width) / 2;
        frame.origin.y = (_editView.frame.size.height - _layoutView.frame.size.height) / 2;
        _layoutView.frame = frame;
        _layoutView.delegate = self;
        [_editView insertSubview:_layoutView atIndex:0];
    }
}

- (void)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)render:(id)sender {
    if (_isPreviews) {
        VideoPreviewViewController *videoPreview = [[VideoPreviewViewController alloc] init];
        videoPreview.imagePaths = self.filePaths;
        [self.navigationController pushViewController:videoPreview animated:YES];
    } else {
        [self resetRender];
        [self prepareRender];
    }
    
}

- (void)selectImages:(id)sender {
    if (_type == 1) {
        __weak typeof(self) weakSelf = self;
        ChoosePhotoViewController *chooseVC = [[ChoosePhotoViewController alloc] init];
        chooseVC.isMoreSelect = YES ;
        chooseVC.maxPage = _assetCount;
        chooseVC.allowSelectVideo = false;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:chooseVC];
        [chooseVC setSelectBlock:^(NSArray * _Nonnull images, NSArray * _Nonnull files) {
            int i = 0;
            self.filePaths = [[NSArray alloc] initWithArray:files];
            for (SXGroupModel *group in weakSelf.groupArray) {
                for (SXAssetModel *model in group.assetModels) {
                    if (model.editModel.type == SXAssetTypeImage && i < images.count) {
                        SXPinTuAssetModel *asset = [SXPinTuAssetModel mediaAssetWithFile:files[i] image:images[i]];
                        [model setAsset:asset];
                        i++;
                    }
                    if (i >= images.count) {
                        break;
                    }
                }
                [group updateImages];
                if (i >= images.count) {
                    break;
                }
            }
            [weakSelf.collectionView reloadData];
            [weakSelf.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:false scrollPosition:UICollectionViewScrollPositionLeft];
            [weakSelf updateEditView:0];
        }];
        [self presentViewController:nav animated:YES completion:^{
            
        }];
    }else {
        [self setupDynamicTemplate];
    }
}

#pragma mark -CollectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _groupArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SXAssetCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"assetCell" forIndexPath:indexPath];
    [cell setData:_groupArray[indexPath.item] index:indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self updateEditView:indexPath.item];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    SXGroupModel *model = _groupArray[indexPath.item];
    if (model) {
        return CGSizeMake(kCellHeight / model.groupSize.height * model.groupSize.width + kBorderWidth * 2, kCellHeight + kBorderWidth * 2);
    }else {
        return CGSizeZero;
    }
}

#pragma mark -TextBoard
- (BOOL)isShowingTextEditBoard
{
    return _mTextEditBoard.superview != nil;
}

-(void)shouldShowTextEditBoard:(SXAssetModel *) asset
{
    _mTextEditBoard = [[TextEditBoard alloc] init];
    _mTextEditBoard.delegate = self;
    [_mTextEditBoard showWithAsset:asset inView:self.view];
}

-(void) shouldDismissTextEditBoard
{
    [_mTextEditBoard dismiss];
}

#pragma mark -- TextEditBoardDelegate
-(void) textEditBoardTitleContentChanged:(NSString*) content
{
    [_layoutView updateTextView];
}

-(void) textEditBoardDetailContentChanged:(NSString*) content
{
    [_layoutView updateTextView];
}

-(void) textEditBoardTextFontSizeChanged:(CGFloat) size
{
    [_layoutView updateTextView];
}

-(void) textEditBoardTextAlignmentChanged:(NSTextAlignment) alignment
{
    [_layoutView updateTextView];
}

-(void) textEditBoardFontChanged:(UIFont *) font
{
    [_layoutView updateTextView];
}

-(void) textEditBoardContentAlphaChanged:(CGFloat) alpha
{
    [_layoutView updateTextView];
}

-(void) textEditBoardTextColorChanged:(UIColor *) color
{
    [_layoutView updateTextView];
}

-(void) textEditBoardBackgroundColorChanged:(UIColor *) color
{
    [_layoutView updateTextView];
}

-(void) textEditBoardRequestForStyleReset
{
    [_layoutView updateTextView];
}

-(void) textEditBoardDone:(NSMutableDictionary *)txtDic
{
    [_layoutView updateTextView];
}
#pragma mark - SXAssetLayoutViewDelegate
- (void)updateThumb {
    [_collectionView reloadData];
}

//#pragma mark - render
- (void)prepareVideoCut:(SXAssetModel *)model finishHandle:(void(^ _Nullable)(BOOL, NSString *))finishHandle
{
    NSURL * sourceFile = [NSURL fileURLWithPath: model.editModel.assetModel.mAssetFiles.firstObject];
    NSURL * outputFile = [NSURL fileURLWithPath:[SXPinTuAssetModel generateRandomNamedFileWithExtension:@".mp4"]];

    SXVideoCompositor * videoCompositor = [[SXVideoCompositor alloc] init:sourceFile output:outputFile];
    [videoCompositor setOutputRange:CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(model.editModel.duration, 6000))];

    // 如果用音频，可以直接将音量设为0
   [videoCompositor setSourceVolume:0];

    // 如果对视频的位置，尺寸进行了变换，可以将CGAffine传入
    [videoCompositor setOutputTransform:model.editModel.renderTransform];

    [videoCompositor finish:VIDEO_EXPORT_PRESET_HIGH finishHandle:^(BOOL success) {
        NSLog(success ? @"success":@"false");
        finishHandle(success, outputFile.path);
    }];
}

- (NSString *)prepareImage:(SXAssetModel *)model {

    NSString * outputFile = [SXPinTuAssetModel generateRandomNamedFileWithExtension:@".png"];
    NSData *data = UIImagePNGRepresentation(model.editModel.renderImage);
    [data writeToFile:outputFile atomically:YES];
    return outputFile;
}

- (void)prepareRenderAsset:(int) index {
    NSLog(@"%i", index);
    if (index == _keys.count) {
        [_sxTemplate setReplaceableFilePaths:_resourcePath];
        if(_render == nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"测试程序失效" message:@"测试程序失效啦！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alert show];
            });
            return;
        }
        [_sxTemplate commit];
        [_render start];
        _renderButton.userInteractionEnabled = NO;
//        [_renderButton setTitle:@"正在渲染" forState:UIControlStateNormal];
    }else if (index < _keys.count) {
        bool flag = true;
        SXAssetModel *asset = [self searchModelWithKey:_keys[index]];
        if (asset) {
            if (!asset.editModel.assetModel.getCoverImage) {
                [_resourcePath addObject:[asset.dictionaryPath stringByAppendingPathComponent:asset.name]];
            }else {
                if (asset.editModel.assetModel.hasVideo) {
                    flag = false;
                    [self prepareVideoCut:asset finishHandle:^(BOOL success, NSString *path) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (success) {
                                [_resourcePath addObject: path];
                                [self prepareRenderAsset:index + 1];
                            }else {
                                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"测试程序失效" message:@"测试程序失效啦！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                                [alert show];
                            }
                        });
                        
                    }];
                }else {
                    [_resourcePath addObject:[self prepareImage:asset]];
                }
            }
        }else {
            [_resourcePath addObject:[asset.dictionaryPath stringByAppendingPathComponent:asset.name]];
        }
        if (flag) {
            [self prepareRenderAsset:index + 1];
        }
    }
}

- (void)prepareRender {
    _resourcePath = [NSMutableArray array];
    [self prepareRenderAsset:0];
}

- (SXAssetModel *)searchModelWithKey:(NSString *)key {
    for (SXGroupModel *group in _groupArray) {
        for (SXAssetModel *model in group.assetModels) {
            if (model.key == key) {
                return model;
            }
        }
    }
    return nil;
}

//保存视频到相册
- (void)writeVideoToPhotoLibrary:(NSURL *)url
{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];

    [library writeVideoAtPathToSavedPhotosAlbum:url completionBlock:^(NSURL *assetURL, NSError *error){
        if (error == nil) {

            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"视频保存成功" preferredStyle:UIAlertControllerStyleAlert];

            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

            }]];
            [self presentViewController:alert animated:true completion:nil];

        }else{
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"视频保存失败" preferredStyle:UIAlertControllerStyleAlert];

            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

            }]];
            [self presentViewController:alert animated:true completion:nil];
        }
    }];
}

- (void)goPlayer:(NSURL *)url {
    PlayViewController *playViewController = [[PlayViewController alloc] init];
    playViewController.url = url;
    [self presentViewController:playViewController animated:YES completion:nil];
}

- (void)templateRenderFinished:(NSURL *) tempUrl {
    NSLog(@"%@", NSStringFromSelector(_cmd));
//    [self writeVideoToPhotoLibrary:tempUrl];
    [self goPlayer:tempUrl];
    _progressView.hidden = true;
    _renderButton.userInteractionEnabled = YES;
}

- (void)templateRenderFailed:(NSError *)error {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    NSLog(@"%@", error);

    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"渲染失效" message:@"渲染程序失效啦！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    _progressView.hidden = true;
    _renderButton.userInteractionEnabled = YES;
}

- (void)templateRenderStarted {
    _progressView.hidden = false;
    _progressLabel.text = @"正在渲染\n0%";
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)templateRenderCancelled {
    _progressView.hidden = true;
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)templateRenderProgress:(float)progress {
    _progressLabel.text = [NSString stringWithFormat:@"正在渲染\n%i%%", (int)(progress * 100)];
}
@end
       
