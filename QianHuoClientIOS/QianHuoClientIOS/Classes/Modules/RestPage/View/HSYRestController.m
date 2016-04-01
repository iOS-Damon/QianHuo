//
//  HSYRestTimeController.m
//  QianHuoClientIOS
//
//  Created by Sean on 16/3/28.
//  Copyright © 2016年 deeepthinking. All rights reserved.
//

#import "HSYRestController.h"
#import "HSYLoadValueProtocol.h"
#import "HSYRestFuliCell.h"
#import "UIScreen+FY.h"
#import "HSYLearningHeader.h"

static NSString * const HSYRestFuliCellID = @"HSYRestFuliCellID";
static NSString * const HSYRestHeaderID = @"HSYRestHeaderID";
static CGFloat const HSYRestFuliCellHeightScale = 0.4;

@interface HSYRestController () <HSYLoadValueProtocol>

@end

@implementation HSYRestController

- (instancetype)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[HSYRestFuliCell class] forCellReuseIdentifier:HSYRestFuliCellID];
    [self.tableView registerClass:[HSYLearningHeader class] forHeaderFooterViewReuseIdentifier:HSYRestHeaderID];
}

- (void)loadFirstValue {

}

- (void)loadNewValue {

}

- (void)loadMoreValue {

}

- (void)pullDownRefresh:(id)sender {

}

- (void)pullUpRefresh:(id)sender {

}

#pragma mark - TableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HSYRestFuliCell *fuliCell = [tableView dequeueReusableCellWithIdentifier:HSYRestFuliCellID forIndexPath:indexPath];
    
    return fuliCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [UIScreen screenLongSide] * HSYRestFuliCellHeightScale;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [UIScreen screenLongSide] * HSYHeaderHeightScale;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HSYLearningHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HSYRestHeaderID];
    header.title = @"2016年03月29日";
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
