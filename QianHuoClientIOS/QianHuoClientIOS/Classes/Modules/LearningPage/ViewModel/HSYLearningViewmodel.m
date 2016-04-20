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
#import "HSYUserDefaults.h"
#import "HSYCommenDateModel.h"

static NSString * const HSYLearningViewmodelOffsetY = @"HSYLearningViewmodelOffsetY";
static NSString * const HSYLearningViewmodelPageID = @"HSYLearningViewmodelPageID";
static int const HSYLearningViewmodelPageStep = 10;

@interface HSYLearningViewmodel ()

@end

@implementation HSYLearningViewmodel

- (instancetype)init {
    self = [super init];
    if (self) {

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
    HSYCommonModel *cellModel = dateModel.cellModels[indexPath.row];
    return [UIImage imageNamed:cellModel.avatarName];
}

- (NSString*)rowTitleAtIndexPath:(NSIndexPath *)indexPath {
    HSYLearningDateModel *dateModel = self.dateModels[indexPath.section];
    HSYCommonModel *cellModel = dateModel.cellModels[indexPath.row];
    return cellModel.type;
}

- (NSString*)rowDescAtIndexPath:(NSIndexPath *)indexPath {
    HSYLearningDateModel *dateModel = self.dateModels[indexPath.section];
    HSYCommonModel *cellModel = dateModel.cellModels[indexPath.row];
    return cellModel.desc;
}

- (NSString*)rowUrlAtIndexPath:(NSIndexPath *)indexPath {
    HSYLearningDateModel *dateModel = self.dateModels[indexPath.section];
    HSYCommonModel *cellModel = dateModel.cellModels[indexPath.row];
    return cellModel.url;
}

- (BOOL)rowHasRead:(NSIndexPath *)indexPath {
    HSYLearningDateModel *dateModel = self.dateModels[indexPath.section];
    HSYCommonModel *cellModel = dateModel.cellModels[indexPath.row];
    return cellModel.hasRead;
}

- (void)saveRowHasRead:(NSIndexPath *)indexPath {
    HSYLearningDateModel *dateModel = self.dateModels[indexPath.section];
    HSYCommonModel *cellModel = dateModel.cellModels[indexPath.row];
    cellModel.hasRead = YES;
    [cellModel update];
}

- (BOOL)rowIsLike:(NSIndexPath *)indexPath {
    HSYLearningDateModel *dateModel = self.dateModels[indexPath.section];
    HSYCommonModel *cellModel = dateModel.cellModels[indexPath.row];
    return cellModel.isLike;
}

- (void)saveRowIsLike:(BOOL)isLike indexPath:(NSIndexPath *)indexPath {
    HSYLearningDateModel *dateModel = self.dateModels[indexPath.section];
    HSYCommonModel *cellModel = dateModel.cellModels[indexPath.row];
    cellModel.isLike = isLike;
    [cellModel update];
}

#pragma mark - override
- (void)savePage:(NSInteger)section {
    [HSYUserDefaults setInteger:section forKey:HSYLearningViewmodelPageID];
}

- (NSInteger)loadPage {
    return [HSYUserDefaults integerForKey:HSYLearningViewmodelPageID];
}

- (void)saveOffsetY:(CGFloat)offsetY {
    [HSYUserDefaults setFloat:offsetY forKey:HSYLearningViewmodelOffsetY];
}

- (CGFloat)loadOffsetY {
    return [HSYUserDefaults floatForKey:HSYLearningViewmodelOffsetY];
}

#pragma HSYLoadValueProtocol
- (void)loadFirstValue {
    self.isFirstLoad = YES;
    self.historys = [HSYUserDefaults objectForKey:HSYHistoryID];
    if (FYEmpty(self.historys)) {
        [self loadNewValue];
    } else {
        self.page = [self loadPage];
        [self requestValueWithPage:0 length:self.page + HSYLearningViewmodelPageStep];
    }
}

- (void)loadNewValue {
    self.isFirstLoad = NO;
    self.page = 0;
    [self requestHistory];
    [self savePage:self.page];
}

- (void)loadMoreValue {
    self.isFirstLoad = NO;
    [self requestValueWithPage:self.page length:HSYLearningViewmodelPageStep];
    [self savePage:self.page];
}

#pragma HSYBindingParamProtocol
- (void)bindingParam {
    
    self.KVOController = [FBKVOController controllerWithObserver:self];
    
    [self.KVOController observe:self keyPath:@"requestCount" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld block:^(HSYLearningViewmodel *observer, id object, NSDictionary *change) {
        
        NSNumber *oldCount = change[NSKeyValueChangeOldKey];
        oldCount = FYNull(oldCount) ? @(0) : oldCount;
        NSNumber *newCount = change[NSKeyValueChangeNewKey];
        newCount = FYNull(newCount) ? @(0) : newCount;
        if ([oldCount intValue] == 1 && [newCount intValue] == 0) { //网络请求结束
            if (observer.isFirstLoad) {
                [observer loadValueFormDBWithPage:0 length:observer.page + HSYLearningViewmodelPageStep];
            } else {
                [observer loadValueFormDBWithPage:observer.page length:HSYLearningViewmodelPageStep];
            }
            observer.page = observer.page + HSYLearningViewmodelPageStep;
        }
    }];
}

#pragma mark - 获取数据
- (void)requestHistory {
    
    FYWeakSelf(weakSelf);
    
    NSURL *url = [NSURL URLWithString:HSYHistoryUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        NSDictionary *dict = responseObject;
        NSArray *results = dict[@"results"];
        
        weakSelf.historys = results;
        [HSYUserDefaults setObject:weakSelf.historys forKey:HSYHistoryID];
        
        [weakSelf requestValueWithPage:weakSelf.page length:HSYLearningViewmodelPageStep];
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        FYLog(@"Error: %@", error);
        weakSelf.requestError = error;
    }];
}

