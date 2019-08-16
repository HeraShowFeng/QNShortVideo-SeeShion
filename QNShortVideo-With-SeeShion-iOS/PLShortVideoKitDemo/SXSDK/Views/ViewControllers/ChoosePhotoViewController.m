//
//  ChoosePhotoViewController.m
//  CustomImagePickerController
//
//  Created by 李记波 on 2018/11/13.
//  Copyright © 2018年 李记波. All rights reserved.
//

#import "ChoosePhotoViewController.h"
#import "CostumCollectionViewCell.h"
#import "AllAblumViewController.h"
#import "VideoEditorViewController.h"
#import "VideoPreviewViewController.h"

@interface ChoosePhotoViewController () <UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIBarButtonItem *rightButtonItem;
@property (nonatomic, strong) PHAssetCollection *photoCollection;
@property (nonatomic, strong) PHFetchResult<PHAsset *> * phFecthResult;
@property (nonatomic, strong) NSMutableArray *chooseArray;
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UIView  *bgView;
@property (nonatomic, strong) DeleteChooseImageView *deleteImageView;
@property (nonatomic, strong) ZLAlbumListModel *listModels;
@property (nonatomic, strong) DeleteChooseView *deleteView;
@property (nonatomic, strong) NSMutableArray *selectIndexArr;
@property (nonatomic, strong) UIButton *selectAblumBtn;
@property (nonatomic, assign) BOOL selectAblum;
@property (nonatomic, strong) ZLProgressHUD *hud;
@property (nonatomic, assign) BOOL isOriginal;

@end

@implementation ChoosePhotoViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (instancetype)init {
    self = [super init];
    if (self) {
        self.allowSelectImage = YES;
        self.allowSelectVideo = YES;
        self.shouldAnialysisAsset = YES;
        self.isOriginal = YES;
        self.isPushNextView = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    self.selectAblum = YES;
    _chooseArray = [[NSMutableArray alloc] initWithCapacity:0];
    _selectIndexArr = [[NSMutableArray alloc] initWithCapacity:0];
    [self.leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    
    [self.navbarView layoutIfNeeded];
    [self.navbarView setNeedsLayout];
    self.selectAblumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.selectAblumBtn setImage:[UIImage imageNamed:@"choosepic_xl_icon"] forState:UIControlStateNormal];
    self.selectAblumBtn.frame = CGRectMake(self.navbarView.bounds.size.width - 80, 0, 80, 44);
    [self.selectAblumBtn setTitle:@"相机胶卷" forState:UIControlStateNormal];
    [self.selectAblumBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.selectAblumBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.selectAblumBtn addTarget:self action:@selector(chooseAblum) forControlEvents:UIControlEventTouchUpInside];
    self.selectAblumBtn.imageEdgeInsets = UIEdgeInsetsMake(0, self.selectAblumBtn.frame.size.width - self.selectAblumBtn.imageView.frame.origin.x- 10 - self.selectAblumBtn.imageView.frame.size.width, 0, 0);
    self.selectAblumBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -(self.selectAblumBtn.frame.size.width - self.selectAblumBtn.imageView.frame.size.width ), 0, 0);
    [self.navbarView addSubview:self.selectAblumBtn];
    if (!self.maxPage) {
        self.maxPage = kMaxPage;
    }
    [SXPinTuAssetModel refreshAssetFolder];
    [self setUpAllView];
    [self showPhotoLibrary];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)getAllAblumPhotos {
    kWeakSelf(self);
    [PhotoManger getPhotoAblumList:_allowSelectVideo allowSelectImage:_allowSelectImage complete:^(NSArray<ZLAlbumListModel *> * _Nonnull listArr) {
        [weakSelf.hud hide];
        ZLAlbumListModel *listModel = listArr.firstObject;
        weakSelf.listModels = listModel;
        [weakSelf reloadDatacollectionView];
    }];
}

