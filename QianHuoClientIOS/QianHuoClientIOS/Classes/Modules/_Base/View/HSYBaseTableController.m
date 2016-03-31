//
//  HSYBaseTableController.m
//  QianHuoClientIOS
//
//  Created by Sean on 16/3/28.
//  Copyright © 2016年 deeepthinking. All rights reserved.
//

#import "HSYBaseTableController.h"
#import "UIView+FY.h"
#import "SVPullToRefresh.h"

@interface HSYBaseTableController ()

@property (nonatomic, assign) BOOL isPullUpRefresh;
@property (nonatomic, assign) CGFloat scrollViewLastOffsetY;

@end

@implementation HSYBaseTableController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.isPullUpRefresh = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = FYColorMain;
    [self.refreshControl addTarget:self action:@selector(pullDownRefresh:) forControlEvents:UIControlEventValueChanged];
    
    HSYBaseTableController __weak *weakSelf = self;
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf pullUpRefresh:nil];
    }];
}

- (void)pullDownRefresh:(id)sender {
    
}

- (void)pullUpRefresh:(id)sender {
    
}

- (void)endPullUpRefresh {
//    self.isPullUpRefresh = NO;
    [self.tableView.infiniteScrollingView stopAnimating];
}

#pragma mark - Scroll View Delegete
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    CGPoint offset = scrollView.contentOffset;
//    CGFloat offsetY = offset.y;
//    self.scrollViewLastOffsetY = offsetY;
//}
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGPoint offset = scrollView.contentOffset;
//    CGFloat offsetY = offset.y;
//    CGFloat viewH = scrollView.frameHeight;
//    CGFloat contentH = scrollView.contentSize.height;
//    NSLog(@"---%d---", self.isPullUpRefresh);
//    if (self.isPullUpRefresh) { //正在下拉刷新
//        return;
//    }
//    NSLog(@"offsetY = %f scrollViewLastOffsetY = %f", contentH, self.scrollViewLastOffsetY);
//    if (offsetY - self.scrollViewLastOffsetY > 10) { //向上滑动
//        NSLog(@"contentH = %f  offsetY = %f viewH = %f", contentH, offsetY, viewH);
//        if (contentH - offsetY - viewH < viewH) { //快到达底部
//            [self pullUpRefresh:nil];
//            self.isPullUpRefresh = YES;
//        }
//    }
//}

#pragma mark - TableView Delegate
/**
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}
**/

@end