- (void)requestValueWithPage:(NSInteger)page length:(NSInteger)length {
    
    if (page > self.historys.count) {
        self.noMore = YES;
        return;
    }
    
    NSInteger tempPage = page + length;
    if (tempPage > self.historys.count) {
        length = length - (tempPage - self.historys.count);
    }
    
    NSArray *tempHistoary = [self.historys subarrayWithRange:NSMakeRange(page, length)];
    self.requestCount = @(tempHistoary.count);
    
    FYWeakSelf(weakSelf);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    for (NSString *dateStr in tempHistoary) {
        
        if (![HSYLearningDateModel hasValueWithDateStr:dateStr]) {
            
            NSArray *arr = [dateStr componentsSeparatedByString:@"-"];
            NSString *year = arr[0];
            NSString *month = arr[1];
            NSString *day = arr[2];
            
            NSString *urlStr = [NSString stringWithFormat:@"%@/%@/%@/%@", HSYBaseUrl, year, month, day];
            
            NSURL *url = [NSURL URLWithString:urlStr];
            
            [manager GET:url.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
                
                NSDictionary *jsonDict = responseObject;
                NSDictionary *results = jsonDict[@"results"];
                
                [HSYLearningDateModel saveWithParams:results dateStr:dateStr];
                
                [weakSelf decRequestCount];
                
            } failure:^(NSURLSessionTask *operation, NSError *error) {
                
                weakSelf.requestError = error;
                
                FYLog(@"Error: %@", error);
            }];
        } else {
            [self decRequestCount];
        }
    }
}

- (void)loadValueFormDBWithPage:(NSInteger)page length:(NSInteger)length {
    
    if (page > self.historys.count) {
        self.noMore = YES;
        return;
    }
    
    NSInteger tempPage = page + length;
    if (tempPage > self.historys.count) {
        length = length - (tempPage - self.historys.count);
        self.noMore = YES;
    }
    
    NSMutableArray *tempArr = [[NSMutableArray alloc] initWithCapacity:length];
    
    NSArray *tempHistoary = [self.historys subarrayWithRange:NSMakeRange(page, length)];
    for (NSString *dateStr in tempHistoary) {
        HSYLearningDateModel *dateModel = [[HSYLearningDateModel alloc] initWithDateStr:dateStr];
        [tempArr addObject:dateModel];
    }
    
    if (page == 0) {
        self.dateModels = tempArr;
    } else {
        self.dateModels = [self.dateModels arrayByAddingObjectsFromArray:tempArr];
    }
}

@end