- (void)setUpAllView {
    kWeakSelf(self);
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    layout.itemSize = CGSizeMake(kViewHeight, kViewHeight);
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 5;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor blackColor];
    if (@available(iOS 10.0,*)) {
        self.collectionView.prefetchingEnabled = NO;
    }
    [self.view addSubview:self.collectionView];
    [self.collectionView registerClass:[CostumCollectionViewCell class] forCellWithReuseIdentifier:@"cellId"];
    
    self.deleteView = [[DeleteChooseView alloc] initWithFrame:CGRectZero];
    [self.deleteView.sureBtn addTarget:self action:@selector(sureChooseBtn) forControlEvents:UIControlEventTouchUpInside];
    self.deleteView.maxNumberImage = self.maxPage;
    [self.view addSubview:self.deleteView];
    
    _deleteView.chooseBlcok = ^(ZLPhotoModel *model, NSInteger row) {
        kStrongify(weakSelf);
        if (strongSelf.chooseArray.count < 1) {
            [strongSelf upDateConstrains];
        }
        for (int i = 0; i < strongSelf.chooseArray.count;i++) {
            ZLPhotoModel *deleteModel = strongSelf.chooseArray[i];
            deleteModel.indexPath = i+1;
        }
        //[strongSelf.collectionView reloadData];//
        [strongSelf reloadDatacollectionView];
    };
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (kIsiOS11) {
            make.bottom.equalTo(weakSelf.view.mas_bottom);
        } else {
            make.bottom.equalTo(weakSelf.view.mas_bottom);
        }
        make.top.equalTo(weakSelf.navbarView.mas_bottom);
        make.width.equalTo(weakSelf.view.mas_width);
        make.left.equalTo(weakSelf.view.mas_left);
    }];
    [_deleteView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (kIsiOS11) {
            make.bottom.equalTo(weakSelf.view.mas_bottom).offset(200);
        } else {
            make.bottom.equalTo(weakSelf.view.mas_bottom).offset(200);
        }
        make.left.equalTo(weakSelf.view.mas_left);
        make.width.equalTo(weakSelf.view.mas_width);
        make.height.mas_equalTo(148);
    }];

}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _listModels.models.count;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    CostumCollectionViewCell *cell = (CostumCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    cell.tag = 1000 +indexPath.row;
    ZLPhotoModel *model = _listModels.models[indexPath.row];
    [cell reloadData:model Type:chooseType];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ZLPhotoModel *model = _listModels.models[indexPath.row];
    if (!_isMoreSelect) {
        if (model.type == ZLAssetMediaTypeVideo && !_noNeedCutVideo) {
            VideoEditorViewController *videoVC = [[VideoEditorViewController alloc] init];
            videoVC.model = model;
            videoVC.videoNeedTime = self.needVideoTime;
            videoVC.needVideoHeight = self.needEditorSize.height;
            videoVC.needVideoWeight = self.needEditorSize.width;
            [self.navigationController pushViewController:videoVC animated:YES];
        } else {
            [self requestSelectedPhotos:@[model]];
        }
        return;
    }
    if (!model.selected) {
        if (_chooseArray.count < self.maxPage) {
            [_chooseArray addObject:model];
            if (_chooseArray.count >= 1) {
                [self.deleteView mas_updateConstraints:^(MASConstraintMaker *make) {
                    if (kIsiOS11) {
                        make.bottom.equalTo(self.view.mas_bottom);
                    } else {
                        make.bottom.equalTo(self.view.mas_bottom);
                    }
                }];
            }
            model.selected = !model.selected;
            for (int i = 0; i < _chooseArray.count; i ++) {
                ZLPhotoModel *selectModel = _chooseArray[i];
                selectModel.indexPath = i+1;
            }
        } else {
            
        }
        
    } else {
        [_chooseArray removeObject:model];
        _listModels.selectedModels = _chooseArray;
        if (_chooseArray.count < 1) {
            [self upDateConstrains];
        }
        model.selected = !model.selected;
        for (int i = 0; i < _chooseArray.count; i ++) {
            ZLPhotoModel *selectModel = _chooseArray[i];
            selectModel.indexPath = i+1;
        }
    }
    
    //[collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]]];
    [self reloadDatacollectionView];
    [self.deleteView reloadDataWithArr:_chooseArray];
}
- (void)upDateConstrains {
    [self.deleteView mas_updateConstraints:^(MASConstraintMaker *make) {
        if (kIsiOS11) {
            make.bottom.equalTo(self.view.mas_bottom).offset(200);
        } else {
            make.bottom.equalTo(self.view.mas_bottom).offset(200);
        }
    }];
}
- (void)reloadDatacollectionView {
    [CATransaction setDisableActions:YES];
    [self.collectionView reloadData];
    [CATransaction commit];
}
- (void)requestSelectedPhotosPath:(NSArray*)imageArr {
    kWeakSelf(self);
    ZLProgressHUD *hud = [[ZLProgressHUD alloc] init];
    [hud show];
    __block NSMutableArray *imagePaths = [NSMutableArray arrayWithCapacity:imageArr.count];
    NSString * placeHolder = @"";
    for (int i = 0; i < imageArr.count; i++) {
        [imagePaths addObject:placeHolder];
    }
    for (int i = 0; i< imageArr.count; i++) {
        ZLPhotoModel *model = imageArr[i];
        [PhotoManger requestSelectedImageForAsset:model isOriginal:self.isOriginal allowSelectGif:NO completion:^(UIImage * image, NSDictionary *data) {
            if ([[data objectForKey:PHImageResultIsDegradedKey] boolValue]) return;
            // kStrongify(weakSelf);
            // NSURL *filePath;
            if (image) {
                if (model.asset.mediaType == PHAssetMediaTypeVideo) {
                    [self requestVideoWith:model.asset WithCompletion:^(NSString *path) {
                        if (path != nil) {
                            [imagePaths replaceObjectAtIndex:i withObject:path];
                            if (![imagePaths containsObject:placeHolder])
                            {
                                if (weakSelf.selectImagesPath) {
                                    weakSelf.selectImagesPath(imagePaths);
                                }
                                [hud hide];
                                [weakSelf dismissViewControllerAnimated:YES completion:^{
                                }];
                            }
                        }
                    }];
                } else {
                    NSURL *url = [data objectForKey:@"PHImageFileURLKey"];
                    if (url.absoluteString != nil) {
                        NSString *subString = [url.absoluteString substringFromIndex:7];
                        [imagePaths replaceObjectAtIndex:i withObject:subString];
                    }
                }
            }
            if (![imagePaths containsObject:placeHolder]) {
                if (weakSelf.selectImagesPath) {
                    weakSelf.selectImagesPath(imagePaths);
                }
                [hud hide];
                [weakSelf dismissViewControllerAnimated:YES completion:^{
                    
                }];
            }
            
        }];
    }
}

