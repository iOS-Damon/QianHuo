//
//  HSYRestTimeController.m
//  QianHuoClientIOS
//
//  Created by Sean on 16/3/28.
//  Copyright © 2016年 deeepthinking. All rights reserved.
//

#import "HSYRestController.h"
#import "HSYRestFuliCell.h"
#import "UIScreen+FY.h"
#import "HSYCommonHeader.h"
#import "HSYCommonCell.h"
#import "HSYRestViewmodel.h"
#import "HSYBindingParamProtocol.h"
#import "FBKVOController.h"
#import "FYHintLayer.h"
#import "HSYContentController.h"
#import "UIScreen+FY.h"
#import "WFWebImageShowView.h"
#import "UIImageView+MHFacebookImageViewer.h"
#import "UIView+FY.h"
#import <SDWebImage/UIImageView+WebCache.h>

static NSString * const HSYRestFuliCellID = @"HSYRestFuliCellID";
static NSString * const HSYRestVedioCellID = @"HSYRestVedioCellID";
static NSString * const HSYRestHeaderID = @"HSYRestHeaderID";

@interface HSYRestController () <HSYBindingParamProtocol, HSYLikeButtonDelegate>

@property (nonatomic, strong) HSYRestViewmodel *viewmodel;
@property (nonatomic, strong) FBKVOController *KVOController;

@end

@implementation HSYRestController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.viewmodel = [[HSYRestViewmodel alloc] init];
        self.KVOController = [FBKVOController controllerWithObserver:self];
        [self bindingParam];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[HSYRestFuliCell class] forCellReuseIdentifier:HSYRestFuliCellID];
    [self.tableView registerClass:[HSYCommonCell class] forCellReuseIdentifier:HSYRestVedioCellID];
    [self.tableView registerClass:[HSYCommonHeader class] forHeaderFooterViewReuseIdentifier:HSYRestHeaderID];

    [self.viewmodel loadFirstValue];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.toolbarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [[SDImageCache sharedImageCache] clearMemory];
}

#pragma mark - Override HSYBaseTableController
- (void)pullDownRefresh:(id)sender {
    [self.viewmodel loadNewValue];
}

- (void)pullUpRefresh:(id)sender {
    [self.viewmodel loadMoreValue];
}

#pragma mark - HSYBindingParamProtocol
- (void)bindingParam {
    
    [self.KVOController observe:self.viewmodel keyPath:@"requestError" options:NSKeyValueObservingOptionNew block:^(HSYRestController *observer, HSYRestViewmodel *object, NSDictionary *change) {
        
        [observer.refreshControl endRefreshing];
        [observer endPullUpRefresh];
        
        FYHintLayer *hint = [[FYHintLayer alloc] initWithMessege:HSYNetworkErrorHint duration:HSYHintDuration complete:nil];
        [hint show];
    }];
    
    [self.KVOController observe:self.viewmodel keyPath:@"noMore" options:NSKeyValueObservingOptionNew block:^(HSYRestController *observer, HSYRestViewmodel *object, NSDictionary *change) {
        
        if(object.noMore) {
            [observer endPullUpRefresh];
            FYHintLayer *hint = [[FYHintLayer alloc] initWithMessege:HSYNoMoreHint duration:HSYHintDuration complete:nil];
            [hint show];
        }
    }];
    
    [self.KVOController observe:self.viewmodel keyPath:@"isLoadingNew" options:NSKeyValueObservingOptionNew block:^(HSYRestController *observer, HSYRestViewmodel *object, NSDictionary *change) {
        
        if(object.isLoadingNew) {
            [observer.refreshControl beginRefreshing];
        } else {
            
            [observer.tableView reloadData];
            [observer.refreshControl endRefreshing];
            
            if(!object.isFirstLoad) {
                
                object.isFirstLoad = YES;
    
                double delayInSeconds = 0.5;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    
                    NSInteger section = [observer.viewmodel loadCurrentSection];
                    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:section];
                    [observer.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:NO];
                });
            }
        }
    }];
    
    [self.KVOController observe:self.viewmodel keyPath:@"isLoadingMore" options:NSKeyValueObservingOptionNew block:^(HSYRestController *observer, HSYRestViewmodel *object, NSDictionary *change) {
        
        if(object.isLoadingMore) {
        } else {
            [observer.tableView reloadData];
            [observer endPullUpRefresh];
        }
    }];
}

#pragma mark - TableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.viewmodel sectionsCount];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewmodel rowsCountInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row < [self.viewmodel rowsFuliCountInSection:indexPath.section]) {
        HSYRestFuliCell *fuliCell = [tableView dequeueReusableCellWithIdentifier:HSYRestFuliCellID forIndexPath:indexPath];
        fuliCell.url = [self.viewmodel rowUrlAtIndexPath:indexPath];
        return fuliCell;
    } else {
        HSYCommonCell *vedioCell = [tableView dequeueReusableCellWithIdentifier:HSYRestVedioCellID forIndexPath:indexPath];
        vedioCell.avatarImage = [self.viewmodel rowAvatarAtIndexPath:indexPath];
        vedioCell.title = [self.viewmodel rowTitleAtIndexPath:indexPath];
        vedioCell.desc = [self.viewmodel rowDescAtIndexPath:indexPath];
        vedioCell.isLike = [self.viewmodel rowIsLike:indexPath];
        vedioCell.hasRead = [self.viewmodel rowHasRead:indexPath];
        vedioCell.indexPath = indexPath;
        vedioCell.delegate = self;
        return vedioCell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < [self.viewmodel rowsFuliCountInSection:indexPath.section]) {
        //以屏幕的短边 作为cell的高
        return [UIScreen screenShortSide];
    } else {
        return [UIScreen screenLongSide] * HSYCommonCellHeightScale;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [UIScreen screenLongSide] * HSYCommonHeaderHeightScale;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    HSYCommonHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HSYRestHeaderID];
    header.title = [self.viewmodel headerTitleInSection:section];
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *urlStr = [self.viewmodel rowUrlAtIndexPath:indexPath];
    
    if (indexPath.row < [self.viewmodel rowsFuliCountInSection:indexPath.section]) {
        
        WFWebImageShowView *showImageView = [[WFWebImageShowView alloc] initWithImageUrl:urlStr];
        
        [showImageView show:[[UIApplication sharedApplication] keyWindow] didFinish:^{
            [showImageView removeFromSuperview];
        }];
    } else {
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
}

#pragma mark - HSYLikeButtonDelegate
- (void)likeButtonDidSeleted:(BOOL)seleted indexPath:(NSIndexPath *)indexPath {
    [self.viewmodel saveRowIsLike:seleted indexPath:indexPath];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:NO];
}

#pragma mark - Scroller View Delegate
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    CGPoint point = scrollView.contentOffset;

    NSIndexPath *index = [self.tableView indexPathForRowAtPoint:point];
    // 保存当前正在浏览的section
    [self.viewmodel saveCurrentSection:index.section];
}

@end
