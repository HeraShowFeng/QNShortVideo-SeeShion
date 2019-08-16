//
//  AllAblumViewController.m
//  CustomImagePickerController
//
//  Created by 李记波 on 2018/11/15.
//  Copyright © 2018年 李记波. All rights reserved.
//

#import "AllAblumViewController.h"

@interface AllAblumViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSArray<ZLAlbumListModel*> *modelArr;

@end

@implementation AllAblumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backView)];
    
    self.table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _table.dataSource = self;
    _table.delegate = self;
    _table.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_table];
    kWeakSelf(self);
    [_table mas_makeConstraints:^(MASConstraintMaker *make) {
        if (kIsiOS11) {
            make.bottom.equalTo(weakSelf.view.mas_bottom);
        } else {
            make.bottom.equalTo(weakSelf);
        }
        make.top.equalTo(weakSelf.navbarView.mas_bottom);
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        
    }];
    [PhotoManger getPhotoAblumList:_allowSelectVideo allowSelectImage:_allowSelsctImage complete:^(NSArray<ZLAlbumListModel *> * _Nonnull arr) {
        weakSelf.modelArr = arr;
        [weakSelf.table reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _modelArr.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuse"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@(%lu)",_modelArr[indexPath.row].title,(unsigned long)_modelArr[indexPath.row].models.count];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZLAlbumListModel *model = _modelArr[indexPath.row];
    if (_backeBlcok) {
        _backeBlcok(model);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)backViewWith:(BackBlock)block {
    if (block) {
        self.backeBlcok = block;
    }
}
- (void)backView {
    [self.navigationController popViewControllerAnimated:YES];
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