- (void)requestSelectedPhotos:(NSArray*)imageArr {
    kWeakSelf(self);
    ZLProgressHUD *hud = [[ZLProgressHUD alloc] init];
    [hud show];
    __block NSMutableArray *photos = [NSMutableArray arrayWithCapacity:imageArr.count];
    __block NSMutableArray *assets = [NSMutableArray arrayWithCapacity:imageArr.count];
    for (int i = 0; i < imageArr.count; i++) {
        [photos addObject:@""];
        [assets addObject:@""];
    }
    __block BOOL isDone = false;
    for (int i = 0; i< imageArr.count; i++) {
        ZLPhotoModel *model = imageArr[i];
        [PhotoManger requestSelectedImageForAsset:model isOriginal:NO allowSelectGif:NO completion:^(UIImage * image, NSDictionary *data) {
//            if ([[data objectForKey:PHImageResultIsDegradedKey] boolValue]) return;
           // kStrongify(weakSelf);
            if (image) {
                [photos replaceObjectAtIndex:i withObject:[PhotoManger scaleImage:image original: NO || model.asset.mediaType == PHAssetMediaTypeVideo]];
                [assets replaceObjectAtIndex:i withObject:model.asset];
            }
            for (id obj in assets) {
                if ([obj isKindOfClass:[NSString class]]) return;
            }
            if (isDone) {
                return;
            }
            isDone = true;
            [weakSelf selectImages:photos WithAsset:assets WithHUD:hud];
            
        }];
    }
    
}
- (void)selectImages:(NSArray*)images WithAsset:(NSArray*)assets WithHUD:(ZLProgressHUD*)hud{
        NSMutableArray *mediaPaths = [NSMutableArray array];//视频路径
        NSString * placeHolder = @"";
        for (NSUInteger i = 0; i < assets.count; i++)
        {
            [mediaPaths addObject:placeHolder];
        }
        kWeakSelf(self);
        for (int i = 0; i < assets.count; i++) {
            PHAsset *phAsset = assets[i];
            if (phAsset.mediaType == PHAssetMediaTypeVideo) {
                [self requestVideoWith:phAsset WithCompletion:^(NSString * path) {

                    [mediaPaths replaceObjectAtIndex:i withObject:path];
                   if (![mediaPaths containsObject:placeHolder])
                    {
                        [hud hide];
                        if (self.isPushNextView) {
                            [weakSelf goNextView:images ImagePath:mediaPaths];
                        } else {
                            dispatch_sync(dispatch_get_main_queue(), ^{
                                
                                if (weakSelf.selectBlock) {
                                    weakSelf.selectBlock(images, mediaPaths);
                                }
                                [weakSelf dismissViewControllerAnimated:YES completion:^{
                                    
                                }];
                                
                            });
                        }
                    }
                }];
            }else if (phAsset.mediaType == PHAssetMediaTypeImage){
                UIImage *img = images[i];
                NSData *data = UIImageJPEGRepresentation(img, 0.5);
                NSString *path = [SXPinTuAssetModel generateRandomNamedFileWithExtension:@".jpg"];
                //写入
                 [data writeToFile:path atomically:YES];
                [mediaPaths replaceObjectAtIndex:i withObject:path];
                
                if (![mediaPaths containsObject:placeHolder])
                {
                    [hud hide];
                    if (self.isPushNextView) {
                        [weakSelf goNextView:nil ImagePath:mediaPaths];
                    } else {
                        
                        if (weakSelf.selectBlock) {
                            weakSelf.selectBlock(images, mediaPaths);
                        }
                        [weakSelf dismissViewControllerAnimated:YES completion:^{
                            
                        }];
                        
                    }
                    
                }
            }
        }
}
- (void)requestVideoWith:(PHAsset*)asset WithCompletion:(void (^)(NSString*))completion{
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    PHImageManager *manager = [PHImageManager defaultManager];
    [manager requestAVAssetForVideo:asset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
        
        AVURLAsset *urlAsset = (AVURLAsset *)asset;
        NSURL *url = urlAsset.URL;
        NSString *lastStr = [url absoluteString];
        if (lastStr != nil) {
            NSString *file = [lastStr substringFromIndex:7];
            if (completion) {
                completion(file);
            }
        } else {
            if (completion) {
                completion(@"");
            }
        }
    }];
}
- (void)backSuperView {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)backView {
    if (self.isPushNextView) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
    
}
- (void)goNextView:(NSArray*)images ImagePath:(NSArray*)path {
    VideoPreviewViewController *videoPredview = [[VideoPreviewViewController alloc] init];
    videoPredview.imagePaths = [[NSMutableArray alloc] initWithArray:path];
    [self.navigationController pushViewController:videoPredview animated:YES];
}

