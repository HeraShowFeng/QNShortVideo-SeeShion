//
//  SXViewController.m
//  SXEditDemo
//
//  Created by Yin Xie on 2018/12/19.
//  Copyright © 2018 Yin Xie. All rights reserved.
//

#import "SXViewController.h"
#import "SXTemplateListViewController.h"
#import "SXEditViewController.h"
#import "ChoosePhotoViewController.h"
#import "VideoPreviewViewController.h"
@interface SXViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, copy) NSArray *types;
@property (nonatomic, strong) UIButton *backButton;
@end

@implementation SXViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    // Do any additional setup after loading the view.
//    [self.navigationController.navigationBar setHidden:true];
    _types = @[@{@"title" : @"标准模板",
                 @"detail" : @"标准模板是指从After Effects中导出的，固定时间长度，支持固定数量和固定类型素材的视频模板。标准模板能够很好地将设计师的设计能力与用户素材相结合，制作出趣味性、创意性十足的视频内容",
                 @"folder" : @"standard"},
               @{@"title" : @"动态模板",
                 @"detail" : @"动态模板是指从After Effects中导出的一种特殊视频模板，它不限制用户使用的素材数量，能够根据用户实际使用的素材数量动态调节最终生成的视频长度。适合制作影集、音乐相册等视频内容",
                 @"folder" : @"dynamic"},
               @{@"title":@"模板实时预览",@"detail":@"模板实时预览能够在不需要将模板渲染导出视频的情况下实时预览模板的效果。注意，模板实时预览的性能受手机硬件和模板的复杂i性影响。"},
               ];
}

- (void)setupView {
    self.view.backgroundColor = [UIColor blackColor];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, self.view.bounds.size.width, 45)];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.text = @"AE 特效";
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:self.titleLabel];
    
    self.backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 30, 45, 45)];
    UIImage *image = [UIImage imageNamed:@"return_icon"];
    [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.backButton addTarget:self action:@selector(backAct:) forControlEvents:UIControlEventTouchUpInside];
    [self.backButton setImage:image forState:UIControlStateNormal];
    self.backButton.imageView.tintColor = UIColor.blackColor;
    [self.view addSubview:self.backButton];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 80, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor blackColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)backAct:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - tableview

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _types.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = _types[indexPath.row][@"title"];
    cell.detailTextLabel.text = _types[indexPath.row][@"detail"];
    cell.detailTextLabel.numberOfLines = 0;
    cell.backgroundColor = [UIColor blackColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    if (indexPath.row == 2) {
        ChoosePhotoViewController *chooseView = [[ChoosePhotoViewController alloc] init];
        chooseView.allowSelectVideo = NO;
        chooseView.isMoreSelect = YES;
        chooseView.maxPage = 100;
        [chooseView setSelectBlock:^(NSArray * _Nonnull images, NSArray * _Nonnull files) {
            VideoPreviewViewController *videoPredview = [[VideoPreviewViewController alloc] init];
            videoPredview.imagePaths = [[NSMutableArray alloc] initWithArray:files];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:videoPredview animated:YES completion:nil];
            });
            
        }];
        [self presentViewController:chooseView animated:YES completion:nil];
        
    }else {
        SXTemplateListViewController *templateListViewController = [[SXTemplateListViewController alloc] init];
        NSString *folderName = _types[indexPath.row][@"folder"];
        templateListViewController.folderPath = [[NSBundle mainBundle] pathForResource:folderName ofType:nil inDirectory:@"test"];
        templateListViewController.navTitle = _types[indexPath.row][@"title"];
        [self presentViewController:templateListViewController animated:YES completion:nil];
    }
   
}

@end
