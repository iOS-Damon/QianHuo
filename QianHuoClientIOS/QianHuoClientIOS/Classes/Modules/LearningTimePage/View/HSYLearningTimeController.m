//
//  HSYLearningTimeController.m
//  QianHuoClientIOS
//
//  Created by Sean on 16/3/28.
//  Copyright © 2016年 deeepthinking. All rights reserved.
//

#import "HSYLearningTimeController.h"
#import "HSYLearningViewmodel.h"
#import "HSYLearningTimeCell.h"
#import "HSYLearningTimeHeader.h"
#import "UIScreen+FY.h"
#import "HSYBindingParamProtocol.h"
#import "FBKVOController.h"

static NSString * const HSYLearningTimeCellID = @"HSYLearningTimeCellID";
static NSString * const HSYLearningTimeHeaderID = @"HSYLearningTimeHeaderID";
static CGFloat const HSYLearnTimeCellHeightScale = 0.1;
static CGFloat const HSYLearnTimeHeaderHeightScale = 0.05;

@interface HSYLearningTimeController () <HSYBindingParamProtocol>

@property (nonatomic, strong) HSYLearningViewmodel *viewmodel;
@property (nonatomic, strong) FBKVOController *KVOController;

@end

@implementation HSYLearningTimeController

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
    [self.tableView registerClass:[HSYLearningTimeCell class] forCellReuseIdentifier:HSYLearningTimeCellID];
    [self.tableView registerClass:[HSYLearningTimeHeader class] forHeaderFooterViewReuseIdentifier:HSYLearningTimeHeaderID];
    
    [self.refreshControl beginRefreshing];
    [self.viewmodel loadNewValue];
}

- (void)pullRefreshAction:(id)sender {
    FYLog(@"---pullRefreshAction---");
    [self.viewmodel loadNewValue];
}

#pragma mark - TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.viewmodel sectionsCount];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewmodel rowsCountInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HSYLearningTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:HSYLearningTimeCellID forIndexPath:indexPath];
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
    HSYLearningTimeHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HSYLearningTimeHeaderID];
    header.title = [self.viewmodel headerTitleInSection:section];
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - HSYBindingParamProtocol
- (void)bindingParam {
    self.KVOController = [FBKVOController controllerWithObserver:self];
    [self.KVOController observe:self.viewmodel keyPath:@"dateModels" options:NSKeyValueObservingOptionNew block:^(HSYLearningTimeController *controller, HSYLearningViewmodel *viewmodel, NSDictionary *change) {
        
        [controller.tableView reloadData];
        [self.refreshControl endRefreshing];
    }];
}

@end