- (void)chooseAblum {
    if (self.chooseArray.count > 0) {
        [self showAlertView:@"切换相册将会把当前选择清除掉" isMoreAction:YES isGOAblum:YES];
    } else {
        [self goToChooseAblum];
    }
}
- (void)goToChooseAblum {
    AllAblumViewController *allVC = [[AllAblumViewController alloc] init];
    allVC.allowSelectVideo = self.allowSelectVideo;
    allVC.allowSelsctImage = self.allowSelectImage;
    [self.chooseArray removeAllObjects];
    self.listModels.selectedModels = self.chooseArray;
    kWeakSelf(self);
    [allVC backViewWith:^(ZLAlbumListModel *model) {
        weakSelf.listModels = model;
        [weakSelf.selectAblumBtn setTitle:model.title forState:UIControlStateNormal];
        [weakSelf.collectionView reloadData];
        [weakSelf upDateConstrains];
        [weakSelf.deleteView.deleteCollectionView reloadData];
    }];
    [self.navigationController pushViewController:allVC animated:YES];
}
- (void)isSureChoose{
    if (_isMoreSelect) {
        if (self.chooseArray.count < self.maxPage) {
            [self showAlertView:[NSString stringWithFormat:@"还剩%lu张照片没选，是否退出",self.maxPage - self.chooseArray.count] isMoreAction:YES isGOAblum:NO];
        } else {
            
            if (self.shouldAnialysisAsset) {
                [self requestSelectedPhotos:self.chooseArray];
            } else {
                [self requestSelectedPhotosPath:self.chooseArray];
            }
        }
    }
    
}
- (void)gotoNextViewVC {
    ZLPhotoModel *model = _listModels.selectedModels[0];
    if (model.type == ZLAssetMediaTypeVideo) {
        VideoEditorViewController *videoVC = [[VideoEditorViewController alloc] init];
        videoVC.model = model;
        videoVC.needVideoHeight = self.needEditorSize.height;
        videoVC.needVideoWeight = self.needEditorSize.width;
        [self.navigationController pushViewController:videoVC animated:YES];
    }
}
- (void)sureChooseBtn {
    NSLog(@"这个确认的图是%@",self.chooseArray);
    [self isSureChoose];
}
- (void)showAlertView:(NSString*)name isMoreAction:(BOOL)isMore isGOAblum:(BOOL)isAblum {
    UIAlertController *alertCV = [UIAlertController alertControllerWithTitle:@"提示" message:name preferredStyle:UIAlertControllerStyleAlert];
    NSString *str;
    if (isMore) {
        kWeakSelf(self);
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (isAblum) {
                [weakSelf goToChooseAblum];
            } else {
                if (weakSelf.shouldAnialysisAsset) {
                    [weakSelf requestSelectedPhotos:weakSelf.chooseArray];
                } else {
                    [weakSelf requestSelectedPhotosPath:weakSelf.chooseArray];
                }
            }
        }] ;
        [alertCV addAction:action1];
        str = @"取消";
    } else {
        str = @"确认";
    }
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:str style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertCV addAction:action2];
    [self presentViewController:alertCV animated:YES completion:^{
        
    }];
}

