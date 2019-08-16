//
//  SXTextEditFontView.m
//  SXEditDemo
//
//  Created by 李记波 on 2018/12/12.
//  Copyright © 2018年 Yin Xie. All rights reserved.
//

#import "SXTextEditFontView.h"
#import "SXTextFontTableViewCell.h"

@implementation SXTextEditFontView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
       // self.tableView.separatorColor = [UIColor colorWithHexString:kGreyishColor];
        [self addSubview:self.tableView];
    }
    return self;
}
- (void)upDateTableView {
    NSArray *nameArr = [UIFont familyNames];
    self.fontArr = [NSMutableArray array];
    for (int i = 0 ; i < nameArr.count; i++) {
        NSArray *name = [UIFont fontNamesForFamilyName:nameArr[i]];
        if (name.count != 0) {
           [self.fontArr addObjectsFromArray:name];
        }
    }
    [self.tableView reloadData];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.0f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.fontArr.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SXTextFontTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[SXTextFontTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuse"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *nameStr = [self.fontArr objectAtIndex:indexPath.row];
    [cell upDateWithText:nameStr];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *nameStr = [self.fontArr objectAtIndex:indexPath.row];
    if (self.selectTextFontBlock) {
        self.selectTextFontBlock(nameStr);
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
