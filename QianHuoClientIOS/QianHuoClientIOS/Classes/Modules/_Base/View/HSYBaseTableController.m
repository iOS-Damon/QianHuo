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
#import "UIScreen+FY.h"
#import "Masonry.h"
#import "FYUtils.h"

static CGFloat const HSYReturnTopBtnHeightScale = 0.09;
static CGFloat const HSYReturnTopBtnLeftEdgeScale = 0.05;
static CGFloat const HSYReturnTopBtnBottomEdgeScale = 0.2;

@interface HSYBaseTableController ()

@property (nonatomic, strong) UIButton *returnTopBtn;
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
    
    //设置返回按钮
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] init];
    backBarButtonItem.title = @"关闭";
    self.navigationItem.backBarButtonItem = backBarButtonItem;
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    //下拉刷新
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = FYColorMain;
    [self.refreshControl addTarget:self action:@selector(pullDownRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    //上拉刷新
    HSYBaseTableController __weak *weakSelf = self;
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf pullUpRefresh:nil];
    }];
    
    //返回顶部按钮
    self.returnTopBtn = [[UIButton alloc] init];
    [self.returnTopBtn setBackgroundImage:[UIImage imageNamed:@"ReturnToTop.png"] forState:UIControlStateNormal];
    [self.returnTopBtn addTarget:self action:@selector(returnTop:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.returnTopBtn];
    [self.view bringSubviewToFront:self.returnTopBtn];
    CGFloat returnTopBtnH = [UIScreen screenShortSide] * HSYReturnTopBtnHeightScale;
    CGFloat leftEdge = [UIScreen screenShortSide] * HSYReturnTopBtnLeftEdgeScale;
    CGFloat bottomEdge = [UIScreen screenShortSide] * HSYReturnTopBtnBottomEdgeScale;
    [self.returnTopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(returnTopBtnH);
        make.width.mas_equalTo(returnTopBtnH);
        make.right.equalTo(self.view.mas_right).offset(- leftEdge);
        make.bottom.equalTo(self.view.mas_bottom).offset(- bottomEdge);
    }];
    
    self.returnTopBtn.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)pullDownRefresh:(id)sender {
    
}

- (void)pullUpRefresh:(id)sender {
    
}

- (void)endPullUpRefresh {
    [self.tableView.infiniteScrollingView stopAnimating];
}

- (void)returnTop:(id)sender {

    NSUInteger index[] = {0, 0};
    NSIndexPath *path = [[NSIndexPath alloc] initWithIndexes:index length:2];
    [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

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

#pragma mark - Scroll View Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat y = scrollView.contentOffset.y;
    if (y > 0) {
        self.returnTopBtn.hidden = NO;
    } else {
        self.returnTopBtn.hidden = YES;
    }
}

@end