- (void)showPhotoLibrary {
    kWeakSelf(self);
    _hud = [[ZLProgressHUD alloc] init];
    [_hud show];
    PHAuthorizationStatus oldStatus = [PHPhotoLibrary authorizationStatus];
    switch (oldStatus) {
        case PHAuthorizationStatusNotDetermined: {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                kStrongify(weakSelf);
                if (status == PHAuthorizationStatusAuthorized) {
                    [strongSelf getAllAblumPhotos];
                } else {
                    [strongSelf.hud hide];
                    [strongSelf dismissViewControllerAnimated:YES completion:nil];
                }
            }];
            break;
        }
        case PHAuthorizationStatusAuthorized:
            [self getAllAblumPhotos];
            break;
        case PHAuthorizationStatusDenied:
            [weakSelf jumpSetWith:@"相册"];
            break;
        case PHAuthorizationStatusRestricted:
            [weakSelf jumpSetWith:@"相册"];
            break;
        default:
            break;
    }
}
- (void)jumpSetWith:(NSString*)str {
    UIAlertController *alertCV = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"请在在设置中打开app的%@权限",str] preferredStyle:UIAlertControllerStyleAlert];
    kWeakSelf(self);
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url options:nil completionHandler:^(BOOL success) {
                if (success) {
                    
                }
            }];
            kStrongify(weakSelf);
            [strongSelf dismissViewControllerAnimated:YES completion:nil];
            [strongSelf.hud hide];
        }
    }] ;
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        kStrongify(weakSelf);
        [strongSelf dismissViewControllerAnimated:YES completion:^{
            
        }];
        [strongSelf.hud hide];
    }];
    [alertCV addAction:action1];
    [alertCV addAction:action2];
    [self presentViewController:alertCV animated:YES completion:^{
        
    }];
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
