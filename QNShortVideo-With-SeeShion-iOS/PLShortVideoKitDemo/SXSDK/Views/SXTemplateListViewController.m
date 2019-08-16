//
//  SXTemplateListViewController.m
//  SXEditDemo
//
//  Created by Yin Xie on 2018/12/18.
//  Copyright © 2018 Yin Xie. All rights reserved.
//

#import "SXTemplateListViewController.h"
#import "SXEditViewController.h"
#import "ChoosePhotoViewController.h"
#import "VideoPreviewViewController.h"
@interface SXTemplateListViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) NSMutableArray *templates;
@end

@implementation SXTemplateListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
    [self manageList];
}

- (void)setupView {
    
    self.view.backgroundColor = [UIColor blackColor];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, self.view.bounds.size.width, 45)];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.text = _navTitle;
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


- (void)manageList {
    NSString *infoPath = [_folderPath stringByAppendingPathComponent:@"info.json"];
    NSData *data = [NSData dataWithContentsOfFile:infoPath];
    NSError *error;
    _templates = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    [_tableView reloadData];
}

- (void)backAct:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - tableview

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _templates.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = _templates[indexPath.row][@"name"];
    cell.detailTextLabel.text = _templates[indexPath.row][@"description"];
    cell.detailTextLabel.numberOfLines = 0;
    cell.backgroundColor = [UIColor blackColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
        SXEditViewController *editViewController = [[SXEditViewController alloc] init];
        NSString *folderName = _templates[indexPath.row][@"folder"];
        editViewController.templatePath = [_folderPath stringByAppendingPathComponent:folderName];
        [self presentViewController:editViewController animated:YES completion:nil];
}
@end
