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
    self.page = FYNum(page);
    self.isFirstLoad = YES;
}

- (void)loadNewValue {
    self.page = FYNum(0);
    [self savePage:[self.page integerValue]];
}

- (void)loadMoreValue {
    self.page = FYNum([self.page integerValue] + HSYLearningViewmodelPageStep);
    [self savePage:[self.page integerValue]];
}

#pragma HSYBindingParamProtocol
- (void)bindingParam {
    
    self.KVOController = [FBKVOController controllerWithObserver:self];
    [self.KVOController observe:self keyPath:@"page" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld block:^(HSYLearningViewmodel *observer, id object, NSDictionary *change) {
        
        NSNumber *oldPage = change[NSKeyValueChangeOldKey];
        oldPage = FYNull(oldPage) ? FYNum(0) : oldPage;
        NSNumber *newPage = change[NSKeyValueChangeNewKey];
        newPage = FYNull(newPage) ? FYNum(0) : newPage;
        
        if ([newPage intValue] == 0) {
            [observer requestHistory];
        } else {
            [observer requestValueWithPage:[newPage integerValue] length:HSYLearningViewmodelPageStep];
        }
    }];
    
    [self.KVOController observe:self keyPath:@"requestCount" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld block:^(HSYLearningViewmodel *observer, id object, NSDictionary *change) {
        
        NSNumber *oldCount = change[NSKeyValueChangeOldKey];
        oldCount = FYNull(oldCount) ? FYNum(0) : oldCount;
        NSNumber *newCount = change[NSKeyValueChangeNewKey];
        newCount = FYNull(newCount) ? FYNum(0) : newCount;
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
    
    NSArray *tempHistoary = [self.historys subarrayWithRange:NSMakeRange(0, page + length)];
    self.requestCount = FYNum(tempHistoary.count);
    
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


//- (void)requestHistory {
//    
//    HSYLearningViewmodel __weak *weakSelf = self;
//    
//    NSURL *url = [NSURL URLWithString:HSYHistoryUrl];
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    [manager GET:url.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
//        
//        NSDictionary *dict = responseObject;
//        NSArray *results = dict[@"results"];
//        
//        weakSelf.historys = results;
//        
//        [HSYUserDefaults setObject:weakSelf.historys forKey:HSYHistoryID];
//        
//    } failure:^(NSURLSessionTask *operation, NSError *error) {
//        FYLog(@"Error: %@", error);
//        weakSelf.requestError = error;
//    }];
//}
//
//- (void)requestFirstValue {
//    
//    if (FYEmpty(self.historys)) {
//        return;
//    }
//    
//    HSYLearningViewmodel __weak *weakSelf = self;
//    
//    NSString *dateStr = self.historys[0];
//    NSArray *arr = [dateStr componentsSeparatedByString:@"-"];
//    NSString *year = arr[0];
//    NSString *month = arr[1];
//    NSString *day = arr[2];
//    
//    NSString *urlStr = [NSString stringWithFormat:@"%@/%@/%@/%@", HSYBaseUrl, year, month, day];
//    
//    NSURL *url = [NSURL URLWithString:urlStr];
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    [manager GET:url.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
//        
//        NSDictionary *jsonDict = responseObject;
//        NSDictionary *results = jsonDict[@"results"];
//        
//        HSYLearningDateModel *dateModel = [[HSYLearningDateModel alloc] initWithParam:results];
//        dateModel.dateStr = dateStr;
//        dateModel.headerTitle = [weakSelf formatWithYear:year month:month day:day];
//        weakSelf.dateModels = @[dateModel];
//        
//        //保存到数据库
//        HSYCommonDBModel *dbModel = [[HSYCommonDBModel alloc] init];
//        dbModel.dateStr = dateStr;
//        dbModel.headerTitle = dateModel.headerTitle;
//        dbModel.results = [FYUtils JSONStringWithDictionary:results];
//        [dbModel saveOrUpdate];
//        
//        self.page = 1;
//        
//    } failure:^(NSURLSessionTask *operation, NSError *error) {
//        FYLog(@"Error: %@", error);
//        self.requestError = error;
//    }];
//}
//
//- (void)requestMoreValue {
//    HSYLearningViewmodel __weak *weakSelf = self;
//    
//    if (self.page >= self.historys.count) {
//        return;
//    }
//    
//    NSString *dateStr = self.historys[self.page];
//    NSArray *arr = [dateStr componentsSeparatedByString:@"-"];
//    NSString *year = arr[0];
//    NSString *month = arr[1];
//    NSString *day = arr[2];
//    
//    NSString *urlStr = [NSString stringWithFormat:@"%@/%@/%@/%@", HSYBaseUrl, year, month, day];
//    
//    NSURL *url = [NSURL URLWithString:urlStr];
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    [manager GET:url.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
//        
//        NSDictionary *jsonDict = responseObject;
//        NSDictionary *results = jsonDict[@"results"];
//        
//        HSYLearningDateModel *dateModel = [[HSYLearningDateModel alloc] initWithParam:results];
//        dateModel.dateStr = dateStr;
//        dateModel.headerTitle = [weakSelf formatWithYear:year month:month day:day];
//        
//        //保存到数据库
//        HSYCommonDBModel *dbModel = [[HSYCommonDBModel alloc] init];
//        dbModel.dateStr = dateStr;
//        dbModel.headerTitle = dateModel.headerTitle;
//        dbModel.results = [FYUtils JSONStringWithDictionary:results];
//        [dbModel saveOrUpdate];
//        
//        NSMutableArray *temp = [NSMutableArray arrayWithArray:weakSelf.dateModels];
//        [temp addObject:dateModel];
//        weakSelf.dateModels = temp;
//        
//        self.page = self.page + 1;
//        
//    } failure:^(NSURLSessionTask *operation, NSError *error) {
//        FYLog(@"Error: %@", error);
//        self.requestError = error;
//    }];
//}
//
//#pragma mark - 获取数据库数据
//
//- (void)loadFirstValueFromDB {
//    
//    NSInteger page = [HSYUserDefaults integerForKey:HSYLearningViewmodelSectionID] + 1;
//    NSArray *dbModels = [HSYCommonDBModel findWithFormat:@" LIMIT %ld", page];
//    if (!FYEmpty(dbModels)) {
//        NSMutableArray *temp = [[NSMutableArray alloc] initWithCapacity:5];
//        
//        for (HSYCommonDBModel *dbModel in dbModels) {
//            NSDictionary *dictResult = [FYUtils dictionaryWithJSONString:dbModel.results];
//            
//            HSYLearningDateModel *dateModel = [[HSYLearningDateModel alloc] initWithParam:dictResult];
//            dateModel.dateStr = dbModel.dateStr;
//            dateModel.headerTitle = dbModel.headerTitle;
//            
//            [temp addObject:dateModel];
//        }
//        
//        self.dateModels = temp;
//    } else {
//        [self requestFirstValue];
//    }
//    
//    self.page = (int)page;
//}
//
//- (void)loadMoreValueFromDB {
//    
//    if (self.page >= self.historys.count) {
//        return;
//    }
//    
//    NSString *dateStr = self.historys[self.page];
//    HSYCommonDBModel *dbModel = [HSYCommonDBModel findFirstWithFormat:@" WHERE %@ = '%@'", @"dateStr", dateStr];
//    
//    if (dbModel) {
//        NSDictionary *dictResult = [FYUtils dictionaryWithJSONString:dbModel.results];
//        
//        HSYLearningDateModel *dateModel = [[HSYLearningDateModel alloc] initWithParam:dictResult];
//        dateModel.dateStr = dbModel.dateStr;
//        dateModel.headerTitle = dbModel.headerTitle;
//        
//        NSMutableArray *temp = [NSMutableArray arrayWithArray:self.dateModels];
//        [temp addObject:dateModel];
//        self.dateModels = temp;
//        
//        self.page = self.page + 1;
//    } else {
//        [self requestMoreValue];
//    }
//}
//
//#pragma mark - 获取headerTitle
//- (NSString*)formatWithYear:(NSString*)year month:(NSString*)month day:(NSString*)day {
//    return [NSString stringWithFormat:@"%@年%@月%@日", year, month, day];
//}

@end
