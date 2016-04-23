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

static NSString * const HSYLearningCellID = @"HSYLearningCellID";
static NSString * const HSYLearningHeaderID = @"HSYLearningHeaderID";

@interface HSYLearningController () <HSYBindingParamProtocol, HSYLikeButtonDelegate>

@property (nonatomic, strong) HSYLearningViewmodel *viewmodel;
@property (nonatomic, strong) FBKVOController *KVOController;

@end

@implementation HSYLearningController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.viewmodel = [[HSYLearningViewmodel alloc] init];
        self.KVOController = [FBKVOController controllerWithObserver:self];
        [self bindingParam];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[HSYCommonCell class] forCellReuseIdentifier:HSYLearningCellID];
    [self.tableView registerClass:[HSYCommonHeader class] forHeaderFooterViewReuseIdentifier:HSYLearningHeaderID];
    
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
    HSYCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:HSYLearningCellID forIndexPath:indexPath];
    cell.avatarImage = [self.viewmodel rowAvatarAtIndexPath:indexPath];
    cell.isLike = [self.viewmodel rowIsLike:indexPath];
    cell.title = [self.viewmodel rowTitleAtIndexPath:indexPath];
    cell.desc = [self.viewmodel rowDescAtIndexPath:indexPath];
    cell.hasRead = [self.viewmodel rowHasRead:indexPath];
    cell.indexPath = indexPath;
    cell.delegate = self;
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
    
    HSYCommonHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HSYLearningHeaderID];
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
    
    [self.KVOController observe:self.viewmodel keyPath:@"requestError" options:NSKeyValueObservingOptionNew block:^(HSYLearningController *observer, HSYLearningViewmodel *object, NSDictionary *change) {
        
        [observer.refreshControl endRefreshing];
        [observer endPullUpRefresh];
        
        FYHintLayer *hint = [[FYHintLayer alloc] initWithMessege:HSYNetworkErrorHint duration:HSYHintDuration complete:nil];
        [hint show];
    }];
    
    [self.KVOController observe:self.viewmodel keyPath:@"isFirstLoad" options:NSKeyValueObservingOptionNew block:^(HSYLearningController *observer, HSYLearningViewmodel *object, NSDictionary *change) {
        
        if(object.isFirstLoad) {
            double delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                CGFloat offsetY = [self.viewmodel loadOffsetY];
                observer.tableView.contentOffset = CGPointMake(0, offsetY);
            });
        }
    }];
    
    [self.KVOController observe:self.viewmodel keyPath:@"isLoadingNew" options:NSKeyValueObservingOptionNew block:^(HSYLearningController *observer, HSYLearningViewmodel *object, NSDictionary *change) {
        
        if(object.isLoadingNew) {
            [observer.refreshControl beginRefreshing];
        } else {
            
            [observer.tableView reloadData];
            [observer.refreshControl endRefreshing];
            
            if(!object.isFirstLoad) {
                object.isFirstLoad = YES;
                CGFloat offsetY = [self.viewmodel loadOffsetY];
                observer.tableView.contentOffset = CGPointMake(0, offsetY);
            }
        }
    }];
    
    [self.KVOController observe:self.viewmodel keyPath:@"isLoadingMore" options:NSKeyValueObservingOptionNew block:^(HSYLearningController *observer, HSYLearningViewmodel *object, NSDictionary *change) {
        
        if(object.isLoadingMore) {
        } else {
            [observer.tableView reloadData];
            [observer endPullUpRefresh];
        }
    }];
}

#pragma mark - Scroller View Delegate
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    CGPoint point = scrollView.contentOffset;
    [self.viewmodel saveOffsetY:point.y];
}

#pragma mark - HSYIsLikeBottonDelegate
- (void)likeButtonDidSeleted:(BOOL)seleted indexPath:(NSIndexPath *)indexPath {
    
    [self.viewmodel saveRowIsLike:seleted indexPath:indexPath];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:NO];
}

@end
