//
//  HSYRestViewmodel.m
//  QianHuoClientIOS
//
//  Created by Sean on 16/4/1.
//  Copyright © 2016年 deeepthinking. All rights reserved.
//

#import "HSYRestViewmodel.h"
#import "FYUtils.h"
#import "HSYRestDateModel.h"
#import "AFNetworking.h"
#import "HSYUserDefaults.h"
#import <SDWebImage/UIImageView+WebCache.h>


static NSString * const HSYRestViewmodelOffsetY = @"HSYRestViewmodelOffsetY";
static NSString * const HSYRestViewmodelPageID = @"HSYRestViewmodelPageID";
static int const HSYRestViewmodelPageStep = 10;

@interface HSYRestViewmodel ()

@end

@implementation HSYRestViewmodel

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}


- (NSInteger)sectionsCount {
    return self.dateModels.count;
}

- (NSString*)headerTitleInSection:(NSInteger)section {
    HSYRestDateModel *dateModel = self.dateModels[section];
    return dateModel.headerTitle;
}

- (NSInteger)rowsCountInSection:(NSInteger)section {
    HSYRestDateModel *dateModel = self.dateModels[section];
    return dateModel.cellModels.count;
}

- (NSInteger)rowsFuliCountInSection:(NSInteger)section {
    HSYRestDateModel *dateModel = self.dateModels[section];
    return dateModel.fulis.count;
}

- (NSInteger)rowsVedioCountInSection:(NSInteger)section {
    HSYRestDateModel *dateModel = self.dateModels[section];
    return dateModel.vedios.count;
}

- (UIImage*)rowAvatarAtIndexPath:(NSIndexPath *)indexPath {
    HSYRestDateModel *dateModel = self.dateModels[indexPath.section];
    HSYCommonModel *cellModel = dateModel.cellModels[indexPath.row];
    return [UIImage imageNamed:cellModel.avatarName];
}

- (NSString*)rowDescAtIndexPath:(NSIndexPath *)indexPath {
    HSYRestDateModel *dateModel = self.dateModels[indexPath.section];
    HSYCommonModel *cellModel = dateModel.cellModels[indexPath.row];
    return cellModel.desc;
}

- (NSString*)rowUrlAtIndexPath:(NSIndexPath *)indexPath {
    HSYRestDateModel *dateModel = self.dateModels[indexPath.section];
    HSYCommonModel *cellModel = dateModel.cellModels[indexPath.row];
    return cellModel.url;
}

- (BOOL)rowHasRead:(NSIndexPath *)indexPath {
    HSYRestDateModel *dateModel = self.dateModels[indexPath.section];
    HSYCommonModel *cellModel = dateModel.cellModels[indexPath.row];
    return cellModel.hasRead;
}

- (void)saveRowHasRead:(NSIndexPath *)indexPath {
    HSYRestDateModel *dateModel = self.dateModels[indexPath.section];
    HSYCommonModel *cellModel = dateModel.cellModels[indexPath.row];
    cellModel.hasRead = YES;
    [cellModel update];
}

#pragma mark - Override
- (void)savePage:(NSInteger)section {
    [HSYUserDefaults setInteger:section forKey:HSYRestViewmodelPageID];
}

- (NSInteger)loadPage {
    return [HSYUserDefaults integerForKey:HSYRestViewmodelPageID];
}

- (void)saveOffsetY:(CGFloat)offsetY {
    [HSYUserDefaults setFloat:offsetY forKey:HSYRestViewmodelOffsetY];
}

- (CGFloat)loadOffsetY {
    return [HSYUserDefaults floatForKey:HSYRestViewmodelOffsetY];
}

