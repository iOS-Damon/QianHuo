//
//  HSYLearningTimeViewmodel.m
//  QianHuoClientIOS
//
//  Created by Sean on 16/3/28.
//  Copyright © 2016年 deeepthinking. All rights reserved.
//

#import "HSYLearningViewmodel.h"
#import "HSYLearningMultiModel.h"
#import "HSYBindingParamProtocol.h"
#import "HSYLearningDateModel.h"
#import "FBKVOController.h"
#import "FYUtils.h"

@interface HSYLearningViewmodel () <HSYBindingParamProtocol>

@property (nonatomic, strong) HSYLearningDateModel *dateModel;

@end

@implementation HSYLearningViewmodel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.dateModels = [[NSMutableArray alloc] initWithCapacity:5];
        self.dateModel = [[HSYLearningDateModel alloc] init];
        [self bindingParam];
    }
    return self;
}

- (NSInteger)sectionsCount {
    return self.dateModels.count;
}

- (NSString*)headerTitleInSection:(NSInteger)section {
    HSYLearningDateModel *dateModel = self.dateModels[section];
    return dateModel.title;
}

- (NSInteger)rowsCountInSection:(NSInteger)section {
    HSYLearningDateModel *dateModel = self.dateModels[section];
    return dateModel.cellModels.count;
}

- (UIImage*)rowAvatarAtIndexPath:(NSIndexPath *)indexPath {
    HSYLearningDateModel *dateModel = self.dateModels[indexPath.section];
    HSYLearningCellModel *cellModel = dateModel.cellModels[indexPath.row];
    if ([cellModel.type isEqualToString:@"Android"]) {
        return [UIImage imageNamed:@"AvatarAndroid.png"];
    } else if([cellModel.type isEqualToString:@"iOS"]) {
        return [UIImage imageNamed:@"AvatarIOS.png"];
    } else if([cellModel.type isEqualToString:@"App"]) {
        return [UIImage imageNamed:@""];
    } else if([cellModel.type isEqualToString:@"前端"]) {
        return [UIImage imageNamed:@""];
    } else if([cellModel.type isEqualToString:@"拓展资源"]) {
        return [UIImage imageNamed:@""];
    } else {
    
    }
    return [UIImage imageNamed:@""];
}

- (NSString*)rowDescAtIndexPath:(NSIndexPath *)indexPath {
    HSYLearningDateModel *dateModel = self.dateModels[indexPath.section];
    HSYLearningCellModel *cellModel = dateModel.cellModels[indexPath.row];
    return cellModel.desc;
}

- (NSString*)rowUrlAtIndexPath:(NSIndexPath *)indexPath {
    HSYLearningDateModel *dateModel = self.dateModels[indexPath.section];
    HSYLearningCellModel *cellModel = dateModel.cellModels[indexPath.row];
    return cellModel.url;
}

#pragma mark - HSYTableControllerViewmodelProtocol
- (void)loadNewValue {
    self.dateModel.date = [NSDate date];
    self.dateModel.title = [FYUtils stringWithDate:self.dateModel.date];
    
    HSYLearningCellModel *c1 = [[HSYLearningCellModel alloc] init];
    c1.type = @"iOS";
    c1.desc = @"的风格好几个号即可";
    c1.url = @"baidu.com";
    self.dateModel.cellModels = @[c1];
}

- (void)loadMoreValue {

}

#pragma mark - HSYBindingParamProtocol
- (void)bindingParam {
    FBKVOController *KVOController = [FBKVOController controllerWithObserver:self];
    [KVOController observe:self.dateModel keyPath:@"date" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew block:^(HSYLearningViewmodel *observer, HSYLearningDateModel *object, NSDictionary *change) {
        
        [self.dateModels addObject:self.dateModel];
    }];
}

@end
