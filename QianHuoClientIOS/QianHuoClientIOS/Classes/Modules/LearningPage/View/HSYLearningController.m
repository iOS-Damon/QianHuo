//
//  HSYLearningTimeController.m
//  QianHuoClientIOS
//
//  Created by Sean on 16/3/28.
//  Copyright © 2016年 deeepthinking. All rights reserved.
//

#import "HSYLearningController.h"
#import "HSYLearningViewmodel.h"
#import "HSYLearningCell.h"
#import "HSYLearningHeader.h"
#import "UIScreen+FY.h"
#import "HSYBindingParamProtocol.h"
#import "FBKVOController.h"
#import "FYHintLayer.h"
#import "HSYContentController.h"

static NSString * const HSYLearningTimeCellID = @"HSYLearningTimeCellID";
static NSString * const HSYLearningTimeHeaderID = @"HSYLearningTimeHeaderID";
static CGFloat const HSYLearnTimeCellHeightScale = 0.1;
static CGFloat const HSYLearnTimeHeaderHeightScale = 0.05;

@interface HSYLearningController () <HSYBindingParamProtocol>

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
    
    self.title = HSYRootTitle;
    [self.tableView registerClass:[HSYLearningCell class] forCellReuseIdentifier:HSYLearningTimeCellID];
    [self.tableView registerClass:[HSYLearningHeader class] forHeaderFooterViewReuseIdentifier:HSYLearningTimeHeaderID];
    
    [self.refreshControl beginRefreshing];
    [self.viewmodel loadFirstValue];
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
    HSYLearningCell *cell = [tableView dequeueReusableCellWithIdentifier:HSYLearningTimeCellID forIndexPath:indexPath];
        cell.title = [self.viewmodel rowDescAtIndexPath:indexPath];
    cell.avatarImage = [self.viewmodel rowAvatarAtIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [UIScreen screenLongSide] * HSYLearnTimeCellHeightScale;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [UIScreen screenLongSide] * HSYLearnTimeHeaderHeightScale;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HSYLearningHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HSYLearningTimeHeaderID];
    header.title = [self.viewmodel headerTitleInSection:section];
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *urlStr = [self.viewmodel rowUrlAtIndexPath:indexPath];
    HSYContentController *contentVC = [[HSYContentController alloc] initWithUrl:urlStr];
    contentVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:contentVC animated:YES];
}

#pragma mark - HSYBindingParamProtocol
- (void)bindingParam {
    self.KVOController = [FBKVOController controllerWithObserver:self];
    [self.KVOController observe:self.viewmodel keyPath:@"dateModels" options:NSKeyValueObservingOptionNew block:^(HSYLearningController *controller, HSYLearningViewmodel *viewmodel, NSDictionary *change) {
        
        [controller.tableView reloadData];
        [self.refreshControl endRefreshing];
        [self endPullUpRefresh];
    }];
    
    [self.KVOController observe:self.viewmodel keyPath:@"requestError" options:NSKeyValueObservingOptionNew block:^(HSYLearningController *controller, HSYLearningViewmodel *viewmodel, NSDictionary *change) {
        
        [self.refreshControl endRefreshing];
        [self endPullUpRefresh];
        
        FYHintLayer *hint = [[FYHintLayer alloc] initWithMessege:HSYNetworkErrorHint duration:HSYHintDuration complete:nil];
        [hint show];
    }];
}

@end
