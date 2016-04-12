//
//  HSYRestViewmodel.m
//  QianHuoClientIOS
//
//  Created by Sean on 16/4/1.
//  Copyright © 2016年 deeepthinking. All rights reserved.
//

#import "HSYRestViewmodel.h"
#import "HSYCommonDBModel.h"
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
    return dateModel.fuliModels.count + dateModel.vedioModels.count;
}

- (NSInteger)rowsFuliCountInSection:(NSInteger)section {
    HSYRestDateModel *dateModel = self.dateModels[section];
    return dateModel.fuliModels.count;
}

- (NSInteger)rowsVedioCountInSection:(NSInteger)section {
    HSYRestDateModel *dateModel = self.dateModels[section];
    return dateModel.vedioModels.count;
}

- (UIImage*)rowAvatarAtIndexPath:(NSIndexPath *)indexPath {
    
    HSYRestDateModel *dateModel = self.dateModels[indexPath.section];
    
    if (indexPath.row >= dateModel.fuliModels.count) {
        NSInteger vedioIndex = indexPath.row - dateModel.fuliModels.count;
        HSYRestVedioModel *vedioModel = dateModel.vedioModels[vedioIndex];
        if ([vedioModel.type isEqualToString:@"休息视频"]) {
            return [UIImage imageNamed:@"AvatarVedio.png"];
        }
    }
    return nil;
}

- (NSString*)rowDescAtIndexPath:(NSIndexPath *)indexPath {
    
    HSYRestDateModel *dateModel = self.dateModels[indexPath.section];
    if (indexPath.row >= dateModel.fuliModels.count) {
        NSInteger vedioIndex = indexPath.row - dateModel.fuliModels.count;
        HSYRestVedioModel *vedioModel = dateModel.vedioModels[vedioIndex];
        return vedioModel.desc;
    }
    return @"";
}

- (NSString*)rowUrlAtIndexPath:(NSIndexPath *)indexPath {
    
    HSYRestDateModel *dateModel = self.dateModels[indexPath.section];
    if (indexPath.row < dateModel.fuliModels.count) {
        HSYRestFuliModel *fuliModel = dateModel.fuliModels[indexPath.row];
        return fuliModel.url;
    } else {
        NSInteger vedioIndex = indexPath.row - dateModel.fuliModels.count;
        HSYRestVedioModel *vedioModel = dateModel.vedioModels[vedioIndex];
        return vedioModel.url;
    }
    return @"";
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
    self.page = FYNum([self.page integerValue] + HSYRestViewmodelPageStep);
    [self savePage:[self.page integerValue]];
}

#pragma HSYBindingParamProtocol
- (void)bindingParam {
    self.KVOController = [FBKVOController controllerWithObserver:self];
    [self.KVOController observe:self keyPath:@"page" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld block:^(HSYRestViewmodel *observer, id object, NSDictionary *change) {
        
        NSNumber *oldPage = change[NSKeyValueChangeOldKey];
        oldPage = FYNull(oldPage) ? FYNum(0) : oldPage;
        NSNumber *newPage = change[NSKeyValueChangeNewKey];
        newPage = FYNull(newPage) ? FYNum(0) : newPage;
        
        if ([newPage intValue] == 0) {
            [observer requestHistory];
        } else {
            [observer requestValueWithPage:[newPage integerValue] length:HSYRestViewmodelPageStep];
        }
    }];
    
    [self.KVOController observe:self keyPath:@"requestCount" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld block:^(HSYRestViewmodel *observer, id object, NSDictionary *change) {
        
        NSNumber *oldCount = change[NSKeyValueChangeOldKey];
        oldCount = FYNull(oldCount) ? FYNum(0) : oldCount;
        NSNumber *newCount = change[NSKeyValueChangeNewKey];
        newCount = FYNull(newCount) ? FYNum(0) : newCount;
        if ([oldCount intValue] == 1 && [newCount intValue] == 0) { //网络请求结束
            observer.dateModels = [observer loadValueFormDBWithPage:[observer.page intValue] length:HSYRestViewmodelPageStep];
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
        
        [weakSelf requestValueWithPage:0 length:HSYRestViewmodelPageStep];

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
            
            HSYRestDateModel *dateModel = [[HSYRestDateModel alloc] initWithParam:dictResult];
            dateModel.dateStr = dbModel.dateStr;
            dateModel.headerTitle = dbModel.headerTitle;
            
            [temp addObject:dateModel];
        }
    }
    
    return temp;
}

@end