#pragma HSYLoadValueProtocol
- (void)loadFirstValue {
    self.isFirstLoad = YES;
    self.historys = [HSYUserDefaults objectForKey:HSYHistoryID];
    if (FYEmpty(self.historys)) {
        [self loadNewValue];
    } else {
        self.page = [self loadPage];
        [self requestValueWithPage:0 length:self.page + HSYRestViewmodelPageStep];
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
    self.page = self.page + HSYRestViewmodelPageStep;
    [self requestValueWithPage:self.page length:HSYRestViewmodelPageStep];
    [self savePage:self.page];
}

#pragma HSYBindingParamProtocol
- (void)bindingParam {
    self.KVOController = [FBKVOController controllerWithObserver:self];
    
    [self.KVOController observe:self keyPath:@"requestCount" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld block:^(HSYRestViewmodel *observer, id object, NSDictionary *change) {
        
        NSNumber *oldCount = change[NSKeyValueChangeOldKey];
        oldCount = FYNull(oldCount) ? @(0) : oldCount;
        NSNumber *newCount = change[NSKeyValueChangeNewKey];
        newCount = FYNull(newCount) ? @(0) : newCount;
        if ([oldCount intValue] == 1 && [newCount intValue] == 0) { //网络请求结束
            if (observer.isFirstLoad) {
                [observer loadValueFormDBWithPage:0 length:observer.page + HSYRestViewmodelPageStep];
            } else {
                [observer loadValueFormDBWithPage:observer.page length:HSYRestViewmodelPageStep];
            }
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
        
        [weakSelf requestValueWithPage:weakSelf.page length:HSYRestViewmodelPageStep];

    } failure:^(NSURLSessionTask *operation, NSError *error) {
        FYLog(@"Error: %@", error);
        weakSelf.requestError = error;
    }];
}

- (void)requestValueWithPage:(NSInteger)page length:(NSInteger)length {
    
    NSInteger tempPage = page + length;
    if (tempPage > self.historys.count) {
        length = length - (tempPage - self.historys.count);
    }
    
    NSArray *tempHistoary = [self.historys subarrayWithRange:NSMakeRange(page, length)];
    self.requestCount = @(tempHistoary.count);
    
    FYWeakSelf(weakSelf);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    for (NSString *dateStr in tempHistoary) {
        
        if (![HSYRestDateModel hasValueWithDateStr:dateStr]) {
            
            NSArray *arr = [dateStr componentsSeparatedByString:@"-"];
            NSString *year = arr[0];
            NSString *month = arr[1];
            NSString *day = arr[2];
            
            NSString *urlStr = [NSString stringWithFormat:@"%@/%@/%@/%@", HSYBaseUrl, year, month, day];
            
            NSURL *url = [NSURL URLWithString:urlStr];
            
            [manager GET:url.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
                
                NSDictionary *jsonDict = responseObject;
                NSDictionary *results = jsonDict[@"results"];
                
                [HSYRestDateModel saveWithParams:results dateStr:dateStr];
                
                [weakSelf decRequestCount];
                
            } failure:^(NSURLSessionTask *operation, NSError *error) {
                
                weakSelf.requestError = error;
                
                [weakSelf decRequestCount];
                
                FYLog(@"Error: %@", error);
            }];
        } else {
            [self decRequestCount];
        }
    }
}

- (void)loadValueFormDBWithPage:(NSInteger)page length:(NSInteger)length {
    
    NSMutableArray *tempArr = [[NSMutableArray alloc] initWithCapacity:length];
    
    NSInteger tempPage = page + length;
    if (tempPage > self.historys.count) {
        length = length - (tempPage - self.historys.count);
    }
    
    NSArray *tempHistoary = [self.historys subarrayWithRange:NSMakeRange(page, length)];
    for (NSString *dateStr in tempHistoary) {
        HSYRestDateModel *dateModel = [[HSYRestDateModel alloc] initWithDateStr:dateStr];
        [tempArr addObject:dateModel];
    }
    
    if (page == 0) {
        self.dateModels = tempArr;
    } else {
        self.dateModels = [self.dateModels arrayByAddingObjectsFromArray:tempArr];
    }
}

@end
