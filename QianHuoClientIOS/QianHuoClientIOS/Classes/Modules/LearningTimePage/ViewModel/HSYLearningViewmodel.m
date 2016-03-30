//
//  HSYLearningTimeViewmodel.m
//  QianHuoClientIOS
//
//  Created by Sean on 16/3/28.
//  Copyright © 2016年 deeepthinking. All rights reserved.
//

#import "HSYLearningViewmodel.h"
#import "HSYBindingParamProtocol.h"
#import "HSYLearningDateModel.h"
#import "FBKVOController.h"
#import "FYUtils.h"
#import "AFNetworking.h"

@interface HSYLearningViewmodel () <HSYBindingParamProtocol>

@property (nonatomic, strong) FBKVOController *KVOController;
@property (nonatomic, strong) NSArray *historys;
@property (nonatomic, assign) int page;

@end

@implementation HSYLearningViewmodel

- (instancetype)init {
    self = [super init];
    if (self) {
        [self bindingParam];
        self.page = 0;
    }
    return self;
}

#pragma mark - 让view获取数据
- (NSInteger)sectionsCount {
    return self.dateModels.count;
}

- (NSString*)headerTitleInSection:(NSInteger)section {
    HSYLearningDateModel *dateModel = self.dateModels[section];
    return dateModel.headerTitle;
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

#pragma mark - HSYLoadValueProtocol
- (void)loadNewValue {
    [self requestHistory];
}

- (void)loadMoreValue {
    [self requestMoreValue];
}

#pragma mark - HSYBindingParamProtocol
- (void)bindingParam {
    
    self.KVOController = [FBKVOController controllerWithObserver:self];
    [self.KVOController observe:self keyPath:@"historys" options:NSKeyValueObservingOptionNew block:^(HSYLearningViewmodel *observer, id object, NSDictionary *change) {
        
        [observer requestNewValue];
    }];
}

#pragma mark - 获取网络数据
- (void)requestHistory {
    
    NSURL *url = [NSURL URLWithString:HSYHistoryUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        NSDictionary *dict = responseObject;
        NSArray *results = dict[@"results"];
        self.historys = results;
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        FYLog(@"Error: %@", error);
        self.requestError = error;
    }];
}

- (void)requestNewValue {
    
    HSYLearningViewmodel __weak *weakSelf = self;
    
    NSString *dateStr = self.historys[0];
    NSArray *arr = [dateStr componentsSeparatedByString:@"-"];
    NSString *year = arr[0];
    NSString *month = arr[1];
    NSString *day = arr[2];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@/%@/%@", HSYBaseUrl, year, month, day];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        NSDictionary *jsonDict = responseObject;
        NSDictionary *results = jsonDict[@"results"];
        
        HSYLearningDateModel *dateModel = [[HSYLearningDateModel alloc] initWithParam:results];
        dateModel.dateStr = dateStr;
        dateModel.headerTitle = [weakSelf formatWithYear:year month:month day:day];
        
        weakSelf.dateModels = @[dateModel];
        
        self.page = 1;
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        FYLog(@"Error: %@", error);
        self.requestError = error;
    }];
}

- (void)requestMoreValue {
    HSYLearningViewmodel __weak *weakSelf = self;
    
    if (self.page >= self.historys.count) {
        return;
    }
    
    NSString *dateStr = self.historys[self.page];
    NSArray *arr = [dateStr componentsSeparatedByString:@"-"];
    NSString *year = arr[0];
    NSString *month = arr[1];
    NSString *day = arr[2];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@/%@/%@", HSYBaseUrl, year, month, day];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        NSDictionary *jsonDict = responseObject;
        NSDictionary *results = jsonDict[@"results"];
        
        HSYLearningDateModel *dateModel = [[HSYLearningDateModel alloc] initWithParam:results];
        dateModel.dateStr = dateStr;
        dateModel.headerTitle = [weakSelf formatWithYear:year month:month day:day];
        
        NSMutableArray *temp = [weakSelf.dateModels mutableCopy];
        [temp addObject:dateModel];
        weakSelf.dateModels = temp;
        
        self.page = self.page + 1;
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        FYLog(@"Error: %@", error);
        self.requestError = error;
    }];
}

#pragma mark - 获取headerTitle
- (NSString*)formatWithYear:(NSString*)year month:(NSString*)month day:(NSString*)day {
    return [NSString stringWithFormat:@"%@年%@月%@日", year, month, day];
}

@end
