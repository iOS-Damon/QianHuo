//
//  HSYLearningTimeController.m
//  QianHuoClientIOS
//
//  Created by Sean on 16/3/28.
//  Copyright © 2016年 deeepthinking. All rights reserved.
//

#import "HSYLearningController.h"
#import "HSYLearningViewmodel.h"
#import "HSYCommonCell.h"
#import "HSYCommonHeader.h"
#import "UIScreen+FY.h"
#import "HSYBindingParamProtocol.h"
#import "FBKVOController.h"
#import "FYHintLayer.h"
#import "HSYContentController.h"

static NSString * const HSYLearningTimeCellID = @"HSYLearningTimeCellID";
static NSString * const HSYLearningTimeHeaderID = @"HSYLearningTimeHeaderID";

@interface HSYLearningController () <HSYBindingParamProtocol, HSYIsLikeBottonDelegate>

@property (nonatomic, strong) HSYLearningViewmodel *viewmodel;
@property (nonatomic, strong) FBKVOController *KVOController;

@end

@implementation HSYLearningController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.viewmodel = [[HSYLearningViewmodel alloc] init];
        [self bindingParam];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = HSYRootTitle;
    [self.tableView registerClass:[HSYCommonCell class] forCellReuseIdentifier:HSYLearningTimeCellID];
    [self.tableView registerClass:[HSYCommonHeader class] forHeaderFooterViewReuseIdentifier:HSYLearningTimeHeaderID];
    
    [self.refreshControl beginRefreshing];
    [self.viewmodel loadFirstValue];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.toolbarHidden = YES;
}

- (void)pullDownRefresh:(id)sender {
    [self.viewmodel loadNewValue];
}

- (void)pullUpRefresh:(id)sender {
    [self.viewmodel loadMoreValue];
}

#pragma mark - TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.viewmodel sectionsCount];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewmodel rowsCountInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HSYCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:HSYLearningTimeCellID forIndexPath:indexPath];
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [UIScreen screenLongSide] * HSYCommonHeaderHeightScale;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    [self.viewmodel savePage:section];
    
    HSYCommonHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HSYLearningTimeHeaderID];
    header.title = [self.viewmodel headerTitleInSection:section];
    return header;
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

#pragma mark - HSYBindingParamProtocol
- (void)bindingParam {
    self.KVOController = [FBKVOController controllerWithObserver:self];
    [self.KVOController observe:self.viewmodel keyPath:@"dateModels" options:NSKeyValueObservingOptionNew block:^(HSYLearningController *observer, HSYLearningViewmodel *object, NSDictionary *change) {
        
        [observer.tableView reloadData];
        [observer.refreshControl endRefreshing];
        [observer endPullUpRefresh];
    }];
    
    [self.KVOController observe:self.viewmodel keyPath:@"requestError" options:NSKeyValueObservingOptionNew block:^(HSYLearningController *observer, HSYLearningViewmodel *object, NSDictionary *change) {
        
        [observer.refreshControl endRefreshing];
        [observer endPullUpRefresh];
        
        FYHintLayer *hint = [[FYHintLayer alloc] initWithMessege:HSYNetworkErrorHint duration:HSYHintDuration complete:nil];
        [hint show];
    }];
    
    [self.KVOController observe:self.viewmodel keyPath:@"isFirstLoad" options:NSKeyValueObservingOptionNew block:^(HSYLearningController *observer, HSYLearningViewmodel *object, NSDictionary *change) {
        
        if(object.isFirstLoad) {
            CGFloat offsetY = [self.viewmodel loadOffsetY];
            observer.tableView.contentOffset = CGPointMake(0, offsetY);
        }
    }];
}

#pragma mark - Scroller View Delegate
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    CGPoint point = scrollView.contentOffset;
    [self.viewmodel saveOffsetY:point.y];
}

#pragma mark - HSYIsLikeBottonDelegate
- (void)isLikeButtonDidSeleted:(BOOL)seleted indexPath:(NSIndexPath *)indexPath {
    
    [self.viewmodel saveRowIsLike:seleted indexPath:indexPath];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:NO];
}

@end
