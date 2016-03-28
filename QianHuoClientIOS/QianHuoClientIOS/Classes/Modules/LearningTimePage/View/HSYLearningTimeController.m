//
//  HSYLearningTimeController.m
//  QianHuoClientIOS
//
//  Created by Sean on 16/3/28.
//  Copyright © 2016年 deeepthinking. All rights reserved.
//

#import "HSYLearningTimeController.h"
#import "HSYLearningTimeViewmodel.h"
#import "HSYLearningTimeCell.h"
#import "HSYLearningTimeHeader.h"
#import "UIScreen+FY.h"

static NSString * const HSYLearningTimeCellID = @"HSYLearningTimeCellID";
static NSString * const HSYLearningTimeHeaderID = @"HSYLearningTimeHeaderID";
static CGFloat const HSYLearnTimeCellHeightScale = 0.1;
static CGFloat const HSYLearnTimeHeaderHeightScale = 0.05;

@interface HSYLearningTimeController ()

@property (nonatomic, strong) HSYLearningTimeViewmodel *viewmodel;

@end

@implementation HSYLearningTimeController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.viewmodel = [[HSYLearningTimeViewmodel alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[HSYLearningTimeCell class] forCellReuseIdentifier:HSYLearningTimeCellID];
    [self.tableView registerClass:[HSYLearningTimeHeader class] forHeaderFooterViewReuseIdentifier:HSYLearningTimeHeaderID];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HSYLearningTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:HSYLearningTimeCellID forIndexPath:indexPath];
        cell.title = @"这是一个测试";
        cell.avatarImage = [UIImage imageNamed:@"AvatarAndroid.png"];
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
    header.title = @"今天是23";
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
