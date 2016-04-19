//
//  HSYLikeController.m
//  QianHuoClientIOS
//
//  Created by Sean on 16/4/19.
//  Copyright © 2016年 deeepthinking. All rights reserved.
//

#import "HSYLikeController.h"
#import "HSYCommonCell.h"
#import "HSYLikeViewmodel.h"
#import "UIScreen+FY.h"
#import "HSYConstant.h"
#import "HSYContentController.h"

static NSString * const HSYLikeCellID = @"HSYLikeCellID";

@interface HSYLikeController () <HSYIsLikeBottonDelegate>

@property (nonatomic, strong) HSYLikeViewmodel *viewmodel;

@end

@implementation HSYLikeController

- (instancetype)init {
    
    self = [super init];
    if (self) {
        self.viewmodel = [[HSYLikeViewmodel alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.tableView registerClass:[HSYCommonCell class] forCellReuseIdentifier:HSYLikeCellID];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    self.navigationController.toolbarHidden = YES;
    [self.viewmodel refreshData];
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.viewmodel rowsCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HSYCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:HSYLikeCellID forIndexPath:indexPath];
    cell.avatarImage = [self.viewmodel rowAvatarAtIndexPath:indexPath];
    cell.isLike = [self.viewmodel rowIsLike:indexPath];
    cell.title = [self.viewmodel rowTitleAtIndexPath:indexPath];
    cell.desc = [self.viewmodel rowDescAtIndexPath:indexPath];
    cell.hasRead = [self.viewmodel rowHasRead:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [UIScreen screenLongSide] * HSYCommonCellHeightScale;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *urlStr = [self.viewmodel rowUrlAtIndexPath:indexPath];
    HSYContentController *contentVC = [[HSYContentController alloc] initWithUrl:urlStr];
    contentVC.isLike = [self.viewmodel rowIsLike:indexPath];
    contentVC.indexPath = indexPath;
    contentVC.delegate = self;
    
    //隐藏tabbar 当要进入子页面时
    contentVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:contentVC animated:YES];
    
    //标记为已读
    [self.viewmodel saveRowHasRead:indexPath];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:NO];
}

#pragma mark - override
- (void)pullDownRefresh:(id)sender {
    [self.viewmodel refreshData];
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

- (void)pullUpRefresh:(id)sender {
    [self endPullUpRefresh];
}

#pragma mark - HSYIsLikeBottonDelegate
- (void)isLikeButtonDidSeleted:(BOOL)seleted indexPath:(NSIndexPath *)indexPath {
    [self.viewmodel saveRowIsLike:seleted indexPath:indexPath];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:NO];
}

@end
