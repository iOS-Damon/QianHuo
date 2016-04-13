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
#import "HSYCommonDBModel.h"

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
    HSYLearningCellModel *cellModel = dateModel.cellModels[indexPath.row];
    if ([cellModel.type isEqualToString:@"Android"]) {
        return [UIImage imageNamed:@"AvatarAndroid.png"];
    } else if([cellModel.type isEqualToString:@"iOS"]) {
        return [UIImage imageNamed:@"AvatarIOS.png"];
    } else if([cellModel.type isEqualToString:@"App"]) {
        return [UIImage imageNamed:@"AvatarApp.png"];
    } else if([cellModel.type isEqualToString:@"前端"]) {
        return [UIImage imageNamed:@"AvatarHtml.png"];
    } else if([cellModel.type isEqualToString:@"拓展资源"]) {
        return [UIImage imageNamed:@"AvatarResource.png"];
    } else if([cellModel.type isEqualToString:@"瞎推荐"]) {
        return [UIImage imageNamed:@"AvatarIntroduce.png"];
    } else {
        return [UIImage imageNamed:@""];
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

- (BOOL)rowHasRead:(NSIndexPath *)indexPath {
    HSYLearningDateModel *dateModel = self.dateModels[indexPath.section];
    HSYLearningCellModel *cellModel = dateModel.cellModels[indexPath.row];
    return [HSYUserDefaults BoolForKey:cellModel.cellId];
}

- (void)saveRowHasRead:(NSIndexPath *)indexPath {
    HSYLearningDateModel *dateModel = self.dateModels[indexPath.section];
    HSYLearningCellModel *cellModel = dateModel.cellModels[indexPath.row];
    [HSYUserDefaults setBool:YES forKey:cellModel.cellId];
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
    
    NSInteger page = [self loadPage];
    self.historys = [HSYUserDefaults objectForKey:HSYHistoryID];
    self.page = @(page);
    self.isFirstLoad = YES;
}

- (void)loadNewValue {
    self.page = @(0);
    [self savePage:[self.page integerValue]];
}

- (void)loadMoreValue {
    self.page = @([self.page integerValue] + HSYLearningViewmodelPageStep);
    [self savePage:[self.page integerValue]];
}

#pragma HSYBindingParamProtocol
- (void)bindingParam {
    
    self.KVOController = [FBKVOController controllerWithObserver:self];
    [self.KVOController observe:self keyPath:@"page" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld block:^(HSYLearningViewmodel *observer, id object, NSDictionary *change) {
        
        NSNumber *oldPage = change[NSKeyValueChangeOldKey];
        oldPage = FYNull(oldPage) ? @(0) : oldPage;
        NSNumber *newPage = change[NSKeyValueChangeNewKey];
        newPage = FYNull(newPage) ? @(0) : newPage;
        
        if ([newPage intValue] == 0) {
            [observer requestHistory];
        } else {
            [observer requestValueWithPage:[newPage integerValue] length:HSYLearningViewmodelPageStep];
        }
    }];
    
    [self.KVOController observe:self keyPath:@"requestCount" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld block:^(HSYLearningViewmodel *observer, id object, NSDictionary *change) {
        
        NSNumber *oldCount = change[NSKeyValueChangeOldKey];
        oldCount = FYNull(oldCount) ? @(0) : oldCount;
        NSNumber *newCount = change[NSKeyValueChangeNewKey];
        newCount = FYNull(newCount) ? @(0) : newCount;
        if ([oldCount intValue] == 1 && [newCount intValue] == 0) { //网络请求结束
            observer.dateModels = [observer loadValueFormDBWithPage:[observer.page intValue] length:HSYLearningViewmodelPageStep];
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
        
        [weakSelf requestValueWithPage:0 length:HSYLearningViewmodelPageStep];
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        FYLog(@"Error: %@", error);
        weakSelf.requestError = error;
    }];
}

- (BOOL)hasValueInDB:(NSString*)dateStr {
    
    HSYCommonDBModel *dbModel = [HSYCommonDBModel findFirstWithFormat:@" WHERE %@ = '%@'", @"dateStr", dateStr];
    if (dbModel) {
        return YES;
    } else {
        return NO;
    }
}

- (void)requestValueWithPage:(NSInteger)page length:(NSInteger)length {
    
    NSInteger tempPage = page + length;
    if (tempPage > self.historys.count) {
        tempPage = self.historys.count;
    }
    
    NSArray *tempHistoary = [self.historys subarrayWithRange:NSMakeRange(0, tempPage)];
    self.requestCount = @(tempHistoary.count);
    
    FYWeakSelf(weakSelf);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    for (NSString *dateStr in tempHistoary) {
        
        if (![self hasValueInDB:dateStr]) {
            
            NSArray *arr = [dateStr componentsSeparatedByString:@"-"];
            NSString *year = arr[0];
            NSString *month = arr[1];
            NSString *day = arr[2];
            
            NSString *urlStr = [NSString stringWithFormat:@"%@/%@/%@/%@", HSYBaseUrl, year, month, day];
            
            NSURL *url = [NSURL URLWithString:urlStr];
            
            [manager GET:url.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
                
                NSDictionary *jsonDict = responseObject;
                NSDictionary *results = jsonDict[@"results"];
                
                //保存到数据库
                HSYCommonDBModel *dbModel = [[HSYCommonDBModel alloc] init];
                dbModel.dateStr = dateStr;
                dbModel.headerTitle = [weakSelf formatWithYear:year month:month day:day];
                dbModel.results = [FYUtils JSONStringWithDictionary:results];
                [dbModel saveOrUpdateByColumnName:@"dateStr" AndColumnValue:dateStr];
                
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

- (NSArray*)loadValueFormDBWithPage:(NSInteger)page length:(NSInteger)length {
    
    
    NSArray *dbModels = [HSYCommonDBModel findWithFormat:@" ORDER BY dateStr DESC LIMIT %ld", page + length];
    NSMutableArray *temp = [[NSMutableArray alloc] initWithCapacity:length];
    
    if (!FYEmpty(dbModels)) {
        
        for (HSYCommonDBModel *dbModel in dbModels) {
            NSDictionary *dictResult = [FYUtils dictionaryWithJSONString:dbModel.results];
            
            HSYLearningDateModel *dateModel = [[HSYLearningDateModel alloc] initWithParam:dictResult];
            dateModel.dateStr = dbModel.dateStr;
            dateModel.headerTitle = dbModel.headerTitle;
            
            [temp addObject:dateModel];
        }
    }
    
    return temp;
}

@end
